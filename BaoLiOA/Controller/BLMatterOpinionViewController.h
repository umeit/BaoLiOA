//
//  BLMatterOpinionViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLMatterOpinionViewControllerDelegate <NSObject>

- (void)opinionDidSelect:(NSString *)opinion;

@end


@interface BLMatterOpinionViewController : UIViewController

@property (weak, nonatomic) id<BLMatterOpinionViewControllerDelegate> delegate;

@end
