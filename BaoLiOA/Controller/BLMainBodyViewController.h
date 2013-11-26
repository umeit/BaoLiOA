//
//  BLMainBodyViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLMainBodyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *mainBodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;
@property (strong, nonatomic) NSString *mainBodyFilePath;
@end
