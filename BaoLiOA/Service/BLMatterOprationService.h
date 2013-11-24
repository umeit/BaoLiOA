//
//  BLMatterOprationService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLMatterOprationServiceGeneralListBlock)(NSArray *list, NSError *error);

@interface BLMatterOprationService : NSObject

- (void)matterFormListWithBlock:(BLMatterOprationServiceGeneralListBlock)block;

@end
