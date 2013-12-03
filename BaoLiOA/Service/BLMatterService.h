//
//  BLMatterService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLMatterServiceGeneralListBlock)(NSArray *list, NSError *error);

@interface BLMatterService : NSObject

- (void)todoListWithBlock:(BLMatterServiceGeneralListBlock)block;

- (void)takenMatterWithBlock:(BLMatterServiceGeneralListBlock)block;

- (void)matterFormListWithMatterID:(NSString *)matterID block:(BLMatterServiceGeneralListBlock)block;
@end
