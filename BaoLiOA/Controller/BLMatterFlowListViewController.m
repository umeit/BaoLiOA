//
//  BLMatterFlowListViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterFlowListViewController.h"
#import "BLMatterInfoService.h"
#import "BLMatterFlowCell.h"
#import "BLMatterFlowEntity.h"
#import "UIViewController+GViewController.h"

@interface BLMatterFlowListViewController ()

@property (strong, nonatomic) BLMatterInfoService *matterInfoService;

@property (strong, nonatomic) NSArray *flowList;

@end

@implementation BLMatterFlowListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _matterInfoService = [[BLMatterInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self showLodingView];
    
    [self.matterInfoService matterFlowWithMatterID:self.matterID block:^(id obj, NSError *error) {
        
        [self hideLodingView];
        
        if (error) {
            [self showNetworkingErrorAlert];
        }
        else {
            self.flowList = obj;
            
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
    return [self.flowList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLMatterFlowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:(BLMatterFlowCell *)cell atIndex:indexPath];
    
    return cell;
}


#pragma mark - Private

- (void)configureCell:(BLMatterFlowCell *)cell atIndex:(NSIndexPath *)indexPath
{
    BLMatterFlowEntity *flowEntity = self.flowList[indexPath.row];
    
    cell.stepNameLabel.text = flowEntity.stepName;
    cell.actionLabel.text = flowEntity.action;
    cell.actionTimeLabel.text = [flowEntity.actinoTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}

@end
