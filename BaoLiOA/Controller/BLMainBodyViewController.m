//
//  BLMainBodyViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMainBodyViewController.h"
#import "BLMatterOperationService.h"

@interface BLMainBodyViewController ()

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

@end

@implementation BLMainBodyViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.matterOprationService matterBodyTextWithBodyDocID:self.bodyDocID block:^(id obj, NSError *error) {
        self.mainBodyTextView.text = obj;
    }];
}


@end
