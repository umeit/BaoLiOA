//
//  BLMatterFormViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterFormViewController.h"
#import "BLMatterOprationService.h"
#import "BLMatterMainBodyCell.h"

@interface BLMatterFormViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *matterFormList;

@property (strong, nonatomic) BLMatterOprationService *matterOprationService;

@end

@implementation BLMatterFormViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.matterOprationService = [[BLMatterOprationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 获取表单数据
    [self.matterOprationService matterFormListWithBlock:^(NSArray *list, NSError *error) {
        self.matterFormList = list;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matterFormList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLMatterMainBodyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = (UIViewController *)segue.destinationViewController;
    CGRect frame = vc.view.frame;
    
    frame.origin.x = 100;
    frame.size.height = 100;
    vc.view.frame = frame;
    vc.view.bounds = frame;
}

#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLMatterMainBodyCell *matterMainBodyCell = (BLMatterMainBodyCell *)cell;
    
    matterMainBodyCell.mainBodyTitleLabel.text = @"测试";
}
@end
