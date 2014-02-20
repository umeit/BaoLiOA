//
//  BLQuickOpinionViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 14-1-13.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import "BLQuickOpinionViewController.h"

@interface BLQuickOpinionViewController ()

@end

@implementation BLQuickOpinionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)okPuttonPress:(id)sender
{
    [self.delegate opinionDidFinish:self.opinionTextView.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Observer

- (void)editFinish
{
    
}

#pragma mark - BLCommonOpinionViewControllerDelegate

- (void)opinionDidSelecte:(NSString *)opinion
{
    self.opinionTextView.text = opinion;
    
    [self.commonOpinionPopover dismissPopoverAnimated:YES];
}

@end
