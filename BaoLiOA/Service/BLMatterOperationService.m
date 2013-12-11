//
//  BLMatterOprationService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationService.h"
#import "BLMatterHTTPLogic.h"

@implementation BLMatterOperationService

- (void)downloadMatterMainBodyFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block
{
    block(@"path", nil);
}

- (void)downloadMatterAttachmentFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block
{
    
    NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                                NSUserDomainMask,
                                                                                                YES) firstObject]];
    [BLMatterHTTPLogic downloadFileFromURL:urlString toPath:(NSString *)documentsDirectoryPath  withBlock:^(id responseData, NSError *error) {
        block([documentsDirectoryPath path], nil);
    }];
}

//- (void)matterAttachmentListWithBlock:(BLMatterOprationServiceGeneralListBlock)block
//{
//    
//}

- (void)folloDepartmentWithBlock:(BLMatterOprationServiceGeneralListBlock)block
{
    block(@[@"商务部", @"人事部"], nil);
}
@end
