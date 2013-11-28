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
    
    return cell;
}

#pragma - mark UITablewViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *name = cell.textLabel.text;
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self removeMarkedname:name];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self addMarkedname:name];
        
    }
}

#pragma mark - Action

- (IBAction)okButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate FollowDidSelected:self.selectedFollow];
    }];
    
    
}

- (IBAction)cancelButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)addMarkedname:(NSString *)name
{
    if (!self.selectedFollow) {
        self.selectedFollow = [[NSMutableArray alloc] init];
    }
    [self.selectedFollow addObject:name];
}

- (void)removeMarkedname:(NSString *)name
{
    [self.selectedFollow removeObject:name];
}

- (BOOL)isFollowMarkedWithName:(NSString *)name
{
    return (self.selectedFollow) && ([self.selectedFollow indexOfObject:name] != NSNotFound)
    ? YES : NO;
}


@end
