//
//  BLManageFollowViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLManageFollowViewControllerDelegate <NSObject>

- (void)FollowDidSelected:(NSArray *)followList;

@end

@interface BLManageFollowViewController : UIViewController

@property (strong, nonatomic) NSArray *followList;

@property (weak, nonatomic) id<BLManageFollowViewControllerDelegate> delegate;

@end
