//
//  BLBaseMatterCell.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLBaseMatterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *matterTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *receivedDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *flowTimesImageView;

@property (weak, nonatomic) IBOutlet UILabel *matterTypeLabel;

@end
