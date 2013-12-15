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


typedef void(^BLMatterHTTPLogicGeneralBlock)(id responseData, NSError *error);
typedef void(^BLMatterHTTPLogicAttachDownloadBlock)(NSString *zipFileLocalPath, NSError *error);

@interface BLMatterInfoHTTPLogic : NSObject

+ (void)downloadFileWithAttachID:(NSString *)attachID
                        fileType:(NSString *)fileType
                        savePath:(NSString *)savePath
                           block:(BLMatterHTTPLogicAttachDownloadBlock)block;

+ (void)matterListWithMatterType:(MatterType)matterType withBlock:(BLMatterHTTPLogicGeneralBlock)block;

+ (void)matterDetailWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralBlock)block;


@end
