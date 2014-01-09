//
//  BLMatterHTTPLogic.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BLMIHLReadMatterStatus : NSUInteger{
    kToRead,  // 待阅
    kRead     // 已阅
}BLMIHLReadMatterStatus;

typedef enum BLMIHLMatterType : NSUInteger {
    kInDoc,       // 收文
    kGiveRemark,  // 呈批件
    kFull
}BLMIHLMatterType;

typedef enum BLMIHLMatterStatus : NSUInteger {
    kTodo,  // 待办
    kTaken  // 已办
}BLMIHLMatterStatus;

typedef enum BLMIHLAtaachType : NSUInteger {
    kAttach,  // 普通附件
    kMainDoc  // 正文附件
}BLMIHLAtaachType;

typedef void(^BLMatterHTTPLogicGeneralBlock)(id responseData, NSError *error);
typedef void(^BLMatterHTTPLogicAttachDownloadBlock)(NSString *zipFileLocalPath, NSError *error);

@class BLContextEntity;

@interface BLMatterInfoHTTPLogic : NSObject

/**
 *  判断服务器是否已准备好了待下载的文件（同步方法，阻塞当前线程）
 *
 *  @param attachID   附件 ID
 *  @param attachName 附件文件名称
 *
 *  @return 是否有准备好
 */
+ (NSDictionary *)isReadyForDownloadWithAttachID:(NSString *)attachID
                                            name:(NSString *)attachName
                                          userID:(NSString *)userID
                                      attachType:(BLMIHLAtaachType)attachType;

+ (NSURLSessionDownloadTask *)downloadFileWithAttachID:(NSString *)attachID
                                              fileType:(NSString *)fileType
                                              savePath:(NSString *)savePath
                                              progress:(NSProgress **)progress
                                                 block:(BLMatterHTTPLogicAttachDownloadBlock)block;

// 获取已阅待阅列表
+ (void)readMatterListWithMatterStatus:(BLMIHLReadMatterStatus)status
                                 order:(NSString *)order
                             fromIndex:(NSString *)fromIndex
                               toIndex:(NSString *)toIndex
                               context:(BLContextEntity *)context
                             withBlock:(BLMatterHTTPLogicGeneralBlock)block;
// 获取事宜列表
+ (void)matterListWithMatterType:(BLMIHLMatterType)type
                          status:(BLMIHLMatterStatus)status
                       fromIndex:(NSString *)fromIndex
                         toIndex:(NSString *)toIndex
                         context:(BLContextEntity *)context
                       withBlock:(BLMatterHTTPLogicGeneralBlock)block;

// 详细信息
+ (void)matterDetailWithMatterID:(NSString *)matterID
                         context:(BLContextEntity *)context
                           block:(BLMatterHTTPLogicGeneralBlock)block;

// 流程列表
+ (void)matterFlowWithMatterID:(NSString *)matterID
                       context:(BLContextEntity *)context
                         block:(BLMatterHTTPLogicGeneralBlock)block;

@end
