//
//  BLVPNManager.m
//  BaoLiOA
//
//  Created by gulbel on 14-2-13.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import "BLVPNManager.h"
#import "AuthHelper.h"

@interface BLVPNManager ()<SangforSDKDelegate>
@property (strong, nonatomic) AuthHelper *authHelper;

@property (copy, nonatomic) InitBLock initBlock;
@property (copy, nonatomic) LoginBLock loginBlock;
@property (copy, nonatomic) LogoutBLock logoutBlock;
@end

@implementation BLVPNManager

+ (instancetype)sharedInstance
{
    static BLVPNManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BLVPNManager alloc] init];
    });
    
    return instance;
}

- (void)initVPNWithIP:(NSString *)ip port:(NSInteger)port block:(void (^)(BOOL))block
{
    self.initBlock = block;
    self.authHelper  = [[AuthHelper alloc] initWithHostAndPort:ip port:port delegate:self];
}

- (void)loginVPNWithUserName:(NSString *)name password:(NSString *)password block:(LoginBLock)block
{
    self.loginBlock = block;
    [self.authHelper setUserNamePassword:name password:password];
    [self.authHelper loginVpn:SSL_AUTH_TYPE_PASSWORD];
}

- (void)logoutVPN:(LogoutBLock)block
{
    self.logoutBlock = block;
    [self.authHelper logoutVpn];
}


#pragma mark - SangforSDKDelegate
// 监控 VPN 状态
- (void)onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType
{
    switch (vpnErrno)
    {
        case RESULT_VPN_INIT_FAIL:
            NSLog(@"VPN 初始化失败");
            self.initBlock(NO);
            break;
            
        case RESULT_VPN_AUTH_FAIL:
            NSLog(@"VPN 认证失败");
            self.loginBlock(NO);
            //            [self.authHelper clearAuthParam:@SET_RND_CODE_STR];
            break;
            
        case RESULT_VPN_INIT_SUCCESS:
            NSLog(@"VPN 初始化成功");
            self.isInitVPN = YES;
            self.initBlock(YES);
            break;
            
        case RESULT_VPN_AUTH_SUCCESS:
            NSLog(@"VPN 认证成功");
            self.isLoginVPN = YES;
            self.loginBlock(YES);
            break;
            
        case RESULT_VPN_AUTH_LOGOUT:
            NSLog(@"VPN 已注销");
            self.isLoginVPN = NO;
            self.logoutBlock();
            break;
            
        case RESULT_VPN_NONE:
            NSLog(@"VPN 返回无效值\"0\"");
            break;
            
        default:
            break;
    }
}

@end
