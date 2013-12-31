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
    
    switch (self.currentMatterType) {
        case kInDocMatterList:
        {
            [self.segmentedControl setTitle:@"待办收文" forSegmentAtIndex:0];
            [self.segmentedControl setTitle:@"已办收文" forSegmentAtIndex:1];
        }
            break;
        
        case kGiveRemarkMatterList:
        {
            [self.segmentedControl setTitle:@"待办呈批件" forSegmentAtIndex:0];
            [self.segmentedControl setTitle:@"已办呈批件" forSegmentAtIndex:1];
        }
            break;
            
        default:
            break;
    }
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
