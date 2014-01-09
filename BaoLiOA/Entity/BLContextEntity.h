//
//  BLContextEntity.h
//  BaoLiOA
//
//  Created by Liu Feng on 14-1-9.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLContextEntity : NSObject <NSCoding>

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *oaUserID;
@property (strong, nonatomic) NSString *oaUserName;
@property (strong, nonatomic) NSString *oaAccount;
@property (strong, nonatomic) NSString *actionDesc;

- (id)initWithUserID:(NSString *)userID userName:(NSString *)userName oaUserID:(NSString *)oaUserID oaUserName:(NSString *)oaUserName oaAccount:(NSString *)oaAccount actionDesc:(NSString *)actionDesc;

@end
