//
//  BLMatterHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterHTTPLogic.h"
#import "AFHTTPRequestOperation.h"

@implementation BLMatterHTTPLogic

+ (void)matterListWithMatterType:(MatterType)matterType withBlock:(BLMatterHTTPLogicBaseListBlock)block
{
    NSURL *url = [NSURL URLWithString:@"http://210.51.191.244:8081/OAWebService/BL_WebService.asmx?op=GetDocTodolist"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
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
    [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request addValue:@"http://tempuri.org/GetDocTodolist" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (responseObject && [responseObject length] > 0) {
            block(responseObject, nil);
//        }
        
//        NSLog(@"JSON: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        
//        RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseObject];
//        
//        [rootElement iterate:@"GetDocTodolistResult.Doc" usingBlock:^(RXMLElement *e) {
//            NSLog(@"%@", e);
//        }];
//        
//        NSLog(@"%@", rootElement);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

@end
