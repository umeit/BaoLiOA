//
//  BLMatterService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterService.h"
#import "BLMatterHTTPLogic.h"

@implementation BLMatterService

- (void)backlogListWithBlock:(BLMatterServiceBaseListBlock)block
{
    [BLMatterHTTPLogic matterListWithMatterType:BacklogMatter withBlock:^(NSArray *list, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block(list, nil);
        }
    }];
}

- (void)takenMatterWithBlock:(BLMatterServiceBaseListBlock)block
{
    [BLMatterHTTPLogic matterListWithMatterType:TakenMatter withBlock:^(NSArray *list, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block(list, nil);
        }
    }];
}

@end
