//
//  BLMainPageForiPhoneViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 14-3-19.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import "BLMainPageForiPhoneViewController.h"
#import "BLBaseMatterListViewController.h"

#define BacklogTag     30
#define TakenTag       31
#define ToReadTag      32
#define ReadTag        33
#define InDocTag       34
#define GiveRemarkTag  35
#define SettingTag     36

@interface BLMainPageForiPhoneViewController ()

@end

@implementation BLMainPageForiPhoneViewController

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
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        
        switch (button.tag) {
            case BacklogTag:
                [self segue:segue toMatterListWithType:kTodoMatterList];
                break;
            case TakenTag:
                [self segue:segue toMatterListWithType:kTakenMatterList];
                break;
            case ToReadTag:
                [self segue:segue toMatterListWithType:kToReadMatterList];
                break;
            case ReadTag:
                [self segue:segue toMatterListWithType:kReadMatterList];
                break;
            case InDocTag:
                [self segue:segue toMatterListWithType:kInDocMatterList];
                break;
            case GiveRemarkTag:
                [self segue:segue toMatterListWithType:kGiveRemarkMatterList];
                break;
            default:
                break;
        }
    }
}

- (void)segue:(UIStoryboardSegue *)segue toMatterListWithType:(MatterTypeOfBaseMatterList)MatterType
{
    BLBaseMatterListViewController *baseMatterListViewController = (BLBaseMatterListViewController *)segue.destinationViewController;
    baseMatterListViewController.currentMatterType = MatterType;
}

@end
