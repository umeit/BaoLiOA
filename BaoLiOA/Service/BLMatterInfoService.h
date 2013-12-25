//
//  BLMatterService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLMatterInfoHTTPLogic.h"

#define kBLMatterInfoServiceFormInfo @"kBLMatterInfoServiceFormInfo"
#define kBLMatterInfoServiceOperationInfo @"kBLMatterInfoServiceOperationInfo"
#define kBLMatterInfoServiceAttachInfo @"kBLMatterInfoServiceAttachInfo"
#define kBLMatterInfoServiceBodyDocID @"kBLMatterInfoServiceBodyDocID"
#define kBlMatterInfoServiceAppendInfo @"kBlMatterInfoServiceAppendInfo"
#define kBlMatterInfoServiceReturnDataInfo @"kBlMatterInfoServiceReturnDataInfo"

typedef void(^BLMatterInfoServiceGeneralBlock)(id obj, NSError *error);

@interface BLMatterInfoService : NSObject

/**
 *  获取指定类别「事项」的列表
 *
 *  @param type   类别：收文、呈批件，nil 为所有
 *  @param status 状态：待办、已办
 *  @param block  返回列表数据
 */
- (void)matterListWithType:(BLMIHLMatterType)type
                    status:(BLMIHLMatterStatus)status
                     block:(BLMatterInfoServiceGeneralBlock)block;

/**
 *  获取读事项列别
 *
 *  @param status 状态：已读、未读
 *  @param block  返回列表数据
 */
- (void)readMatterListWithStatus:(BLMIHLReadMatterStatus)status
                           block:(BLMatterInfoServiceGeneralBlock)block;

/**
 *  获取「事项」的详细信息：表单信息、可用操作、附件
 *
 *  @param matterID 事项 ID
 *  @param block    回调
 */
- (void)matterDetailInfoWithMatterID:(NSString *)matterID
                               block:(BLMatterInfoServiceGeneralBlock)block;

- (void)matterFlowWithMatterID:(NSString *)matterID
                         block:(BLMatterInfoServiceGeneralBlock)block;
@end
