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


/** Interface **/
@interface BLMatterOperationHTTPLogic : NSObject

+ (void)submitMatterWithUserID:(NSString *)userID
                      userName:(NSString *)userName
                      matterID:(NSString *)matterID
                        flowID:(NSString *)flowID
                     operation:(NSString *)operationType
                       Comment:(NSString *)comment
                   commentList:(NSArray *)commentList
                     routeList:(NSString *)routIDs
                  employeeList:(NSArray *)employeeIDs
                 currentNodeID:(NSString *)currentNodeID
                currentTrackID:(NSString *)currentTrackID
                          block:(BLMatterOperationHTTPLogicGeneralBlock)block;

+ (void)matterBodyTextWithBodyDocID:(NSString *)docID blcok:(BLMatterOperationHTTPLogicGeneralBlock)block;
@end
