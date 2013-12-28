//
//  BLLoginViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLUserService.h"

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
}

#pragma mark - Action

- (IBAction)loginButtonPress:(id)sender
{
    NSString *loginID = self.loginIDTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (!loginID || [loginID length] < 1) {
        // 提示
        return;
    }
    
    if (!password || [password length] < 1) {
        // 提示
        return;
    }
    
    [self.userService loginWithLoginID:loginID password:password block:^(NSInteger retCode) {
        switch (retCode) {
            case 0:
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"HZ8181e5415cd79f01415d11bde70773" forKey:@"CurrentUserID"];
                [userDefaults setObject:@"朱铭新" forKey:@"CurrentUserName"];
                
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
