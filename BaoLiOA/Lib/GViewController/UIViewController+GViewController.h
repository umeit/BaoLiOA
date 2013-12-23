//
//  UIViewController+GViewController.h
//  GViewController
//
//  Created by Liu Feng on 13-12-10.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (GViewController)

@property (strong, nonatomic) MBProgressHUD *HUD;

@property (strong, nonatomic) NSMutableArray *blockList;

@property (nonatomic) NSInteger alertBlockIndex;

- (void)showCustomTextAlert:(NSString *)text
        withOKButtonPressed:(void(^)())block;

- (void)showCustomTextAlert:(NSString *)text
                  withBlock:(void (^)())block;

- (void)showCustomTextAlert:(NSString *)text;

- (void)showCustomText:(NSString *)text
                 delay:(NSInteger)delay;

- (void)showLodingView;

- (void)showLodingViewWithText:(NSString *)text;

- (void)hideLodingView;

- (void)showNetworkingErrorAlert;

NSUInteger DeviceSystemMajorVersion();

@end
