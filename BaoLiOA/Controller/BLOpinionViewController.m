//
//  BLOpinionViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLOpinionViewController.h"

@interface BLOpinionViewController ()

@property (strong, nonatomic) NSArray *opinionList;

@end

@implementation BLOpinionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *opinionList = [userDefault objectForKey:@"opinionList"];
    
    if (!opinionList) {
        opinionList = [NSMutableArray arrayWithArray:@[@"同意", @"拟同意"]];
        [userDefault setObject:opinionList forKey:@"opinionList"];
    }
    
    self.opinionList = opinionList;
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
