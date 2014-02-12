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

@property (weak, nonatomic) IBOutlet UISwitch *isUseVPNSwitch;
@property (weak, nonatomic) IBOutlet UITextField *vpnAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *vpnPortTextField;

@end

@implementation BLAppSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *serverIP = [userDefaults stringForKey:@"ServerAddress"];
    NSString *serverPort = [userDefaults stringForKey:@"ServerPort"];
    
    BOOL isUseVPN = [userDefaults boolForKey:@"UseVPN"];
    NSString *vpnIP = [userDefaults stringForKey:@"VPNAddress"];
    NSNumber *vpnPort = [userDefaults objectForKey:@"VPNPort"];
    
    self.serverAddressTextField.text = serverIP;
    self.serverPortTextField.text = serverPort;
    
    self.isUseVPNSwitch.on = isUseVPN;
    self.vpnAddressTextField.text = vpnIP;
    self.vpnPortTextField.text = [vpnPort stringValue];
}

#pragma mark - Action
- (IBAction)vpnUseSwitch:(UISwitch *)useSwitch
{
    
}

- (IBAction)saveButtonPress:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.serverAddressTextField.text forKey:@"ServerAddress"];
    [userDefaults setObject:self.serverPortTextField.text forKey:@"ServerPort"];
    
    [userDefaults setObject:@(self.isUseVPNSwitch.on) forKey:@"UseVPN"];
    [userDefaults setObject:self.vpnAddressTextField.text forKey:@"VPNAddress"];
    NSInteger port = [self.vpnPortTextField.text integerValue];
    [userDefaults setObject:@(port) forKey:@"VPNPort"];
    
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
