//
//  BLAttachManageService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-20.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLAttchManageServiceDownloadAttachBlock)(NSString *localFilePath, NSError *error);

@interface BLAttachManageService : NSObject

- (void)downloadMatterAttachmentFileWithAttachID:(NSString *)attachID progress:(NSProgress**)progress block:(BLAttchManageServiceDownloadAttachBlock)block;

- (void)cancelDownloadAttachWithAttachID:(NSString *)attachID;

// 获取附件的本地地址，如果已下载，否则返回 nil
- (NSString *)attachLocalPathWithAttachID:(NSString *)attachID;

// 将下载附件的本地路径保存，下次可直接打开
- (void)saveAttchLocalPath:(NSString *)localPath withAttachID:(NSString *)attachID;
@end
