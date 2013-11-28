//
//  BLOpinionViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLOpinionViewControllerDelegate <NSObject>

- (void)opinionDidSelecte:(NSString *)opinion;

@end

@interface BLOpinionViewController : UITableViewController

@property (weak, nonatomic) id<BLOpinionViewControllerDelegate> delegate;

@end
