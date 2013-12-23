//
//  UIViewController+GViewController.m
//  GViewController
//
//  Created by Liu Feng on 13-12-10.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "UIViewController+GViewController.h"
#import <objc/runtime.h>

#define IS_IOS7_AND_LATER (DeviceSystemMajorVersion() >= 7)
#define IS_IOS6_AND_EARLIER (DeviceSystemMajorVersion() <= 6)

static char kHUD;
static char kBLockList;
static char kAlertBlockIndex;

@implementation UIViewController (GViewController)
@dynamic HUD;
@dynamic blockList;
@dynamic alertBlockIndex;


- (void)showCustomTextAlert:(NSString *)text withOKButtonPressed:(void (^)())block
{
    if (!self.blockList) {
        self.blockList = [[NSMutableArray alloc] init];
    }
    
    [self.blockList setObject:block atIndexedSubscript:self.alertBlockIndex];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = self.alertBlockIndex;
    [alert show];
    
    self.alertBlockIndex ++;
}

- (void)showCustomTextAlert:(NSString *)text withBlock:(void (^)())block
{
    if (!self.blockList) {
        self.blockList = [[NSMutableArray alloc] init];
    }
    
    [self.blockList setObject:block atIndexedSubscript:self.alertBlockIndex];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag = self.alertBlockIndex;
    [alert show];
    
    self.alertBlockIndex ++;
}

- (void)showCustomTextAlert:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showCustomText:(NSString *)text delay:(NSInteger)delay
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = text;
    
	[self.view addSubview:HUD];
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:delay];
}

- (void)showLodingView
{
    [self showLodingViewWithText:nil];
}

- (void)showLodingViewWithText:(NSString *)text
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:self.HUD];
    
    self.HUD.labelText = text;
    
    [self.HUD show:YES];
}

- (void)hideLodingView
{
    [self.HUD hide:YES];
}

- (void)showNetworkingErrorAlert
{
    [self showCustomTextAlert:@"网络异常，请检查您的网络设置或稍后再试"];
}

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 只有「确定」
    if (alertView.numberOfButtons < 2) {
        void (^block)(void) = self.blockList[alertView.tag];
        block();
        
        // 点击「确定」
    } else if (buttonIndex == 1) {
        void (^block)(void) = self.blockList[alertView.tag];
        block();
    }
}

#pragma mark - Getter / Setter

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, &kHUD);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, &kHUD, HUD,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)blockList
{
    return objc_getAssociatedObject(self, &kBLockList);
}

- (void)setBlockList:(NSMutableArray *)blockList
{
    objc_setAssociatedObject(self, &kBLockList,
                             blockList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)alertBlockIndex
{
    return [objc_getAssociatedObject(self,
                                     &kAlertBlockIndex) integerValue];
}

- (void)setAlertBlockIndex:(NSInteger)alertBlockIndex
{
    objc_setAssociatedObject(self, &kAlertBlockIndex,
                             @(alertBlockIndex),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
