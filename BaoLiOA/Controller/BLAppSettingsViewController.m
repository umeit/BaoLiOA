//
//  BLAppSettingsViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLAppSettingsViewController.h"

@interface BLAppSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serverAddressTextField;
@end

@implementation BLAppSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *appSettingsDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"AppSettings"];
    self.serverAddressTextField.text = appSettingsDic[@"ServerAddress"];
}

#pragma mark - Action

- (IBAction)saveButtonPress:(id)sender
{
    NSDictionary *newAppSettingsDic = @{@"ServerAddress": self.serverAddressTextField.text};
    [[NSUserDefaults standardUserDefaults] setObject:newAppSettingsDic forKey:@"AppSettings"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
