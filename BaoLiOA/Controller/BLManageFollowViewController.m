//
//  BLManageFollowViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLManageFollowViewController.h"

@interface BLManageFollowViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *selectedFollow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BLManageFollowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.followList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLManageFollowViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.followList[indexPath.row];
    
    if ([self isFollowMarked:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma - mark - UITablewViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.multipleSelect) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self removeMarkedItem:@(indexPath.row)];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self addMarkedItem:@(indexPath.row)];
            
        }
    }
    else {
        if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
            
            [self removeAllMarkedItems];
            
            [self addMarkedItem:@(indexPath.row)];
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Action

- (IBAction)okButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate followDidSelected:self.selectedFollow];
    }];
}

- (IBAction)cancelButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)addMarkedItem:(id)item
{
    if (!self.selectedFollow) {
        self.selectedFollow = [[NSMutableArray alloc] init];
    }
    [self.selectedFollow addObject:item];
}

- (void)removeMarkedItem:(id)item
{
    [self.selectedFollow removeObject:item];
}

- (void)removeAllMarkedItems
{
    [self.selectedFollow removeAllObjects];
}

- (BOOL)isFollowMarked:(id)item
{
    return (self.selectedFollow) && ([self.selectedFollow indexOfObject:item] != NSNotFound)
    ? YES : NO;
}


@end
