//
//  BLSettingViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-27.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLSettingViewController.h"

@interface BLSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *commonOpinionNumberLabel;

@end

@implementation BLSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *commonOpinionList = [[NSUserDefaults standardUserDefaults] arrayForKey:@"kCommonOpinionList"];
    if (commonOpinionList && [commonOpinionList count] > 0) {
        self.commonOpinionNumberLabel.text = [NSString stringWithFormat:@"共%d条", [commonOpinionList count]];
    }
    else {
        self.commonOpinionNumberLabel.text = @"暂无";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end