//
//  BLMatterOperationHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationHTTPLogic.h"

@implementation BLMatterOperationHTTPLogic

+ (void)submitMatterWithUserID:(NSString *)userID
                      userName:(NSString *)userName
                      matterID:(NSString *)matterID
                        flowID:(NSString *)flowID
                     operation:(NSString *)operation
                       Comment:(NSString *)comment
                   commentList:(NSArray *)commentList
                     routeList:(NSArray *)routList
                  employeeList:(NSArray *)employeeList
                         block:(BLMatterOperationHTTPLogicGeneralBlock)block
{
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<DoAction xmlns=\"http://tempuri.org/\">"\
                "<userID>%@</userID>"\
                "<userName>%@</userName>"\
                "<docId>%@</docId>"\
                "<flowId>%@</flowId>"\
                "<ActionName>%@</ActionName>"\
                "<NextNodeId>%@</NextNodeId>"\
                "<SelectAuthorID>%@</SelectAuthorID>"\
                "<Comments>%@</Comments>"\
                "<CommentFieldName>%@</CommentFieldName>"\
            "</DoAction>"\
        "</soap:Body>"\
    "</soap:Envelope>", userID, userName, matterID, flowID, operation, routList, employeeList, comment, commentList];
    
    
}

@end
