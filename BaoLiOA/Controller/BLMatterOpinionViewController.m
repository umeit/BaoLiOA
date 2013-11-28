//
//  BLMatterOpinionViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOpinionViewController.h"
#import "BLOpinionViewController.h"

@interface BLMatterOpinionViewController () <BLOpinionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *opinionTextField;
@property (weak, nonatomic) IBOutlet UITextView *opinionTextView;
@property (weak, nonatomic) UIPopoverController *opinionPopover;
@end

@implementation BLMatterOpinionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BLOpinionViewController *vc = segue.destinationViewController;
    vc.delegate = self;
    
    self.opinionPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
}

#pragma mark - BLOpinionViewControllerDelegate

- (void)opinionDidSelecte:(NSString *)opinion
{
    self.opinionTextField.text = opinion;
    
    [self.opinionPopover dismissPopoverAnimated:YES];
}

@end
