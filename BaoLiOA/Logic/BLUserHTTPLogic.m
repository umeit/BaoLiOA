//
//  BLUserHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLUserHTTPLogic.h"
#import "AFHTTPRequestOperation.h"

#define SOAP_URL(s) \
[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/BLOAWebService/BL_WebService.asmx?op=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"ServerAddress"], [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerPort"], s]];

@implementation BLUserHTTPLogic

+ (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(BLUserHTTPLogicGeneralBlock)block
{
    NSString *soapBody = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
                          "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
                          "<soap:Body>" \
                          "<IOSLogin xmlns=\"http://tempuri.org/\">"\
                            "<loginCheckInfo>"\
                                "<UserName>%@</UserName>"\
                                "<PassWord>%@</PassWord>"\
                                "<SimIMSI></SimIMSI>"\
                                "<PhoneIMEI>352343050666419</PhoneIMEI>"\
                                "<PhoneNumber></PhoneNumber>"\
                                "<BindDevice>false</BindDevice>"\
                                "<isNeedCheckCode>false</isNeedCheckCode>"\
                                "<CheckCode></CheckCode>"\
                                "<ClientType>3</ClientType>"\
                            "</loginCheckInfo>"\
                          "</IOSLogin>"\
                          "</soap:Body>"\
                          "</soap:Envelope>", userID, password];
    
    NSMutableURLRequest *request = [BLUserHTTPLogic soapRequestWithURLParam:@"IOSLogin"
                                                                 soapAction:@"http://tempuri.org/IOSLogin"
                                                                   soapBody:soapBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
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
