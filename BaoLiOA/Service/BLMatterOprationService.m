//
//  BLMatterOprationService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOprationService.h"

@implementation BLMatterOprationService

- (void)matterFormListWithBlock:(BLMatterOprationServiceGeneralListBlock)block
{
    block(@[@""], nil);
}

- (void)downloadMatterMainBodyFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block
{
    block(@"path", nil);
}
@end
