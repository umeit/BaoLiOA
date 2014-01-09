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

@interface BLLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) BLUserService *userService;
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
    self.loginIDTextField.text = [userDefaults stringForKey:@"CurrentUserLoginID"];
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

#warning 密码验证
//    if (!password || [password length] < 1) {
//        [self showCustomTextAlert:@"请输入密码"];
//        return;
//    }
    
    [self showLodingView];
    
    [self.userService loginWithLoginID:loginID password:password block:^(NSInteger retCode) {
        
        [self hideLodingView];
        
        switch (retCode) {
            case 0:
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                BLContextEntity *context;
                
                if ([loginID isEqualToString:@"admin"]) {
                    context = [[BLContextEntity alloc] initWithUserID:@"admin"
                                                             userName:@"管理员"
                                                             oaUserID:@"admin"
                                                           oaUserName:@"管理员"
                                                            oaAccount:@"管理员"
                                                           actionDesc:@""];
                    
                    
                }
                else if ([loginID isEqualToString:@"konglj"]) {
                    context = [[BLContextEntity alloc] initWithUserID:@"konglj"
                                                             userName:@"登录名"
                                                             oaUserID:@"HZ8080813e5f8e3e013e5f90486d003a"
                                                           oaUserName:@"真实姓名"
                                                            oaAccount:@"OA用户名"
                                                           actionDesc:@""];
                }
                else if ([loginID isEqualToString:@"zhumx"]) {
                    context = [[BLContextEntity alloc] initWithUserID:@"zhumx"
                                                             userName:@"登录名"
                                                             oaUserID:@"HZ8181e5415cd79f01415d11bde70773"
                                                           oaUserName:@"真实姓名"
                                                            oaAccount:@"OA用户名"
                                                           actionDesc:@""];
                }
                
                
                [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:context] forKey:@"Context"];
                
                self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BLSplitViewController"];
                
                break;
            }
                
            default:
                break;
        }
    }];
}

- (IBAction)settingsButtonPress:(id)sender
{
    
}
@end
