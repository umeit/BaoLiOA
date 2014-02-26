//
//  BLMatterFormViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLMatterFormViewControllerDelegate <NSObject>

- (void)eidtOpinionForKey:(NSString *)key value:(NSString *)value;

@end

@interface BLMatterFormViewController : UITableViewController

//@property (strong, nonatomic) NSString *matterID;

/**
 *  Form 信息
 */
@property (strong, nonatomic) NSArray *matterFormInfoList;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  正文附件 ID
 */
//@property (strong, nonatomic) NSString *matterBodyDocID;


@property (weak, nonatomic) id<BLMatterFormViewControllerDelegate>delegate;

@end
