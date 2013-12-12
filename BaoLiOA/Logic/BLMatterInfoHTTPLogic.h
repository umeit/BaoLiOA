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

//typedef void(^BLMatterHTTPLogicGeneralListBlock)(id responselist, NSError *error);
typedef void(^BLMatterHTTPLogicGeneralBlock)(id responseData, NSError *error);

@interface BLMatterInfoHTTPLogic : NSObject

+ (void)matterListWithMatterType:(MatterType)matterType withBlock:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)downloadFileFromURL:(NSString *)filePath toPath:(NSString *)localPath withBlock:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)matterDetailWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralBlock)block;


@end
