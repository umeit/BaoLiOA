//
//  BLLoginViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLUserService.h"
#import "BLContextEntity.h"
#import "UIViewController+GViewController.h"
#import "AuthHelper.h"

//#define VPN_HOST @""
//#define VPN_PORT 0

#define VPN_STATUS_INIT_SUCCESS  1
#define VPN_STATUS_LOGIN_SUCCESS 1

#define VPN_USER_NAME @"mobileOA"
#define VPN_PASSWORD  @"mobileOA1111"

@interface BLLoginViewController () <SangforSDKDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) BLUserService *userService;
@property (strong, nonatomic) AuthHelper *authHelper;

@property (nonatomic) BOOL isUseVPN;
@property (nonatomic) NSInteger vpnInitStatus;
@property (nonatomic) NSInteger vpnLoginStatus;

@property (strong, nonatomic) NSString *loginID;
@property (strong, nonatomic) NSString *password;
@end

@implementation BLLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.userService = [[BLUserService alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *contextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Context"];
    if (contextData) {
        BLContextEntity *context = [NSKeyedUnarchiver unarchiveObjectWithData:contextData];
        self.loginIDTextField.text = context.userName;
    }
}

// 登录 OA 系统
- (void)loginWithID:(NSString *)loginID password:(NSString *)password
{
    [self showLodingView];
    
    [self.userService loginWithLoginID:loginID password:password block:^(BOOL success, NSString *msg) {
        [self hideLodingView];
        
        if (success) {
            self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BLSplitViewController"];
        }
        // 登录失败
        else {
//            [self.authHelper logoutVpn];
            [self showCustomTextAlert:msg];
        }
    }];
}


#pragma mark - Action

- (IBAction)loginButtonPress:(id)sender
{
    NSString *loginID = self.loginIDTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (!loginID || [loginID length] < 1) {
        [self showCustomTextAlert:@"请输入用户名"];
        return;
    }
    
    if (!password || [password length] < 1) {
        [self showCustomTextAlert:@"请输入密码"];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isUseVPN = [userDefaults boolForKey:@"UseVPN"];
    
    // 使用 VPN 登录
    if (self.isUseVPN) {
        [self showLodingView];
        
        self.loginID = loginID;
        self.password = password;
        
        // 初始化 VPN
        if (self.vpnInitStatus != VPN_STATUS_INIT_SUCCESS) {
            NSString *vpnIP = [userDefaults stringForKey:@"VPNAddress"];
            NSInteger vpnPort = [userDefaults integerForKey:@"VPNPort"];
            NSLog(@"Init VPN Info, IP:%@ Port:%d", vpnIP, vpnPort);
            self.authHelper = [[AuthHelper alloc] initWithHostAndPort:vpnIP port:vpnPort delegate:self];
        }
        // 已初始化 VPN，登录 VPN
        else if (self.vpnLoginStatus != VPN_STATUS_LOGIN_SUCCESS) {
//            [self.authHelper logoutVpn]; // 先注销
            [self.authHelper setUserNamePassword:VPN_USER_NAME password:VPN_PASSWORD];
            [self.authHelper loginVpn:SSL_AUTH_TYPE_PASSWORD];
        }
        // 已登录 VPN，登录 OA 系统
        else {
            [self loginWithID:loginID password:password];
        }
        
//        if (self.vpnInitStatus != VPN_STATUS_INIT_SUCCESS) {
//            [self showCustomText:@"正在初始化VPN，请稍后再试。" delay:2];
//            return;
//        }
        
        // 登录VPN
//        [self.authHelper setUserNamePassword:loginID password:password];
//        [self.authHelper setUserNamePassword:@"oatest" password:@"1111"];
//        [self.authHelper loginVpn:SSL_AUTH_TYPE_PASSWORD];
    }
    // 不使用 VPN 登录
    else {
        [self loginWithID:loginID password:password];
    }
}

- (IBAction)settingsButtonPress:(id)sender
{
    
}


#pragma mark - SangforSDKDelegate
// 监控 VPN 状态
- (void)onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType
{
    switch (vpnErrno)
    {
        case RESULT_VPN_INIT_FAIL:
            [self hideLodingView];
            [self showCustomTextAlert:@"VPN初始化失败，请稍后再试或联系管理员。"];
            break;
            
        case RESULT_VPN_AUTH_FAIL:
            [self showCustomTextAlert:@"VPN验证失败，请稍后再试或联系管理员"];
//            [self.authHelper clearAuthParam:@SET_RND_CODE_STR];
            break;
            
        case RESULT_VPN_INIT_SUCCESS:
            NSLog(@"VPN 初始化成功");
            
            self.vpnInitStatus = VPN_STATUS_INIT_SUCCESS;
            // 初始化 VPN 成功，登录 VPN
//            [self.authHelper logoutVpn]; // 先注销
            if (self.vpnLoginStatus != VPN_STATUS_LOGIN_SUCCESS) {
                [self.authHelper setUserNamePassword:VPN_USER_NAME password:VPN_PASSWORD];
                [self.authHelper loginVpn:SSL_AUTH_TYPE_PASSWORD];
            }
            break;
            
        case RESULT_VPN_AUTH_SUCCESS:
            NSLog(@"VPN 认证成功");
            [self hideLodingView];
            self.vpnLoginStatus = VPN_STATUS_LOGIN_SUCCESS;
            // 登录 VPN 成功，然后登录 OA 系统
            [self loginWithID:self.loginID password:self.password];
            break;
            
        case RESULT_VPN_AUTH_LOGOUT:
            NSLog(@"VPN 已注销");
            break;
            
        case RESULT_VPN_NONE:
            NSLog(@"VPN 返回无效值\"0\"");
            break;
            
        default:
            break;
    }
}

@end
