//
//  BLInfoRegionEntity.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-31.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLInfoRegionEntity : NSObject

@property (strong, nonatomic) NSString *regionID;

@property (nonatomic) NSInteger displayOrder;

@property (nonatomic) BOOL vlineVisible;

@property (strong, nonatomic) NSArray *feildItemList;

@end
