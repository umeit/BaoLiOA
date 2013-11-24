//
//  BLMatterOperationViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationViewController.h"

@interface BLMatterOperationViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation BLMatterOperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIViewController *vc = [self viewControllerForSelectedSegment];
    [self addChildViewController:vc];
    
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    
    self.currentViewController = vc;
}

#pragma - mark Private

- (UIViewController *)viewControllerForSelectedSegment
{
    UIViewController *vc;
    
    switch (self.SegmentView.selectedSegmentIndex) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterFormViewController"];
            break;
            
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"xxx"];
            break;
            
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"xxx"];
            break;
            
        case 3:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"xxx"];
            break;
        default:
            break;
    }
    return vc;
}

@end
