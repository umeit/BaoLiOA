//
//  BLAttachManageService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-20.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLAttachManageService.h"
#import "BLMatterInfoHTTPLogic.h"
#import "ZipArchive.h"
#import "RXMLElement.h"

@interface BLAttachManageService ()

@property (strong, nonatomic) NSMutableDictionary *downloadDictionary;

@end

@implementation BLAttachManageService

- (id)init
{
    self = [super init];
    if (self) {
        _downloadDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)downloadMatterAttachmentFileWithAttachID:(NSString *)attachID
                                      attachName:(NSString *)attachName
                                        progress:(NSProgress *__autoreleasing *)progress
                                           block:(BLAttchManageServiceDownloadAttachBlock)block
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 首先查看服务端是否已生成对应的 zip 文件
        NSDictionary *resultDic = [self isReadyForDownloadWithAttachID:attachID name:attachName];
        NSError *error = resultDic[@"kError"];
        
        if (error) {
            block(nil, error);
        }
        else if ([resultDic[@"kResult"] boolValue]) {
            // 服务器已经准备好待下载的附件
            // 附件下载到该文件夹
            NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                    NSUserDomainMask,
                                                                                    YES) firstObject];
            // 下载附件成功后解压 zip 文件，返回解压出的文件的本地路径
            NSURLSessionDownloadTask *downloadTask = [BLMatterInfoHTTPLogic downloadFileWithAttachID:attachID fileType:@"zip" savePath:documentsDirectoryPath progress:progress block:^(NSString *zipFileLocalPath, NSError *error) {
                // 任务结束
                // 删除保存的下载任务对象
                [self.downloadDictionary removeObjectForKey:attachID];
                
                if (error) {
                    block(nil, error);
                }
                else {
                    // 解压 zip 文件
                    zipFileLocalPath = [zipFileLocalPath substringFromIndex:7];
                    zipFileLocalPath = [zipFileLocalPath stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
                    ZipArchive *zipArchive = [[ZipArchive alloc] init];
                    
                    if ([zipArchive UnzipOpenFile:zipFileLocalPath Password:@"password"]) {
                        if ([zipArchive UnzipFileTo:documentsDirectoryPath overWrite:YES]) {
                            // 返回解压文件的本地路径
                            block([zipArchive.unzippedFiles firstObject], nil);
                        }
                    }
                }
            }];
            // 用附件 ID 为 key，保存下载任务对象
            self.downloadDictionary[attachID] = downloadTask;
        }
        else {
            // 服务器端没有准备好待下载的文件
            block(nil, nil);
        }
    });
}

- (void)cancelDownloadAttachWithAttachID:(NSString *)attachID
{
    NSURLSessionDownloadTask *downloadTask = self.downloadDictionary[attachID];
    [downloadTask cancel];
}

- (NSString *)attachLocalPathWithAttachID:(NSString *)attachID
{
    NSDictionary *savedAttachLocalPaths = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kSavedAttachLocalPaths"];
    NSString *localPath = savedAttachLocalPaths[attachID];
    
    return localPath;
}

- (void)saveAttchLocalPath:(NSString *)localPath withAttachID:(NSString *)attachID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *savedAttachLocalPaths = [(NSMutableDictionary *)[userDefaults dictionaryForKey:@"kSavedAttachLocalPaths"] mutableCopy];
    
    if (!savedAttachLocalPaths) {
        savedAttachLocalPaths = [[NSMutableDictionary alloc] init];
    }
    
    savedAttachLocalPaths[attachID] = localPath;
    [userDefaults setObject:savedAttachLocalPaths forKey:@"kSavedAttachLocalPaths"];
}

- (NSDictionary *)isReadyForDownloadWithAttachID:(NSString *)attachID name:(NSString *)attachName
{
    NSInteger i = 0;
    NSDictionary *resultDic;
    
    while (i < 10) {
        i ++;
        
        resultDic = [BLMatterInfoHTTPLogic isReadyForDownloadWithAttachID:attachID
                                                                     name:attachName];
        if (resultDic[@"kError"]) {
            // 网络出错
            return @{@"kError": resultDic[@"kError"]};
        }
        
        id responseData = resultDic[@"kResponseObject"];
        RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
        if (!rootElement) {
            // 返回数据格式不合法
            return @{@"kResult": @NO};
        }
        
        NSString *boolString = [rootElement child:@"Body.DownFileIsFinishResponse.DownFileIsFinishResult.IsFinished"].text;

        if ([boolString isEqualToString:@"true"]) {
            // 服务器端已经准备好好下载的数据
            return @{@"kResult": @YES};
        }
    }
    
    // 循环 10 次都没有成功，返回 NO
    return @{@"kResult": @NO};
}

@end
