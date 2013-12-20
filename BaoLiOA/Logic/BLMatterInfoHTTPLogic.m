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

// 测试文件下载地址
#define Attach_File_URL(id, type) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/Files/%@.%@", id, type]];
@implementation BLMatterInfoHTTPLogic

+ (NSURLSessionDownloadTask *)downloadFileWithAttachID:(NSString *)attachID
                                              fileType:(NSString *)fileType
                                              savePath:(NSString *)savePath
                                              progress:(NSProgress **)progress
                                                 block:(BLMatterHTTPLogicAttachDownloadBlock)block
{
    // http://210.51.191.244:XX/OAWebService/Files/HZ456b4132133680014249e86fad23d1.zip
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *attachFileRemoteURL = Attach_File_URL(attachID, fileType);
    NSURLRequest *request = [NSURLRequest requestWithURL:attachFileRemoteURL];
    
    // 保存文件
    NSURL * (^DestinationBlock)(NSURL *__strong, NSURLResponse *__strong) =
    ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *attachFileLocalURL = [NSURL fileURLWithPath:savePath];
        return [attachFileLocalURL URLByAppendingPathComponent:[response suggestedFilename]];
    };
    
    // 下载完成
    void (^completionHandlerBlock)(NSURLResponse *__strong, NSURL *__strong, NSError *__strong) =
    ^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block([filePath absoluteString], nil);
        }
    };
    
    // 开始下载
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:progress
                                                                  destination:DestinationBlock
                                                            completionHandler:completionHandlerBlock];
    [downloadTask resume];
    return downloadTask;
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

+ (void)matterFlowWithMatterID:(NSString *)matterID block:(BLMatterHTTPLogicGeneralBlock)block
{
    NSString *soapBody =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<GetDocFlow xmlns=\"http://tempuri.org/\">"\
                "<docID>%@</docID>"\
            "</GetDocFlow>"\
        "</soap:Body>"\
    "</soap:Envelope>";
    
    NSString *soapBodyComplete = [NSString stringWithFormat:soapBody, matterID];
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:@"GetDocFlow"
                                                                       soapAction:@"http://tempuri.org/GetDocFlow"
                                                                         soapBody:soapBodyComplete];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}

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
