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
    kSuccess,
    kHasRoute,      // 有待选择的部门
    kHasEmployee    // 有待选择的人员
}BLMatterOperationServiceRetCode;


/** Blocks **/
typedef void(^BLMatterOprationServiceGeneralListBlock)(NSArray *list, NSError *error);

typedef void(^BLMatterOprationServiceDownloadFileBlock)(NSString *localFilePath, NSError *error);

typedef void(^BLMOSSubmitCallBackBlock)(NSInteger retCode, NSArray *list, NSString *title);


/** Interface **/
@interface BLMatterOperationService : NSObject

//- (void)submitMatterWithComment:(NSString *)comment
//                    commentList:(NSArray *)commentList
//                          block:(BLMOSSubmitCallBackBlock)block;

//- (void)submitMatterWithComment:(NSString *)comment
//                    commentList:(NSArray *)commentList
//                      routeList:(NSArray *)routList
//                          block:(BLMOSSubmitCallBackBlock)block;

- (void)submitMatterWithComment:(NSString *)comment
                    commentList:(NSArray *)commentList
                      routeList:(NSArray *)routList
                   employeeList:(NSArray *)employeeList
                          block:(BLMOSSubmitCallBackBlock)block;

- (void)downloadMatterMainBodyFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block;

- (void)downloadMatterAttachmentFileFromURL:(NSString *)urlString withBlock:(BLMatterOprationServiceDownloadFileBlock)block;

//- (void)matterAttachmentListWithBlock:(BLMatterOprationServiceGeneralListBlock)block;

- (void)folloDepartmentWithBlock:(BLMatterOprationServiceGeneralListBlock)block;

@end
