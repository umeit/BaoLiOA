//
//  BLMatterService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterService.h"
#import "BLMatterHTTPLogic.h"
#import "BLMatterEntity.h"
#import "BLFromFieldItemEntity.h"
#import "RXMLElement.h"

@implementation BLMatterService

- (void)todoListWithBlock:(BLMatterServiceGeneralBlock)block
{
    [BLMatterHTTPLogic matterListWithMatterType:TodoMatterType withBlock:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
//            NSLog(@"Response [Todo Data] Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

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

- (void)takenMatterWithBlock:(BLMatterServiceGeneralBlock)block
{
    [BLMatterHTTPLogic matterListWithMatterType:TakenMatter withBlock:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            block(responseData, nil);
        }
    }];
}

- (void)matterFormListWithMatterID:(NSString *)matterID block:(BLMatterServiceGeneralBlock)block;
{
    [BLMatterHTTPLogic matterFormListWithMatterID:matterID block:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSLog(@"Response [Region Data] Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            
//            // 存储 FieldItems 和 Percents
//            NSMutableDictionary *regionInfo = [[NSMutableDictionary alloc] init];
            
            // 存储 field item 列表的列表
            NSMutableArray *regionList = [[NSMutableArray alloc] init];
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            // 开始解析数据
            [rootElement iterate:@"Body.GetDocInfoResponse.GetDocInfoResult.RegionItems.InfoRegion" usingBlock:^(RXMLElement *regionInfoElement) {
                
                // 解析一个 Region 中的所有 Field 数据
                NSMutableArray *fieldItemList = [[NSMutableArray alloc] init];
                [regionInfoElement iterate:@"FieldItems.FieldItem" usingBlock:^(RXMLElement *fieldItemElement) {
                    BLFromFieldItemEntity *fieldItemEntity = [[BLFromFieldItemEntity alloc] init];
                    
                    fieldItemEntity.name = [fieldItemElement child:@"Name"].text;
                    fieldItemEntity.nameVisible = [[fieldItemElement child:@"NameVisible"].text isEqualToString:@"true"] ? YES : NO;
                    fieldItemEntity.Value = [fieldItemElement child:@"Value"].text;
                    fieldItemEntity.itemID = [fieldItemElement child:@"Key"].text;
                    fieldItemEntity.sign = [[fieldItemElement child:@"Sign"].text isEqualToString:@"true"] ? YES : NO;
                    fieldItemEntity.percent = [[fieldItemElement child:@"Percent"].text integerValue];
                    
                    [fieldItemList addObject:fieldItemEntity];
                }];
                
                [regionList addObject:fieldItemList];
                
//                // 解析一个 Region 中的所有 Percents 数据
//                NSMutableArray *percentsList = [[NSMutableArray alloc] init];
//                [regionInfoElement iterate:@"FieldItems" usingBlock:^(RXMLElement *fieldItemElement) {
//                    NSNumber *percents = @(0);
//                    [percentsList addObject:percents];
//                }];
//                
//                [regionInfo setObject:@"FieldItems" forKey:fieldItemList];
//                [regionInfo setObject:@"Percents" forKey:fieldItemList];
            }];
            
//            block(regionInfo, nil);
            block(regionList, Nil);
        }
    }];
}
@end
