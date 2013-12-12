//
//  BLMatterHTTPLogic.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterInfoHTTPLogic.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLSessionManager.h"

//#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/BL_WebService.asmx?op=%@", s]];
// 测试地址
#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/DemoData_WebService.asmx?op=%@", s]];

@implementation BLMatterInfoHTTPLogic

+ (void)downloadFileFromURL:(NSString *)filePath toPath:(NSString *)localPath  withBlock:(BLMatterHTTPLogicGeneralBlock)block
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 保存路径
    NSURL * (^DestinationBlock)(NSURL *__strong, NSURLResponse *__strong) =
    ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *savePath = [NSURL URLWithString:localPath];

        
        return [savePath URLByAppendingPathComponent:[response suggestedFilename]];
    };
    
    // 下载完成
    void (^completionHandlerBlock)(NSURLResponse *__strong, NSURL *__strong, NSError *__strong) =
    ^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (error) {
            block(nil, error);
        }
        else {
            block([filePath path], nil);
        }
    };
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:DestinationBlock
                                                            completionHandler:completionHandlerBlock];
    [downloadTask resume];
}

+ (void)matterListWithMatterType:(MatterType)matterType withBlock:(BLMatterHTTPLogicGeneralBlock)block
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
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:@"GetDocTodolist"
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

//+ (void)matterFormListWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralListBlock)block
//{
//    NSString *soapBody =
//    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
//    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
//    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
//        "<soap:Body>" \
//            "<GetDocInfo xmlns=\"http://tempuri.org/\">"\
//                "<docID>%@</docID>"\
//                "<userID>admin</userID>"\
//                "<userName>管理员</userName>"\
//            "</GetDocInfo>"\
//        "</soap:Body>"\
//    "</soap:Envelope>";
//    
//    NSString *soapBodyComplete = [NSString stringWithFormat:soapBody, matterID];
//    
//    NSMutableURLRequest *request = [BLMatterHTTPLogic soapRequestWithURLParam:@"GetDocInfo"
//                                                                   soapAction:@"http://tempuri.org/GetDocInfo"
//                                                                     soapBody:soapBodyComplete];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        block(responseObject, nil);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        block(nil, error);
//    }];
//    
//    [[NSOperationQueue mainQueue] addOperation:operation];
//
//}

+ (void)matterDetailWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralBlock)block
{
    NSString *soapBody =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
    "<soap:Body>" \
    "<GetDocInfo xmlns=\"http://tempuri.org/\">"\
    "<docID>%@</docID>"\
    "<userID>admin</userID>"\
    "<userName>管理员</userName>"\
    "</GetDocInfo>"\
    "</soap:Body>"\
    "</soap:Envelope>";
    
    NSString *soapBodyComplete = [NSString stringWithFormat:soapBody, matterID];
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:@"GetDocInfo"
                                                                   soapAction:@"http://tempuri.org/GetDocInfo"
                                                                     soapBody:soapBodyComplete];
    
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
