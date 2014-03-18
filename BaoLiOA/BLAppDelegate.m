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
    
//    // 设置默认「常用意见」
//    NSMutableArray *commonOpinionList = [[userDefaults arrayForKey:[NSString stringWithFormat:@"%@%@", @"kCommonOpinionList", [[NSUserDefaults standardUserDefaults] stringForKey:@"kLoginID"]]] mutableCopy];
//    if (!commonOpinionList) {
//        commonOpinionList = [NSMutableArray arrayWithObject:@"同意"];
//        [userDefaults setObject:commonOpinionList forKey:[NSString stringWithFormat:@"%@%@", @"kCommonOpinionList", [[NSUserDefaults standardUserDefaults] stringForKey:@"kLoginID"]]];
//    }
    
    // 设置默认服务器 IP 与 端口号
    NSString *serverIP = [userDefaults stringForKey:@"ServerAddress"];
    NSString *serverPort = [userDefaults stringForKey:@"ServerPort"];
//    BOOL isUseVPN = [userDefaults boolForKey:@"UseVPN"];
    NSString *vpnIP = [userDefaults stringForKey:@"VPNAddress"];
    NSNumber *vpnPort = [userDefaults objectForKey:@"VPNPort"];
    
    if (!serverIP) {
        serverIP = @"172.16.11.182";
        
        [userDefaults setObject:serverIP forKey:@"ServerAddress"];
    }
    if (!serverPort) {
        serverPort = @"8081";
        
        [userDefaults setObject:serverPort forKey:@"ServerPort"];
    }
    if (!vpnIP) {
        vpnIP = @"114.255.160.133";
        
        [userDefaults setObject:vpnIP forKey:@"VPNAddress"];
    }
    if (!vpnPort) {
        vpnPort = @(443);
        
        [userDefaults setObject:vpnPort forKey:@"VPNPort"];
    }
    
    // 显示登录页
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"BLLoginViewController"];
    }
    else {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BLLoginViewController"];
    }
    
    
    return YES;
}

@end
