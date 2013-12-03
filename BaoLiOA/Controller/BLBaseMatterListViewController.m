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
#import "BLMatterService.h"
#import "UIViewController+BLViewController.h"
#import "BLBaseMatterCell.h"
#import "BLMatterEntity.h"

@interface BLBaseMatterListViewController ()

@property (strong, nonatomic) NSArray *matterList;

@property (strong, nonatomic) BLMatterService *matterService;

@end

@implementation BLBaseMatterListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.matterService = [[BLMatterService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置标题
    switch (self.currentMatterType) {
            
        case TodoMatterList:
            self.title = @"待办事宜";
            break;
            
        case TakenMatterList:
            self.title = @"已办事宜";
            break;
            
        default:
            break;
    }
    
    // 获取数据
    if (self.currentMatterType == TodoMatterList) {
        
        // 取得数据后刷新表格
        [self.matterService todoListWithBlock:^(NSArray *list, NSError *error) {
            if (error) {
                [self showNetworkingErrorAlert];
            }
            else {
                self.matterList = list;
                [self.tableView reloadData];
            }
        }];
    }
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
    NSLog(@"asdf");
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
