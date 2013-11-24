//
//  BLMatterService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterService.h"
#import "BLMatterHTTPLogic.h"
#import "BLMatterEntity.h"

@implementation BLMatterService

- (void)backlogListWithBlock:(BLMatterServiceBaseListBlock)block
{
    #warning 测试代码
    BLMatterEntity *matterEntity = [[BLMatterEntity alloc] init];
    matterEntity.title = @"asdf";
    matterEntity.receivedDate = [NSDate date];
    matterEntity.matterType = @"收文文";
    matterEntity.flowTimes = 3;
    
    block(@[matterEntity, matterEntity], nil);
    
//    [BLMatterHTTPLogic matterListWithMatterType:BacklogMatter withBlock:^(id responselist, NSError *error) {
//        if (error) {
//            block(nil, error);
//        }
//        else {
//            block(responselist, nil);
//        }
//    }];
}

- (void)takenMatterWithBlock:(BLMatterServiceBaseListBlock)block
{
    [BLMatterHTTPLogic matterListWithMatterType:TakenMatter withBlock:^(id responselist, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block(responselist, nil);
        }
    }];
}

@end
