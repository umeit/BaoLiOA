//
//  BLAddOpinionViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-27.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLAddOpinionViewController.h"

@interface BLAddOpinionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BLAddOpinionViewController

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
	
    [self.textField becomeFirstResponder];
}

#pragma mark - Action

- (IBAction)okButtonPress:(id)sender
{
    if (self.textField.text && [self.textField.text length] > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *commonOpinionList = [[userDefaults arrayForKey:@"kCommonOpinionList"] mutableCopy];
        
        if (!commonOpinionList) {
            commonOpinionList = [NSMutableArray arrayWithObject:self.textField.text];
        }
        else {
            [commonOpinionList addObject:self.textField.text];
        }
        
        [userDefaults setObject:commonOpinionList forKey:@"kCommonOpinionList"];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate performSelector:@selector(reloadData) withObject:nil];
        }];
    }
}

- (IBAction)cancelButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
