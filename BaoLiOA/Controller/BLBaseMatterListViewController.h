//
//  BLBaseListViewController.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MatterTypeOfBaseMatterList : NSInteger {
    TodoMatterList   = 1,
    TakenMatterList  = 2,
    ToReadMatterList = 3,
    ReadMatterList   = 4
} MatterTypeOfBaseMatterList;

@interface BLBaseMatterListViewController : UITableViewController

@property (nonatomic) MatterTypeOfBaseMatterList currentMatterType;

@end
