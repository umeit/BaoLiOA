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
	
    // 为默认第一个被选中的 segment 获取对应的 view controller
    UIViewController *vc = [self viewControllerForSelectedSegment];
    [self addChildViewController:vc];
    
    // 修改新加入的的视图的尺寸，可以刚好放在预留好的地方
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    
    self.currentViewController = vc;
}

#pragma - mark Action

- (IBAction)segmentChanged:(UISegmentedControl *)segmentedControl
{
    UIViewController *vc = [self viewControllerForSelectedSegment];
    [self addChildViewController:vc];
//    [self transitionFromViewController:self.currentViewController
//                      toViewController:vc
//                              duration:0.5
//                               options:UIViewAnimationOptionOverrideInheritedOptions
//                            animations:^{
//                                [self.currentViewController.view removeFromSuperview];
//                                vc.view.frame =self.contentView.bounds;
//                                [self.contentView addSubview:vc.view];
//                            }
//                            completion:^(BOOL finished){
//                                [vc didMoveToParentViewController:self];
//                                [self.currentViewController removeFromParentViewController];
//                                self.currentViewController = vc;
//                            }
//    ];
    
    
    [self.currentViewController.view removeFromSuperview];
    vc.view.frame =self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = vc;
}
- (IBAction)submitButtonPress:(id)sender
{
}
- (IBAction)HasReadButtonPress:(id)sender
{
}
- (IBAction)temporaryButtonPress:(id)sender
{
}
- (IBAction)fallbackButtonPress:(id)sender
{
}

#pragma - mark Private

- (UIViewController *)viewControllerForSelectedSegment
{
    UIViewController *vc;
    
    // 根据 segment 的 index 找到相应的 view controller
    switch (self.SegmentView.selectedSegmentIndex) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterFormViewController"];
            break;
            
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterAttachmentListViewController"];
            break;
            
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterFlowListViewController"];
            break;
            
        case 3:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterOperationViewController"];
            break;
        default:
            break;
    }
    return vc;
}

@end
