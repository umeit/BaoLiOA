//
//  BLUserService.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLUserServiceGeneralRetCode)(NSInteger retCode);

@interface BLUserService : NSObject

- (void)loginWithLoginID:(NSString *)loginID password:(NSString *)password block:(BLUserServiceGeneralRetCode)block;

@end
