//
//  BLBaseListViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLBaseMatterListViewController.h"
#import "BLMatterService.h"
#import "UIViewController+BLViewController.h"
#import "BLBaseMatterCell.h"
#import "BLMatterEntity.h"
//#import "BLBaseMatterNavigationController.h"

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
    switch (self.matterType) {
        case BacklogMatterList:
            self.title = @"待办事宜";
            break;
            
        case TakenMatterList:
            self.title = @"已办事宜";
            break;
            
        default:
            break;
    }
    
    // 取得数据后刷新表格
    [self.matterService backlogListWithBlock:^(NSArray *list, NSError *error) {
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//#pragma mark - Navigation
//
//// In a story board-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"asdf");
//}


#pragma mark - Private
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLBaseMatterCell *matterCell = (BLBaseMatterCell *)cell;
    BLMatterEntity *matterEntity = self.matterList[0];
    
    matterCell.matterTitleLabel.text = matterEntity.title;
    matterCell.receivedDateLabel.text = matterEntity.receivedDate.description;
    matterCell.matterTypeLabel.text = matterEntity.matterType;
    #warning 设置流转次数
}

@end
