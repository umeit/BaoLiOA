//
//  BLVPNManager.h
//  BaoLiOA
//
//  Created by gulbel on 14-2-13.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^InitBLock)(BOOL success);
typedef void(^LoginBLock)(BOOL success);
typedef void(^LogoutBLock)();

@interface BLVPNManager : NSObject

@property (nonatomic) BOOL isInitVPN;
@property (nonatomic) BOOL isLoginVPN;

+ (instancetype)sharedInstance;

- (void)initVPNWithIP:(NSString *)ip port:(NSInteger)port block:(InitBLock)block;

- (void)loginVPNWithUserName:(NSString *)name password:(NSString *)password block:(LoginBLock)block;

- (void)logoutVPN:(LogoutBLock)block;

@end
