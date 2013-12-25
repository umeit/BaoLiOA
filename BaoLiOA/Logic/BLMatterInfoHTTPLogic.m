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

#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/BL_WebService.asmx?op=%@", s]];
// 测试地址
//#define SOAP_URL(s) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/DemoData_WebService.asmx?op=%@", s]];

// 测试文件下载地址
#define Attach_File_URL(id, type) [NSURL URLWithString:[NSString stringWithFormat:@"http://210.51.191.244:8081/OAWebService/Files/%@.%@", id, type]];
@implementation BLMatterInfoHTTPLogic

+ (NSDictionary *)isReadyForDownloadWithAttachID:(NSString *)attachID name:(NSString *)attachName
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    NSCondition *condition = [[NSCondition alloc] init];
    
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
    "<soap:Body>" \
        "<DownFileIsFinish xmlns=\"http://tempuri.org/\">"\
            "<fileID>%@</fileID>"\
            "<parafileName>%@</parafileName>"\
        "</DownFileIsFinish>"\
    "</soap:Body>"\
    "</soap:Envelope>", attachID, attachName];
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:@"DownFileIsFinish"
                                                                       soapAction:@"http://tempuri.org/DownFileIsFinish"
                                                                         soapBody:soapBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultDic[@"kResponseObject"] = responseObject;
        
        // 发出信号，使线程继续
        [condition lock];
        [condition signal];
        [condition unlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        resultDic[@"kError"] = error;
        
        // 发出信号，使线程继续
        [condition lock];
        [condition signal];
        [condition unlock];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    // 线程等待请求完成
    [condition lock];
    [condition wait];
    [condition unlock];
    
    return resultDic;
}

+ (NSURLSessionDownloadTask *)downloadFileWithAttachID:(NSString *)attachID
                                              fileType:(NSString *)fileType
                                              savePath:(NSString *)savePath
                                              progress:(NSProgress **)progress
                                                 block:(BLMatterHTTPLogicAttachDownloadBlock)block
{
    // http://210.51.191.244:XX/OAWebService/Files/HZ456b4132133680014249e86fad23d1.zip
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request
                                                                     progress:progress
                                                                  destination:DestinationBlock
                                                            completionHandler:completionHandlerBlock];
    [downloadTask resume];
    return downloadTask;
}

+ (void)readMatterListWithMatterStatus:(BLMIHLReadMatterStatus)status
                                 order:(NSString *)order
                             fromIndex:(NSString *)fromIndex
                               toIndex:(NSString *)toIndex withBlock:(BLMatterHTTPLogicGeneralBlock)block
{
    NSString *userID = @"action";
    NSString *listType;
    
    switch (status) {
        case kToRead:
            listType = @"GetDocToReadlist";
            break;
            
        case kRead:
            listType = @"GetDocHasReadlist";
            break;
            
        default:
            break;
    }
    
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<%@ xmlns=\"http://tempuri.org/\">"\
                "<userID>%@</userID>"\
                "<orderString>%@</orderString>"\
                "<recordStartIndex>%@</recordStartIndex>"\
                "<recordEndIndex>%@</recordEndIndex>"\
            "</%@>"\
        "</soap:Body>"\
    "</soap:Envelope>", listType, userID, order, fromIndex, toIndex, listType];
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:listType
                                                          soapAction:[NSString stringWithFormat:@"http://tempuri.org/%@", listType]
                                                          soapBody:soapBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void)matterListWithMatterType:(BLMIHLMatterType)type
                          status:(BLMIHLMatterStatus)status
                       fromIndex:(NSString *)fromIndex
                         toIndex:(NSString *)toIndex
                          userID:(NSString *)userID
                       withBlock:(BLMatterHTTPLogicGeneralBlock)block
{
    
    NSString *modelName = @"";
    NSString *todoFlag = @"";
    
    if (type == kInDoc) {
        modelName = @"收文";
    }
    else if (type == kGiveRemark) {
        modelName = @"呈批件";
    }
    else if (type == kFull) {
        modelName = @"";
    }
    
    if (status == kTodo) {
        todoFlag = @"0";
    }
    else if (status == kTaken) {
        todoFlag = @"1";
    }
    
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "\
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
    "<soap:Body>" \
      "<GetDocListByCondition xmlns=\"http://tempuri.org/\">"\
        "<userID>%@</userID>"\
        "<importance></importance>"\
        "<title></title>"\
        "<modelName>%@</modelName>"\
        "<startTime></startTime>"\
        "<endTime></endTime>"\
        "<dbIdentifier></dbIdentifier>"\
        "<recordStartIndex>%@</recordStartIndex>"\
        "<recordEndIndex>%@</recordEndIndex>"\
        "<todoFlag>%@</todoFlag>"\
      "</GetDocListByCondition>"\
    "</soap:Body>"\
    "</soap:Envelope>", userID, modelName, fromIndex, toIndex, todoFlag];
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:@"GetDocListByCondition"
                                                                       soapAction:@"http://tempuri.org/GetDocListByCondition"
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

+ (void)matterDetailWithMatterID:(NSString *)matterID
                          userID:(NSString *)userID
                        userName:(NSString *)userName
                           block:(BLMatterHTTPLogicGeneralBlock)block
{
    NSString *soapBody = [NSString stringWithFormat:
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" \
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " \
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" \
        "<soap:Body>" \
            "<GetDocInfo xmlns=\"http://tempuri.org/\">" \
                "<docID>%@</docID>" \
                "<userID>%@</userID>" \
                "<userName>%@</userName>" \
            "</GetDocInfo>" \
        "</soap:Body>" \
    "</soap:Envelope>", matterID, userID, userName];
    
    NSMutableURLRequest *request = [BLMatterInfoHTTPLogic soapRequestWithURLParam:@"GetDocInfo"
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
