//
//  BLOpinionViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLCommonOpinionViewControllerDelegate <NSObject>

- (void)opinionDidSelecte:(NSString *)opinion;

@end

@interface BLCommonOpinionViewController : UITableViewController

@property (weak, nonatomic) id<BLCommonOpinionViewControllerDelegate> delegate;

@end
