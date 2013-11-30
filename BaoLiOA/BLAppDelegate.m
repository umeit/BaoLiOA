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
    NSDictionary *appSettingsDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"AppSettings"];
    if (!appSettingsDic) {
        // 以后的应用默认设置都放到这里
        appSettingsDic = @{@"ServerAddress": @"192.168.1.1"};
        
        [[NSUserDefaults standardUserDefaults] setObject:appSettingsDic forKey:@"AppSettings"];
    }
    
    // 显示登录页
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BLLoginViewController"];
    
    return YES;
}

@end
