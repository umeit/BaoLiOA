//
//  BLFromItemEntity.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-4.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLFromFieldItemEntity : NSObject

@property (strong, nonatomic) NSString *itemID;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *beforeName;

@property (strong, nonatomic) NSString *endName;

@property (nonatomic) BOOL nameVisible;

@property (strong, nonatomic) NSString *nameColor;

@property (strong, nonatomic) NSString *splitString;

@property (nonatomic) BOOL nameRN;

@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) NSString *beforeValue;

@property (strong, nonatomic) NSString *endValue;

@property (strong, nonatomic) NSString *valueColor;

@property (nonatomic) NSInteger desplayOrder;

@property (strong, nonatomic) NSString *align;

@property (strong, nonatomic) NSString *fieldType;

@property (strong, nonatomic) NSString *fieldNameForDB;

@property (strong, nonatomic) NSString *mode;

@property (nonatomic) BOOL sign;

@property (strong, nonatomic) NSString *inputType;

@property (nonatomic) NSInteger percent;

@end
