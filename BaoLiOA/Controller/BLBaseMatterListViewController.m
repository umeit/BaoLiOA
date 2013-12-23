//
//  BLBaseListViewController.m
//  BaoLiOA
//
//  通用的列表视图，如：待办事项、已办事项
//
//
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLBaseMatterListViewController.h"
#import "BLMatterInfoService.h"
#import "UIViewController+GViewController.h"
#import "BLBaseMatterCell.h"
#import "BLMatterEntity.h"

@interface BLBaseMatterListViewController ()

@property (strong, nonatomic) NSArray *matterList;

@property (strong, nonatomic) BLMatterInfoService *matterService;

@end

@implementation BLBaseMatterListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.matterService = [[BLMatterInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BLMatterInfoServiceListType listType;
    
    // 设置标题
    switch (self.currentMatterType) {
            
        // 待办列表
        case kTodoMatterList:
        {
            self.title = @"待办事宜";
            listType = BLMatterInfoServiceTodoList;
        }
        break;
            
        // 已办列表
        case kTakenMatterList:
        {
            self.title = @"已办事宜";
            listType = BLMatterInfoServiceTakenList;
        }
        break;
            
        // 待阅列表
        case kToReadMatterList:
        {
            self.title = @"已阅事宜";
            listType = BLMatterInfoServiceToReadList;
        }
        break;
            
        // 待阅列表
        case kReadMatterList:
        {
            self.title = @"已阅事宜";
            listType = BLMatterInfoServiceReadList;
        }
        break;
            
        default:
            break;
    }
    
    // 取得数据后刷新表格
    [self.matterService matterListWithType:listType block:^(NSArray *list, NSError *error) {
        if (error) {
            [self showNetworkingErrorAlert];
        }
        else {
            self.matterList = list;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLBaseMatterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    
    if ([vc respondsToSelector:@selector(setMatterID:)]) {
        NSString *matterID = ((BLMatterEntity *)self.matterList[[self.tableView indexPathForSelectedRow].row]).matterID;
        [vc performSelector:@selector(setMatterID:) withObject:matterID];
    }
}


#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLBaseMatterCell *matterCell = (BLBaseMatterCell *)cell;
    
    BLMatterEntity *matterEntity = self.matterList[0];
    
    matterCell.matterTitleLabel.text = matterEntity.title;
    matterCell.receivedDateLabel.text = matterEntity.sendTime;
    matterCell.matterTypeLabel.text = matterEntity.matterType;
}

@end
