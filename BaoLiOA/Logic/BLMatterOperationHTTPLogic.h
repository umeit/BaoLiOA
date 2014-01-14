//
//  BLMatterOperationHTTPLogic.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** BLocks **/
typedef void(^BLMatterOperationHTTPLogicGeneralBlock)(id responseData, NSError *error);

@class BLContextEntity;

/** Interface **/
@interface BLMatterOperationHTTPLogic : NSObject

+ (void)submitMatterWithContext:(BLContextEntity *)context
                       matterID:(NSString *)matterID
                         flowID:(NSString *)flowID
                      operation:(NSString *)operationType
                        Comment:(NSString *)comment
                    commentList:(NSString *)commentList
                      routeList:(NSString *)routIDs
                   employeeList:(NSString *)employeeIDs
                  currentNodeID:(NSString *)currentNodeID
                 currentTrackID:(NSString *)currentTrackID
                  eidtFieldList:(NSArray *)eidtFieldList
                            block:(BLMatterOperationHTTPLogicGeneralBlock)block;

+ (void)matterBodyTextWithBodyDocID:(NSString *)docID blcok:(BLMatterOperationHTTPLogicGeneralBlock)block;
@end
