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

- (void)downloadMatterAttachmentFileWithAttachID:(NSString *)attachID progress:(NSProgress *__autoreleasing *)progress block:(BLAttchManageServiceDownloadAttachBlock)block
{
    // 附件下载到该文件夹
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                            NSUserDomainMask,
                                                                            YES) firstObject];
    
    // 下载附件成功后解压 zip 文件，返回解压出的文件的本地路径
    NSURLSessionDownloadTask *downloadTask = [BLMatterInfoHTTPLogic downloadFileWithAttachID:attachID fileType:@"zip" savePath:documentsDirectoryPath progress:progress block:^(NSString *zipFileLocalPath, NSError *error) {
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
    
    self.downloadDictionary[attachID] = downloadTask;
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
@end
