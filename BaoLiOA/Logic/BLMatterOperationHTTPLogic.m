//
//  BLMatterOperationHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationHTTPLogic.h"
#import "AFHTTPRequestOperation.h"

#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/DemoData_WebService.asmx?op=%@", s]];

@implementation BLMatterOperationHTTPLogic

+ (void)submitMatterWithUserID:(NSString *)userID
                      userName:(NSString *)userName
                      matterID:(NSString *)matterID
                        flowID:(NSString *)flowID
                     operation:(NSString *)operationType
                       Comment:(NSString *)comment
                   commentList:(NSArray *)commentList
                     routeList:(NSString *)routIDs
                  employeeList:(NSString *)employeeIDs
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
    "</soap:Envelope>",
                          userID,
                          userName,
                          matterID,
                          flowID,
                          operationType,
                          (routIDs ? routIDs : @""),
                          (employeeIDs ? employeeIDs : @""),
                          comment, (commentList ? commentList : @"")];
    
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


#pragma mark - Private

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