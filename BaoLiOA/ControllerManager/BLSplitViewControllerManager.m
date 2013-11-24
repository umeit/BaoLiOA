//
//  BLSplitViewControllerManager.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLSplitViewControllerManager.h"
#import "BLBaseMatterListViewController.h"

@interface BLSplitViewControllerManager ()

@property (strong, nonatomic) UISplitViewController *splitViewController;

- (void)switchDetaiViewToBaseMatterListWithMaterType:(MatterTypeOfBaseMatterList)matterType;

@end

@implementation BLSplitViewControllerManager

- (BLSplitViewControllerManager *)initWithSplitViewController:(UISplitViewController *)splitViewController
{
    self = [super init];
    if (self) {
        self.splitViewController = splitViewController;
        self.splitViewController.delegate = self;
    }
    
    return self;
}

- (void)switchDetaiViewToBackogMatterList
{
    [self switchDetaiViewToBaseMatterListWithMaterType:BacklogMatterList];
}

- (void)switchDetaiViewToTakenMatterList
{
    [self switchDetaiViewToBaseMatterListWithMaterType:TakenMatterList];
}

#pragma mark - Private

- (void)switchDetaiViewToBaseMatterListWithMaterType:(MatterTypeOfBaseMatterList)matterType
{
    UINavigationController *navigationControllerForDetailView = [self.splitViewController.storyboard instantiateViewControllerWithIdentifier:@"BLBaseMatterListViewController"];
    BLBaseMatterListViewController *baseMatterListViewController = (BLBaseMatterListViewController *)navigationControllerForDetailView.topViewController;
    
    baseMatterListViewController.matterType = matterType;
    
    self.splitViewController.viewControllers = @[self.splitViewController.viewControllers[0], navigationControllerForDetailView];
}

@end
