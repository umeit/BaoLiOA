//
//  BLMatterEntity.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLMatterEntity : NSObject

// 标题
@property (strong, nonatomic) NSString *title;

// 事宜收到/发布时间
@property (strong, nonatomic) NSDate *receivedDate;

// 收文、呈批件
@property (strong, nonatomic) NSString *matterType;

// 流转次数
@property (nonatomic) NSInteger flowTimes;

@end
