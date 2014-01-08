//
//  BLMasterViewController.m
//  BaoLiOA
//
//  侧边栏
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMasterViewController.h"
#import "BLSplitViewControllerManager.h"

#define BacklogCellTag     30
#define TakenCellTag       31
#define ToReadCellTag      32
#define ReadCellTag        33
#define InDocCellTag       34
#define GiveRemarkCellTag  35
#define SettingCellTag     36

@interface BLMasterViewController ()
@property (strong, nonatomic) BLSplitViewControllerManager *splitViewControllerManager;
@end

@implementation BLMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_m_44"]];
    
    self.splitViewControllerManager = [[BLSplitViewControllerManager alloc] initWithSplitViewController:self.splitViewController];
    self.splitViewController.delegate = (id)self.splitViewControllerManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

// 根据选择的 cell 切换 Detail 视图
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
        case BacklogCellTag:
            [self.splitViewControllerManager switchDetaiViewToBackogMatterList];
            break;
            
        case TakenCellTag:
            [self.splitViewControllerManager switchDetaiViewToTakenMatterList];
            break;
            
        case ToReadCellTag:
            [self.splitViewControllerManager switchDetaiViewToToReadMatterList];
            break;
            
        case ReadCellTag:
            [self.splitViewControllerManager switchDetaiViewToReadMatterList];
            break;
            
        case InDocCellTag:
            [self.splitViewControllerManager switchDetaiViewInDocMatterList];
            break;
            
        case GiveRemarkCellTag:
            [self.splitViewControllerManager switchDetaiViewGiveRemarkMatterList];
            break;
            
        case SettingCellTag:
            [self.splitViewControllerManager switchDetaiViewSettingList];
            break;
            
        default:
            break;
    }
}

@end
