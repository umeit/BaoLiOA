//
//  BLAppDelegate.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-20.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLAppDelegate.h"
#import "BLSplitViewControllerManager.h"

@implementation BLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 设置默认「常用意见」
    NSMutableArray *commonOpinionList = [[userDefaults arrayForKey:@"kCommonOpinionList"] mutableCopy];
    if (!commonOpinionList) {
        commonOpinionList = [NSMutableArray arrayWithObject:@"同意"];
        [userDefaults setObject:commonOpinionList forKey:@"kCommonOpinionList"];
    }
    
    // 设置默认服务器 IP 与 端口号
    NSString *serverIP = [userDefaults stringForKey:@"ServerAddress"];
    NSString *serverPort = [userDefaults stringForKey:@"ServerPort"];
    if (!serverIP) {
        serverIP = @"210.51.191.244";
        
        [userDefaults setObject:serverIP forKey:@"ServerAddress"];
    }
    if (!serverPort) {
        serverPort = @"8081";
        
        [userDefaults setObject:serverPort forKey:@"ServerPort"];
    }
    
    // 显示登录页
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BLLoginViewController"];
    
    return YES;
}

@end
