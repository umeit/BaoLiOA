//
//  BLBaseListViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MatterTypeOfBaseMatterList : NSUInteger {
    kTodoMatterList,        // 待办
    kTakenMatterList,       // 已办
    kToReadMatterList,      // 待阅
    kReadMatterList,        // 已阅
    kInDocMatterList,       // 收文
    kGiveRemarkMatterList   // 呈批件
} MatterTypeOfBaseMatterList;

@interface BLBaseMatterListViewController : UITableViewController

@property (nonatomic) MatterTypeOfBaseMatterList currentMatterType;

@end
