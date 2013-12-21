//
//  BLBaseListViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MatterTypeOfBaseMatterList : NSUInteger {
    kTodoMatterList,
    kTakenMatterList,
    kToReadMatterList,
    kReadMatterList
} MatterTypeOfBaseMatterList;

@interface BLBaseMatterListViewController : UITableViewController

@property (nonatomic) MatterTypeOfBaseMatterList currentMatterType;

@end
