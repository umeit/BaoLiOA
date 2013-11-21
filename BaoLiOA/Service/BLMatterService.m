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
    [BLMatterHTTPLogic matterListWithMatterType:BacklogMatter withBlock:^(id responselist, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block(responselist, nil);
        }
    }];
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
