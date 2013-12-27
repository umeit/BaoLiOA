//
//  BLSplitViewControllerManager.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum MatterTypeOfBaseMatterList : NSInteger {
//    BacklogMatterList = 1,
//    TakenMatterList   = 2
//} MatterTypeOfBaseMatterList;

@interface BLSplitViewControllerManager : NSObject <UISplitViewControllerDelegate>

- (BLSplitViewControllerManager *)initWithSplitViewController:(UISplitViewController *)splitViewController;

- (void)switchDetaiViewToBackogMatterList;

- (void)switchDetaiViewToTakenMatterList;

- (void)switchDetaiViewToToReadMatterList;

- (void)switchDetaiViewToReadMatterList;

- (void)switchDetaiViewInDocMatterList;

- (void)switchDetaiViewGiveRemarkMatterList;

- (void)switchDetaiViewSettingList;
@end
