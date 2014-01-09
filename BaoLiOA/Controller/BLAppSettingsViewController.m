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
@property (weak, nonatomic) IBOutlet UITextField *serverPortTextField;
@end

@implementation BLAppSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *serverIP = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerAddress"];
    NSString *serverPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerPort"];
    self.serverAddressTextField.text = serverIP;
    self.serverPortTextField.text = serverPort;
}

#pragma mark - Action

- (IBAction)saveButtonPress:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.serverAddressTextField.text forKey:@"ServerAddress"];
    [userDefaults setObject:self.serverPortTextField.text forKey:@"ServerPort"];
    
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
