//
//  BLOpinionViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLCommonOpinionViewController.h"

@interface BLCommonOpinionViewController ()

@property (strong, nonatomic) NSArray *opinionList;

@end

@implementation BLCommonOpinionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.opinionList = [userDefault objectForKey:[NSString stringWithFormat:@"%@%@", @"kCommonOpinionList", [[NSUserDefaults standardUserDefaults] stringForKey:@"kLoginID"]]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.opinionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLOpinionViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.opinionList[indexPath.row];
    
    return cell;
}

#pragma - mark UITablewViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate opinionDidSelecte:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

@end
