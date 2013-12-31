//
//  BLMatterOperationViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLMatterOperationViewControllerDelegate <NSObject>

- (void)matterOperationDidFinish;

@end

@interface BLMatterOperationViewController : UIViewController

@property (strong, nonatomic) NSString *matterID;

@property (strong, nonatomic) NSString *matterTitle;

@property (weak, nonatomic) id<BLMatterOperationViewControllerDelegate> delegate;

@end
