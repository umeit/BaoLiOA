//
//  BLMatterHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterHTTPLogic.h"
#import "AFHTTPRequestOperation.h"

#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/BL_WebService.asmx?op=%@", s]];

@implementation BLMatterHTTPLogic

+ (void)matterListWithMatterType:(MatterType)matterType withBlock:(BLMatterHTTPLogicGeneralListBlock)block
{
    NSString *soapBody =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<GetDocTodolist xmlns=\"http://tempuri.org/\">"\
                "<userID>admin</userID>"\
                "<orderString></orderString>"\
                "<recordStartIndex>0</recordStartIndex>"\
                "<recordEndIndex>9</recordEndIndex>"\
            "</GetDocTodolist>"\
        "</soap:Body>"\
    "</soap:Envelope>";
    
    NSMutableURLRequest *request = [BLMatterHTTPLogic soapRequestWithURLParam:@"GetDocTodolist"
                                                                   soapAction:@"http://tempuri.org/GetDocTodolist"
                                                                     soapBody:soapBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void)matterFormListWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralListBlock)block
{
    NSString *soapBody =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<GetDocInfo xmlns=\"http://tempuri.org/\">"\
                "<docID>string</docID>"\
                "<userID>admin</userID>"\
                "<userName>管理员</userName>"\
            "</GetDocInfo>"\
        "</soap:Body>"\
    "</soap:Envelope>";
    
    NSMutableURLRequest *request = [BLMatterHTTPLogic soapRequestWithURLParam:@"GetDocInfo"
                                                                   soapAction:@"http://tempuri.org/GetDocInfo"
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

+ (NSMutableURLRequest *)soapRequestWithURLParam:(NSString *)urlParam soapAction:(NSString *)actionName soapBody:(NSString *)body
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
