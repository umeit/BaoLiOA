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
#import "RXMLElement.h"

@implementation BLMatterService

- (void)todoListWithBlock:(BLMatterServiceGeneralBlock)block
{
    [BLMatterHTTPLogic matterListWithMatterType:TodoMatterType withBlock:^(id responseData, NSError *error) {
        if (error) {
            block(nil, error);
        }
        else {
            NSLog(@"Response [Todo List] Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

            NSMutableArray *todoList = [[NSMutableArray alloc] init];
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            [rootElement iterate:@"GetDocTodolistResult.Doc" usingBlock:^(RXMLElement *e) {
                BLMatterEntity *matterEntity = [[BLMatterEntity alloc] init];
                
                matterEntity.matterID = @"a1110";
                matterEntity.title = @"Test_Title";
                matterEntity.matterType = @"请示报告";
                matterEntity.matterSubType = @"控股公司发文";
                matterEntity.from = @"zhang san";
                matterEntity.sendTime = @"1999-09-09";
                matterEntity.flag = 1;
                
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
            NSLog(@"Response [Todo List] Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            
            // 存储 FieldItems 和 Percents
            NSMutableDictionary *regionInfo = [[NSMutableDictionary alloc] init];
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            // 开始解析数据
            [rootElement iterate:@"RegionItems.InfoRegion" usingBlock:^(RXMLElement *regionInfoElement) {
                
                // 解析一个 Region 中的所有 Field 数据
                NSMutableArray *fieldItemList = [[NSMutableArray alloc] init];
                [regionInfoElement iterate:@"FieldItems" usingBlock:^(RXMLElement *fieldItemElement) {
                    BLMatterEntity *fieldItemEntity = [[BLMatterEntity alloc] init];
                    
                    [fieldItemList addObject:fieldItemEntity];
                }];
                
                // 解析一个 Region 中的所有 Percents 数据
                NSMutableArray *percentsList = [[NSMutableArray alloc] init];
                [regionInfoElement iterate:@"FieldItems" usingBlock:^(RXMLElement *fieldItemElement) {
                    NSNumber *percents = @(0);
                    [percentsList addObject:percents];
                }];
                
                [regionInfo setObject:@"FieldItems" forKey:fieldItemList];
                [regionInfo setObject:@"Percents" forKey:fieldItemList];
            }];
            
            block(regionInfo, nil);
        }
    }];
}
@end
