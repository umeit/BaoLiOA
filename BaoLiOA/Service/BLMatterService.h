//
//  BLMatterService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLMatterServiceBaseListBlock)(NSArray *list, NSError *error);

@interface BLMatterService : NSObject

- (void)todoListWithBlock:(BLMatterServiceBaseListBlock)block;

- (void)takenMatterWithBlock:(BLMatterServiceBaseListBlock)block;
@end
