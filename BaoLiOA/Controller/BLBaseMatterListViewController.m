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

@property (nonatomic) BLMatterInfoServiceListType listType;

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
    
    // 设置标题
    switch (self.currentMatterType) {
            
        // 待办列表
        case kTodoMatterList:
        {
            self.title = @"待办事宜";
            self.listType = BLMatterInfoServiceTodoList;
        }
        break;
            
        // 已办列表
        case kTakenMatterList:
        {
            self.title = @"已办事宜";
            self.listType = BLMatterInfoServiceTakenList;
        }
        break;
            
        // 待阅列表
        case kToReadMatterList:
        {
            self.title = @"已阅事宜";
            self.listType = BLMatterInfoServiceToReadList;
        }
        break;
            
        // 待阅列表
        case kReadMatterList:
        {
            self.title = @"已阅事宜";
            self.listType = BLMatterInfoServiceReadList;
        }
        break;
            
        // 待阅列表
        case kInDocMatterList:
        {
            self.title = @"收文";
            self.listType = BLMatterInfoServiceReadList;
        }
        break;
            
        // 待阅列表
        case kGiveRemarkMatterList:
        {
            self.title = @"呈批件";
            self.listType = BLMatterInfoServiceReadList;
        }
        break;
            
        default:
            break;
    }
    
    [self updateData];
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
    
    if ([vc respondsToSelector:@selector(setDelegate:)]) {
        [vc performSelector:@selector(setDelegate:) withObject:self];
    }
}


#pragma mark - Delegate

- (void)matterOperationDidFinish
{
    [self updateData];
}


#pragma mark - Private

- (void)updateData
{
    [self showLodingView];
    
    // 取得数据后刷新表格
    [self.matterService matterListWithType:self.listType block:^(NSArray *list, NSError *error) {
        
        [self hideLodingView];
        
        if (error) {
            [self showNetworkingErrorAlert];
        }
        else {
            self.matterList = list;
            [self.tableView reloadData];
        }
    }];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLBaseMatterCell *matterCell = (BLBaseMatterCell *)cell;
    
    BLMatterEntity *matterEntity = self.matterList[0];
    
    matterCell.matterTitleLabel.text = matterEntity.title;
    matterCell.receivedDateLabel.text = matterEntity.sendTime;
    matterCell.matterTypeLabel.text = matterEntity.matterType;
}

@end
