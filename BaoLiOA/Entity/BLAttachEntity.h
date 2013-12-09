//
//  BLAttachEntity.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-6.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLAttachEntity : NSObject

@property (strong, nonatomic) NSString *attachID;

@property (strong, nonatomic) NSString *attachTitle;

@property (strong, nonatomic) NSString *attachType;

@property (nonatomic) NSInteger attachSize;

@property (nonatomic) BOOL encrypt;

@property (strong, nonatomic) NSString *localPath;

@end
