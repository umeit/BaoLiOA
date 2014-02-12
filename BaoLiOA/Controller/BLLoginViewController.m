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

#define VPN_HOST @""
#define VPN_PORT 0

#define VPN_STATUS_INIT_SUCCESS 1

@interface BLLoginViewController () <SangforSDKDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) BLUserService *userService;
@property (strong, nonatomic) AuthHelper *authHelper;

@property (nonatomic) BOOL isUseVPN;
@property (nonatomic) NSInteger vpnInitStatus;

//@property (strong, nonatomic) NSString *loginID;
//@property (strong, nonatomic) NSString *password;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isUseVPN = [userDefaults boolForKey:@"UseVPN"];
    
    if (self.isUseVPN) {
        NSString *vpnIP = [userDefaults stringForKey:@"VPNAddress"];
        NSInteger vpnPort = [userDefaults integerForKey:@"VPNPort"];
        
        NSLog(@"Init VPN Info, IP:%@ Port:%d", vpnIP, vpnPort);
        self.authHelper = [[AuthHelper alloc] initWithHostAndPort:vpnIP port:vpnPort delegate:self];
    }
    
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
        else {
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
    
    if (self.isUseVPN) {
        
//        self.loginID = loginID;
//        self.password = password;
        
        if (self.vpnInitStatus != VPN_STATUS_INIT_SUCCESS) {
            [self showCustomText:@"正在初始化VPN，请稍后再试。" delay:2];
            return;
        }
        
        // 登录VPN
        [self.authHelper setUserNamePassword:loginID password:password];
        [self.authHelper loginVpn:SSL_AUTH_TYPE_PASSWORD];
    }
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
            [self showCustomTextAlert:@"VPN初始化失败，请稍后再试或联系管理员"];
            break;
            
        case RESULT_VPN_AUTH_FAIL:
            [self showCustomTextAlert:@"VPN验证失败，请稍后再试或联系管理员"];
//            [self.authHelper clearAuthParam:@SET_RND_CODE_STR];
            break;
            
        case RESULT_VPN_INIT_SUCCESS:
            self.vpnInitStatus = VPN_STATUS_INIT_SUCCESS;
            NSLog(@"VPN 初始化成功");
            break;
            
        case RESULT_VPN_AUTH_SUCCESS:
//            [self loginWithID:self.loginID password:self.password];
            NSLog(@"VPN 认证成功");
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
