//
//  BLMatterOperationHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationHTTPLogic.h"
#import "AFHTTPRequestOperation.h"
#import "BLContextEntity.h"

#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http:/%@:%@/BLOAWebService/BL_WebService.asmx?op=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"ServerAddress"], [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerPort"], s]];

//#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/DemoData_WebService.asmx?op=%@", s]];

@implementation BLMatterOperationHTTPLogic

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
                          block:(BLMatterOperationHTTPLogicGeneralBlock)block
{
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<DoAction xmlns=\"http://tempuri.org/\">"\
                "%@"\
                "<docId>%@</docId>"\
                "<flowId>%@</flowId>"\
                "<currentNodeid>%@</currentNodeid>"\
                "<currentTrackid>%@</currentTrackid>"\
                "<ActionName>%@</ActionName>"\
                "<NextNodeId>%@</NextNodeId>"\
                "<SelectAuthorID>%@</SelectAuthorID>"\
                "<Comments>%@</Comments>"\
                "<CommentFieldName>%@</CommentFieldName>"\
                "%@"\
            "</DoAction>"\
        "</soap:Body>"\
    "</soap:Envelope>",
                          [self context:context],
                          matterID,
                          flowID,
                          currentNodeID,
                          currentTrackID,
                          operationType,
                          (routIDs ? routIDs : @""),
                          (employeeIDs ? employeeIDs : @""),
                          comment,
                          (commentList ? commentList : @""),
                          [self eidtFeildList:eidtFieldList]];
    
    NSMutableURLRequest *request = [BLMatterOperationHTTPLogic soapRequestWithURLParam:@"DoAction"
                                                                            soapAction:@"http://tempuri.org/DoAction"
                                                                              soapBody:soapBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void)matterBodyTextWithBodyDocID:(NSString *)docID context:(BLContextEntity *)context blcok:(BLMatterOperationHTTPLogicGeneralBlock)block
{
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
    "<soap:Body>" \
        "<GetWord_Text xmlns=\"http://tempuri.org/\">"\
            "%@"\
            "<docID>%@</docID>"\
        "</GetWord_Text>"\
    "</soap:Body>"\
    "</soap:Envelope>",
    [self context:context], docID];
    
    NSMutableURLRequest *request = [BLMatterOperationHTTPLogic soapRequestWithURLParam:@"GetWord_Text"
                                                                            soapAction:@"http://tempuri.org/GetWord_Text"
                                                                              soapBody:soapBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}


#pragma mark - Private

+ (NSString *)context:(BLContextEntity *)context
{
    NSString *contextString = [NSString stringWithFormat:
                               @"<context>"\
                               "<UserID>%@</UserID>"\
                               "<UserName>%@</UserName>"\
                               "<OA_UserName>%@</OA_UserName>"\
                               "<OA_DeptName></OA_DeptName>"\
                               "<OA_UserId>%@</OA_UserId>"\
                               "<OA_Account>%@</OA_Account>"\
                               "<currentActionDesc>%@</currentActionDesc>"\
                               "<currentDocId></currentDocId>"\
                               "<currentFileId></currentFileId>"\
                               "<currentAttId></currentAttId>"\
                               "<currentreportID></currentreportID>"\
                               "<currentreportName></currentreportName>"\
                               "</context>",
                               context.userID, context.userName, context.oaUserName, context.oaUserID, context.oaAccount, context.actionDesc];
    return contextString;
}

+ (NSString *)eidtFeildList:(NSArray *)eidtFeildList
{
    NSString *s = @"";
    for (NSDictionary *dic in eidtFeildList) {
        NSString *eidtFeild = [NSString stringWithFormat:
                               @"<EditField>"\
                               "<Key>%@</Key>"\
                               "<Mode></Mode>"\
                               "<Sign></Sign>"\
                               "<Input>11</Input>"\
                               "<Value>%@</Value>"\
                               "<FieldType></FieldType>"\
                               "</EditField>",
                               dic[@"key"], dic[@"value"]];
         s = [s stringByAppendingString:eidtFeild];
    }
    
    NSString *eidtFeildListString = [NSString stringWithFormat:
    @"<editFields>"\
    "%@"\
    "</editFields>", s];
    
    return eidtFeildListString;
}

+ (NSMutableURLRequest *)soapRequestWithURLParam:(NSString *)urlParam
                                      soapAction:(NSString *)actionName
                                        soapBody:(NSString *)body
{
    NSURL *url = SOAP_URL(urlParam);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *soapBody = body;
    
    [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request addValue:actionName forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    return request;
}

@end
