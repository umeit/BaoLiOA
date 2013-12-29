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
#import "UIViewController+GViewController.h"
#import "BLBaseMatterCell.h"
#import "BLMatterEntity.h"

@interface BLBaseMatterListViewController ()

@property (strong, nonatomic) NSArray *matterList;

@property (strong, nonatomic) BLMatterInfoService *matterService;

@property (nonatomic) BLMIHLReadMatterStatus readMatterStatus;

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
            self.matterType = kFull;
            self.matterStatus = kTodo;
        }
        break;
            
        // 已办列表
        case kTakenMatterList:
        {
            self.title = @"已办事宜";
            self.matterType = kFull;
            self.matterStatus = kTaken;
        }
        break;
            
        // 待阅列表
        case kToReadMatterList:
        {
            self.title = @"已阅事宜";
            self.readMatterStatus = kRead;
        }
        break;
            
        // 已阅列表
        case kReadMatterList:
        {
            self.title = @"已阅事宜";
            self.readMatterStatus = kToRead;
        }
        break;
            
        // 收文列表
        case kInDocMatterList:
        {
            self.title = @"收文";
            self.matterType = kInDoc;
            self.matterStatus = kTodo;
        }
        break;
            
        // 呈批件列表
        case kGiveRemarkMatterList:
        {
            self.title = @"呈批件";
            self.matterType = kGiveRemark;
            self.matterStatus = kTodo;
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


#pragma mark - Public

- (void)updateData
{
    [self showLodingView];
    
    if (self.currentMatterType == kTodoMatterList || self.currentMatterType == kTakenMatterList
        || self.currentMatterType == kInDocMatterList || self.currentMatterType == kGiveRemarkMatterList) {
        
        // 待办、已办、收文、呈批件，用这个接口
        [self.matterService matterListWithType:self.matterType status:self.matterStatus block:^(NSArray *list, NSError *error) {
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
    
    else if (self.currentMatterType == kReadMatterList || self.currentMatterType == kToReadMatterList) {
        
        // 待阅、已阅，用这个接口
        [self.matterService readMatterListWithStatus:self.readMatterStatus block:^(NSArray *list, NSError *error) {
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
}


#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLBaseMatterCell *matterCell = (BLBaseMatterCell *)cell;
    
    BLMatterEntity *matterEntity = self.matterList[indexPath.row];
    
    matterCell.matterTitleLabel.text = matterEntity.title;
    matterCell.receivedDateLabel.text = matterEntity.sendTime;
    matterCell.matterTypeLabel.text = matterEntity.matterType;
}

@end
