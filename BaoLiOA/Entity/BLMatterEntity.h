//
//  BLMatterEntity.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLMatterEntity : NSObject

@property (strong, nonatomic) NSString *matterID;

// 标题
@property (strong, nonatomic) NSString *title;

// 事项收到/发布时间
@property (strong, nonatomic) NSString *sendTime;

// 发送人
@property (strong, nonatomic) NSString *from;

// 公文类型： 收文、发文、请示报告、盖章签字
@property (strong, nonatomic) NSString *matterType;

// 公文子类型：集团（院）发文，控股公司发文,控股公司盖章审批,集团盖章审批 等
@property (strong, nonatomic) NSString *matterSubType;

// 阅办标记
@property (nonatomic) NSInteger flag;

// 流转次数
//@property (nonatomic) NSInteger flowTimes;

@end
