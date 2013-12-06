//
//  BLMatterOprationService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLMatterOprationServiceGeneralListBlock)(NSArray *list, NSError *error);

typedef void(^BLMatterOprationServiceDownloadFileBlock)(NSString *localFilePath, NSError *error);

@interface BLMatterOprationService : NSObject



- (void)downloadMatterMainBodyFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block;

- (void)downloadMatterAttachmentFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block;

//- (void)matterAttachmentListWithBlock:(BLMatterOprationServiceGeneralListBlock)block;

- (void)folloDepartmentWithBlock:(BLMatterOprationServiceGeneralListBlock)block;

@end
