//
//  BLMatterOprationService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationService.h"
#import "BLMatterInfoHTTPLogic.h"
#import "BLMatterOperationHTTPLogic.h"
#import "RXMLElement.h"
#import "ZipArchive.h"

@implementation BLMatterOperationService

- (void)operationMatterWithAction:(NSString *)actionID
                          comment:(NSString *)comment
                      commentList:(NSString *)commentList
                        routeList:(NSArray *)routList
                     employeeList:(NSArray *)employeeList
                         matterID:(NSString *)matterID
                           flowID:(NSString *)flowID
                    currentNodeID:(NSString *)currentNodeID
                   currentTrackID:(NSString *)currentTrackID
                            block:(BLMOSSubmitCallBackBlock)block
{
    NSMutableString *routIDStr = nil;
    if (routList && [routList count] > 0) {
        routIDStr = [[NSMutableString alloc] init];
        for (NSString *routeID in routList) {
            [routIDStr appendFormat:@"%@,", routeID];
        }
    }
    
    NSMutableString *employeeIDStr = nil;
    if (employeeList && [employeeList count] > 0) {
        employeeIDStr = [[NSMutableString alloc] init];
        for (NSString *employyeID in employeeList) {
            [employeeIDStr appendFormat:@"%@,", employyeID];
        }
    }
    
    NSData *contextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Context"];
    BLContextEntity *context = [NSKeyedUnarchiver unarchiveObjectWithData:contextData];
    
    [BLMatterOperationHTTPLogic submitMatterWithContext:context matterID:matterID flowID:flowID
    operation:actionID Comment:comment commentList:commentList routeList:[routIDStr substringToIndex:[routIDStr length] - 1]
    employeeList:[employeeIDStr substringToIndex:[employeeIDStr length] - 1] currentNodeID:currentNodeID currentTrackID:currentTrackID
    block:^(id responseData, NSError *error) {
                                                     
        if (error) {
            block(kNetworkingError, nil, nil);
        }
        else {
            NSLog(@"Response Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
         
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
         
            BOOL isExcuted = [[rootElement child:@"Body.DoActionResponse.DoActionResult.IsExcuted"].text boolValue];
            
            // 执行失败
            if (!isExcuted) {
                block(kRemoteError, nil, nil);
                return;
            }
            
            
            NSString *retCode = [rootElement child:@"Body.DoActionResponse.DoActionResult.ResultCode"].text;
            NSString *title   = [rootElement child:@"Body.DoActionResponse.DoActionResult.ResultInfo"].text;
         
            // 服务器错误
            if (!retCode || [retCode length] < 1) {
                block(kRemoteError, nil, nil);
                return;
            }
            
            
            // 不能「起草提交」错误
//            if ([retCode integerValue] == 1) {
//                block(kCantDraftError, nil, nil);
//            }
            // 提交办理成功
//            if ([retCode integerValue] == 0) {
//                block(kSuccess, nil, nil);
//            }
            // 解析部门路由数据
            if ([retCode integerValue] == 2) {
                NSString *title = [rootElement child:@"Body.DoActionResponse.DoActionResult.ResultInfo"].text;
             
                NSMutableArray *routList = [[NSMutableArray alloc] init];
             
                [rootElement iterate:@"Body.DoActionResponse.DoActionResult.ListRouteInfo.RouteInfo" usingBlock:^(RXMLElement *e) {
                    [routList addObject:@{@"RouteID": [e child:@"RouteID"].text,
                                          @"RouteName": [e child:@"RouteName"].text}];
                }];
             
                if ([routList count] < 1) {
                    block(kRemoteError, nil, nil);
                } else {
                    block(kHasRoute, routList, title);
                }
                
            }
            // 解析办理人员数据
            else if ([retCode integerValue] == 4) {
                NSString *title = [rootElement child:@"Body.DoActionResponse.DoActionResult.ResultInfo"].text;
             
                NSMutableArray *routList = [[NSMutableArray alloc] init];
             
                [rootElement iterate:@"Body.DoActionResponse.DoActionResult.ListAuthorInfo.AuthorInfo" usingBlock:^(RXMLElement *e) {
                    [routList addObject:@{@"UserID": [e child:@"UserID"].text,
                                       @"UserName": [e child:@"UserName"].text}];
                }];
             
                if ([routList count] < 1) {
                    block(kRemoteError, nil, nil);
                } else {
                    block(kHasEmployee, routList, title);
                }
            }
            // 其他操作完成
            else {
                block(kSuccess, nil, title);
            }
        }
    }];
}

- (void)matterBodyTextWithBodyDocID:(NSString *)docID block:(BLMatterOprationServiceGeneralBlock)block
{
    [BLMatterOperationHTTPLogic matterBodyTextWithBodyDocID:docID blcok:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSString *bodyText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            bodyText = [rootElement child:@"Body.GetWord_TextResponse.GetWord_TextResult"].text;
            
            if (bodyText) {
                block(bodyText, nil);
            }
        }
    }];
}
@end
