//
//  BLMasterViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMasterViewController.h"
//#import "BLBaseMatterNavigationController.h"
#import "BLSplitViewControllerManager.h"

#define BacklogCellTag 30
#define TakenCellTag   31

@interface BLMasterViewController ()

@end

@implementation BLMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 根据选择的 cell 切换 Detail 视图
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLSplitViewControllerManager *splitViewControllerManager = (BLSplitViewControllerManager *)self.splitViewController.delegate;
    
    switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
        case BacklogCellTag:
            [splitViewControllerManager switchDetaiViewToBackogMatterList];

            break;
            
        case TakenCellTag:
            [splitViewControllerManager switchDetaiViewToTakenMatterList];
            break;
            
        default:
            break;
    }
}

@end
