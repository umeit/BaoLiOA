//
//  BLMatterOprationService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Returns Codes **/
typedef enum BLMatterOperationServiceRetCode : NSUInteger {
    kRemoteError,     // 服务器错误
    kNetworkingError, // 网络错误
    kCantDraftError,  // 不能起草提交
    kSuccess,         // 成功
    kHasRoute,        // 有待选择的部门
    kHasEmployee      // 有待选择的人员
}BLMatterOperationServiceRetCode;


/** Blocks **/
typedef void(^BLMatterOprationServiceGeneralListBlock)(NSArray *list, NSError *error);

// 操作完成的回调，返回一个列表（部门或员工）list，和是否可以多选 isMultiSelect
typedef void(^BLMOSSubmitCallBackBlock)(NSInteger retCode, NSArray *list, NSString *title, BOOL isMultiSelect);

typedef void(^BLMatterOprationServiceGeneralBlock)(id obj, NSError *error);


/** Interface **/
@interface BLMatterOperationService : NSObject

/**
 *  对事项操作：提交、暂存、回调等
 *
 *  @param actionName   操作
 *  @param comment      意见
 *  @param commentList  回传字段（可能）
 *  @param routList     后续需要办理的部分
 *  @param employeeList 后续需要办理的人员
 *  @param matterID     事项ID
 *  @param flowID       流程ID
 *  @param block        回调
 */
- (void)operationMatterWithAction:(NSString *)actionID
                          comment:(NSString *)comment
                      commentList:(NSString *)commentList
                        routeList:(NSArray *)routList
                     employeeList:(NSArray *)employeeList
                         matterID:(NSString *)matterID
                           flowID:(NSString *)flowID
                    currentNodeID:(NSString *)currentNodeID
                   currentTrackID:(NSString *)currentTrackID
                    eidtFieldList:(NSArray *)eidtFieldList
                            block:(BLMOSSubmitCallBackBlock)block;

/**
 *  根据正文（附件）ID，获取正文的文字内容
 *
 *  @param docID 正文（附件）ID
 *  @param block 返回文字内容
 */
- (void)matterBodyTextWithBodyDocID:(NSString *)docID block:(BLMatterOprationServiceGeneralBlock)block;
@end
