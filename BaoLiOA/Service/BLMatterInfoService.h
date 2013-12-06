//
//  BLMatterService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBLMatterInfoServiceFormInfo @"kBLMatterInfoServiceFormInfo"
#define kBLMatterInfoServiceOperationInfo @"kBLMatterInfoServiceOperationInfo"
#define kBLMatterInfoServiceAttachInfo @"kBLMatterInfoServiceAttachInfo"

typedef void(^BLMatterInfoServiceGeneralBlock)(id obj, NSError *error);

@interface BLMatterInfoService : NSObject

- (void)todoListWithBlock:(BLMatterInfoServiceGeneralBlock)block;

- (void)takenMatterWithBlock:(BLMatterInfoServiceGeneralBlock)block;

//- (void)matterFormListWithMatterID:(NSString *)matterID
//                             block:(BLMatterInfoServiceGeneralBlock)block;
/**
 *  获取「事项」的详细信息：表单信息、可用操作、附件
 *
 *  @param matterID 事项 ID
 *  @param block    回调
 */
- (void)matterDetailInfoWithMatterID:(NSString *)matterID
                               block:(BLMatterInfoServiceGeneralBlock)block;

@end
