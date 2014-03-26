//
//  BLMatterOpinionViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOpinionViewController.h"
#import "BLCommonOpinionViewController.h"

@interface BLMatterOpinionViewController () <BLCommonOpinionViewControllerDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *opinionTextField;
//@property (weak, nonatomic) IBOutlet UITextView *opinionTextView;
//@property (weak, nonatomic) UIPopoverController *commonOpinionPopover;
@end

@implementation BLMatterOpinionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.opinionTextView.text = self.comment;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editFinish)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


#pragma mark - Observer

- (void)editFinish
{
    [self.delegate opinionDidFinish:self.opinionTextView.text];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BLCommonOpinionViewController *vc = segue.destinationViewController;
    vc.delegate = self;
    
    if (IS_IPAD) {
        self.commonOpinionPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}


#pragma mark - BLCommonOpinionViewControllerDelegate

- (void)opinionDidSelecte:(NSString *)opinion
{
    self.opinionTextView.text = opinion;
    
    [self.delegate opinionDidFinish:opinion];
    
    [self.commonOpinionPopover dismissPopoverAnimated:YES];
}

@end
