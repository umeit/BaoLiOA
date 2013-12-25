//
//  BLSegmentMatterListViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLSegmentMatterListViewController.h"

@interface BLSegmentMatterListViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation BLSegmentMatterListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Action

- (IBAction)segmentValueChanged:(UISegmentedControl *)segmentedControl
{
    NSInteger selectedIndex = segmentedControl.selectedSegmentIndex;
    
    if (selectedIndex == 0) {
        self.matterStatus = 0;
    }
    else {
        self.matterStatus = 1;
    }
    
    [self updateData];
}

@end
