//
//  BLMatterOprationService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationService.h"
#import "BLMatterInfoHTTPLogic.h"
#import "BLMatterOperationHTTPLogic.h"
#import "RXMLElement.h"
#import "ZipArchive.h"

@interface BLMatterOperationService ()

@property (strong, nonatomic) NSMutableDictionary *downloadDictionary;

@end

@implementation BLMatterOperationService

- (id)init
{
    self = [super init];
    if (self) {
        _downloadDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)matterBodyTextWithBodyDocID:(NSString *)docID block:(BLMatterOprationServiceGeneralBlock)block
{
    [BLMatterOperationHTTPLogic matterBodyTextWithBodyDocID:docID blcok:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSString *bodyText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            bodyText = [rootElement child:@"Body.GetWord_TextResponse.GetWord_TextResult"].text;
            
            if (bodyText) {
                block(bodyText, nil);
            }
        }
    }];
}

- (void)submitMatterWithComment:(NSString *)comment
                    commentList:(NSArray *)commentList
                      routeList:(NSArray *)routList
                   employeeList:(NSArray *)employeeList
                       matterID:(NSString *)matterID
                         flowID:(NSString *)flowID
                          block:(BLMOSSubmitCallBackBlock)block
{
    NSString *userID = @"admin";
    NSString *userName = @"管理员";
    
    NSMutableString *routIDStr = nil;
    if (routList && [routList count] > 0) {
        routIDStr = [[NSMutableString alloc] init];
        for (NSString *routeID in routList) {
            [routIDStr appendFormat:@"%@,", routeID];
        }
    }
    
    NSMutableString *employeeIDStr = nil;
    if (employeeList && [employeeList count] > 0) {
        employeeIDStr = [[NSMutableString alloc] init];
        for (NSString *employyeID in employeeList) {
            [employeeIDStr appendFormat:@"%@,", employyeID];
        }
    }
    
    
    [BLMatterOperationHTTPLogic submitMatterWithUserID:userID
                                              userName:userName
                                              matterID:matterID
                                                flowID:flowID
                                             operation:@"Submit"
                                               Comment:comment
                                           commentList:commentList
                                             routeList:[routIDStr substringToIndex:[routIDStr length] - 1]
                                          employeeList:[employeeIDStr substringToIndex:[employeeIDStr length] - 1]
                                                 block:^(id responseData, NSError *error) {
                                                     NSLog(@"Response Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                                     
                                                     RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
                                                     
                                                     NSString *retCode = [rootElement child:@"Body.DoActionResponse.ResultCode"].text;
                                                     
                                                     // 提交办理成功
                                                     if ([retCode integerValue] == 0) {
                                                         block(kSuccess, nil, nil);
                                                     }
                                                     // 解析部门路由数据
                                                     else if ([retCode integerValue] == 2) {
                                                         NSString *title = [rootElement child:@"Body.DoActionResponse.ResultInfo"].text;
                                                         
                                                         NSMutableArray *routList = [[NSMutableArray alloc] init];
                                                         
                                                         [rootElement iterate:@"Body.DoActionResponse.listRouteInfo.RouteInfo" usingBlock:^(RXMLElement *e) {
                                                             [routList addObject:@{@"RouteID": [e child:@"RouteID"].text,
                                                                                   @"RouteName": [e child:@"RouteName"].text}];
                                                         }];
                                                         
                                                         block(kHasRoute, routList, title);
                                                     }
                                                     // 解析办理人员数据
                                                     else if ([retCode integerValue] == 4) {
                                                         NSString *title = [rootElement child:@"Body.DoActionResponse.ResultInfo"].text;
                                                         
                                                         NSMutableArray *routList = [[NSMutableArray alloc] init];
                                                         
                                                         [rootElement iterate:@"Body.DoActionResponse.listAuthorInfo.AuthorInfo" usingBlock:^(RXMLElement *e) {
                                                             [routList addObject:@{@"UserID": [e child:@"UserID"].text,
                                                                                   @"UserName": [e child:@"UserName"].text}];
                                                         }];
                                                         
                                                         block(kHasEmployee, routList, title);
                                                     }
                                                     
    }];
}

- (void)downloadMatterAttachmentFileWithAttachID:(NSString *)attachID
                                        progress:(NSProgress **)progress
                                           block:(BLMatterOprationServiceDownloadFileBlock)block
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

- (void)stopDownloadWithAttachID:(NSString *)attachID
{
    NSURLSessionDownloadTask *downloadTask = self.downloadDictionary[attachID];
    [downloadTask cancel];
}

- (void)folloDepartmentWithBlock:(BLMatterOprationServiceGeneralListBlock)block
{
    block(@[@"商务部", @"人事部"], nil);
}
@end
