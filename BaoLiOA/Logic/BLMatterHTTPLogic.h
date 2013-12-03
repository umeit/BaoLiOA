//
//  BLMatterHTTPLogic.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MatterType : NSInteger{
    TodoMatterType,
    TakenMatter,
    CollectMatter,
    ApproveMatter
}MatterType;

typedef void(^BLMatterHTTPLogicGeneralListBlock)(id responselist, NSError *error);

@interface BLMatterHTTPLogic : NSObject

+ (void)matterListWithMatterType:(MatterType)matterType withBlock:(BLMatterHTTPLogicGeneralListBlock)block;

+ (void)matterFormListWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralListBlock)block;
@end
