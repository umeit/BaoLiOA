//
//  BLMatterHTTPLogic.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BLMatterInfoHTTPLogicMatterType : NSUInteger{
    kTodoMatterType,    // 待办
    kTakenMatterType,   // 已办
    kToReadMatterType,  // 待阅
    kReadMatterType,    // 已阅
    CollectMatter,
    ApproveMatter
}MatterType;


typedef void(^BLMatterHTTPLogicGeneralBlock)(id responseData, NSError *error);
typedef void(^BLMatterHTTPLogicAttachDownloadBlock)(NSString *zipFileLocalPath, NSError *error);

@interface BLMatterInfoHTTPLogic : NSObject

+ (NSURLSessionDownloadTask *)downloadFileWithAttachID:(NSString *)attachID
                        fileType:(NSString *)fileType
                        savePath:(NSString *)savePath
                        progress:(NSProgress **)progress
                           block:(BLMatterHTTPLogicAttachDownloadBlock)block;

/**
 *  获取事项列表
 *  类别支持：待办、已办、待阅、已阅
 *
 *  @param matterType 类别
 *  @param block      返回响应数据 NSData
 */
+ (void)matterListWithMatterType:(MatterType)matterType
                           order:(NSString *)order
                       fromIndex:(NSString *)fromIndex
                         toIndex:(NSString *)toIndex
                       withBlock:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)matterDetailWithMatterID:(NSString *)matterID
                          userID:(NSString *)userID
                        userName:(NSString *)userName
                           block:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)matterFlowWithMatterID:(NSString *)matterID
                         block:(BLMatterHTTPLogicGeneralBlock)block;

@end
