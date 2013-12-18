//
//  BLMatterService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterInfoService.h"
#import "BLMatterInfoHTTPLogic.h"
#import "BLMatterEntity.h"
#import "BLMatterFlowEntity.h"
#import "BLFromFieldItemEntity.h"
#import "BLAttachEntity.h"
#import "RXMLElement.h"


@implementation BLMatterInfoService

- (void)todoListWithBlock:(BLMatterInfoServiceGeneralBlock)block
{
    [BLMatterInfoHTTPLogic matterListWithMatterType:TodoMatterType withBlock:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSMutableArray *todoList = [[NSMutableArray alloc] init];
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            [rootElement iterate:@"Body.GetDocTodolistResponse.GetDocTodolistResult.Doc" usingBlock:^(RXMLElement *e) {
                BLMatterEntity *matterEntity = [[BLMatterEntity alloc] init];
                
                matterEntity.matterID = [e child:@"DocID"].text;
                matterEntity.title = [e child:@"DocTitle"].text;
                matterEntity.matterType = [e child:@"DocType"].text;
                matterEntity.from = [e child:@"SendFrom"].text;
                matterEntity.sendTime = [e child:@"SendDate"].text;
//                matterEntity.matterSubType = @"控股公司发文";
//                matterEntity.flag = 1;

                [todoList addObject:matterEntity];
            }];
            
            block(todoList, nil);
        }
    }];
}

- (void)takenMatterWithBlock:(BLMatterInfoServiceGeneralBlock)block
{
    [BLMatterInfoHTTPLogic matterListWithMatterType:TakenMatter withBlock:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block(responseData, nil);
        }
    }];
}

- (void)matterDetailInfoWithMatterID:(NSString *)matterID block:(BLMatterInfoServiceGeneralBlock)block
{
    [BLMatterInfoHTTPLogic matterDetailWithMatterID:matterID block:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSLog(@"Response [Matter Detail Data]: %@", [[NSString alloc] initWithData:responseData
                                                                              encoding:NSUTF8StringEncoding]);
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            if (!rootElement) {
                block(nil, error);
                return;
            }
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            // 解析表单数据
            [dic setObject:[self parseFormData:rootElement] forKey:kBLMatterInfoServiceFormInfo];
            // 操作数据
            [dic setObject:[self parseOperationData:rootElement] forKey:kBLMatterInfoServiceOperationInfo];
            // 附件数据
            [dic setObject:[self parseAttachData:rootElement] forKey:kBLMatterInfoServiceAttachInfo];
            
            block(dic, nil);
        }
    }];
}

- (void)matterFlowWithMatterID:(NSString *)matterID block:(BLMatterInfoServiceGeneralBlock)block
{
    [BLMatterInfoHTTPLogic matterFlowWithMatterID:matterID block:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSLog(@"Response [Matter Flow Data]: %@", [[NSString alloc] initWithData:responseData
                                                                              encoding:NSUTF8StringEncoding]);
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            if (!rootElement) {
                // 获取的数据不合法
                block(nil, error);
                return;
            }

            NSArray *flowList = [self parseMatterFlowData:rootElement];
            
            block(flowList, nil);
        }
    }];
}


#pragma mark - Private

// 解析表单数据
- (NSArray *)parseFormData:(RXMLElement *)rootElement
{
    NSMutableArray *regionList = [[NSMutableArray alloc] init];
    
    [rootElement iterate:@"Body.GetDocInfoResponse.GetDocInfoResult.RegionItems.InfoRegion"
              usingBlock:^(RXMLElement *regionInfoElement) {
                  
                  // 解析一个 Region 中的所有 Field 数据
                  NSMutableArray *fieldItemList = [[NSMutableArray alloc] init];
                  [regionInfoElement iterate:@"FieldItems.FieldItem"
                                  usingBlock:^(RXMLElement *fieldItemElement) {
                                      
                                      BLFromFieldItemEntity *fieldItemEntity = [[BLFromFieldItemEntity alloc] init];
                                      
                                      fieldItemEntity.name = [fieldItemElement child:@"Name"].text;
                                      fieldItemEntity.nameVisible =
                                      [[fieldItemElement child:@"NameVisible"].text isEqualToString:@"true"] ? YES : NO;
                                      fieldItemEntity.Value = [fieldItemElement child:@"Value"].text;
                                      fieldItemEntity.itemID = [fieldItemElement child:@"Key"].text;
                                      fieldItemEntity.sign =
                                      [[fieldItemElement child:@"Sign"].text isEqualToString:@"true"] ? YES : NO;
                                      fieldItemEntity.percent = [[fieldItemElement child:@"Percent"].text integerValue];
                                      
                                      [fieldItemList addObject:fieldItemEntity];
                                  }];
                  [regionList addObject:fieldItemList];
              }];
    
    return regionList;
}

// 解析可用操作数据
- (NSArray *)parseOperationData:(RXMLElement *)rootElement
{
    NSMutableArray *operationList = [[NSMutableArray alloc] init];
    
    [rootElement iterate:@"Body.GetDocInfoResponse.GetDocInfoResult.listActionInfo.ActionInfo"
              usingBlock:^(RXMLElement *actinoInfoElement) {
                  
                  NSDictionary *actionDic = @{@"ActionID": [actinoInfoElement child:@"ActionID"].text,
                                              @"ActionName": [actinoInfoElement child:@"ActionName"].text};
                  
                  [operationList addObject:actionDic];
              }];
    
    return operationList;
}

// 解析附件数据
- (NSArray *)parseAttachData:(RXMLElement *)rootElement
{
    NSMutableArray *attachList = [[NSMutableArray alloc] init];
    
    [rootElement iterate:@"Body.GetDocInfoResponse.GetDocInfoResult.listAttInfo.AttachmentInfo"
              usingBlock:^(RXMLElement *attachmentInfoElement) {
                  
                  BLAttachEntity *attachEntity = [[BLAttachEntity alloc] init];
                  
                  attachEntity.attachID = [attachmentInfoElement child:@"AttachmentID"].text;
                  attachEntity.attachTitle = [attachmentInfoElement child:@"AttachmentTitle"].text;
                  attachEntity.attachType = [attachmentInfoElement child:@"AttachmentType"].text;
                  attachEntity.attachSize = [[attachmentInfoElement child:@"AttachmentSize"].text integerValue];
                  attachEntity.encrypt = [[attachmentInfoElement child:@"Encrypt"].text isEqualToString:@"true"] ? YES : NO;
                  
                  [attachList addObject:attachEntity];
              }];
    
    return attachList;
}

// 解析办理流程数据
- (NSArray *)parseMatterFlowData:(RXMLElement *)rootElement
{
    NSMutableArray *flowList = [[NSMutableArray alloc] init];
    
    [rootElement iterate:@"Body.GetDocFlowResponse.GetDocFlowResult.stepdes.StepDes"
              usingBlock:^(RXMLElement *flowElement) {
                  
                  BLMatterFlowEntity *flow = [[BLMatterFlowEntity alloc] init];
                  
                  flow.stepName = [flowElement child:@"StepName"].text;
                  flow.stepOrder = [flowElement child:@"StepOrder"].text;
                  flow.action = [flowElement child:@"Action"].text;
                  flow.actinoTime = [flowElement child:@"Actiontime"].text;
                  
                  [flowList addObject:flow];
    }];
    
    return flowList;
}

@end
