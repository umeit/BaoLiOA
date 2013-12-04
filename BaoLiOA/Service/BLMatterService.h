//
//  BLMatterService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLMatterServiceGeneralBlock)(id obj, NSError *error);

@interface BLMatterService : NSObject

- (void)todoListWithBlock:(BLMatterServiceGeneralBlock)block;

- (void)takenMatterWithBlock:(BLMatterServiceGeneralBlock)block;

- (void)matterFormListWithMatterID:(NSString *)matterID block:(BLMatterServiceGeneralBlock)block;

@end
