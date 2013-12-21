//
//  BLMatterOprationService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Returns Codes **/
typedef enum BLMatterOperationServiceRetCode : NSInteger {
    kSuccess,       // 成功
    kHasRoute,      // 有待选择的部门
    kHasEmployee    // 有待选择的人员
}BLMatterOperationServiceRetCode;


/** Blocks **/
typedef void(^BLMatterOprationServiceGeneralListBlock)(NSArray *list, NSError *error);

//typedef void(^BLMatterOprationServiceDownloadFileBlock)(NSString *localFilePath, NSError *error);

typedef void(^BLMOSSubmitCallBackBlock)(NSInteger retCode, NSArray *list, NSString *title);

typedef void(^BLMatterOprationServiceGeneralBlock)(id obj, NSError *error);


/** Interface **/
@interface BLMatterOperationService : NSObject

- (void)matterBodyTextWithBodyDocID:(NSString *)docID block:(BLMatterOprationServiceGeneralBlock)block;

- (void)submitMatterWithComment:(NSString *)comment
                    commentList:(NSArray *)commentList
                      routeList:(NSArray *)routList
                   employeeList:(NSArray *)employeeList
                       matterID:(NSString *)matterID
                         flowID:(NSString *)flowID
                          block:(BLMOSSubmitCallBackBlock)block;

//- (void)downloadMatterAttachmentFileWithAttachID:(NSString *)attachID progress:(NSProgress**)progress block:(BLMatterOprationServiceDownloadFileBlock)block;

- (void)folloDepartmentWithBlock:(BLMatterOprationServiceGeneralListBlock)block;

//- (void)stopDownloadWithAttachID:(NSString *)attachID;
@end
