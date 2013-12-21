//
//  BLMatterHTTPLogic.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MatterType : NSInteger{
    TodoMatterType,    // 待办
    TakenMatter,       // 已办
    ToReadMaaterType,  // 待阅
    ReadMatterType,    // 已阅
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
 *  类别支持：待办、已办、待阅
 *
 *  @param matterType 类别
 *  @param block      返回响应数据 NSData
 */
+ (void)matterListWithMatterType:(MatterType)matterType
                       withBlock:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)matterDetailWithMatterID:(NSString *)matterID
                           block:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)matterFlowWithMatterID:(NSString *)matterID
                         block:(BLMatterHTTPLogicGeneralBlock)block;

@end
