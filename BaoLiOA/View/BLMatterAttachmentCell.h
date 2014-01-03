//
//  BLMatterAttachmentCell.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLMatterAttachmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *attachmentTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@end
