//
//  BLContextEntity.m
//  BaoLiOA
//
//  Created by Liu Feng on 14-1-9.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import "BLContextEntity.h"

@implementation BLContextEntity

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userID = [aDecoder decodeObjectForKey:@"UserID"];
        _userName = [aDecoder decodeObjectForKey:@"UserName"];
        _oaUserID = [aDecoder decodeObjectForKey:@"OAUserID"];
        _oaUserName = [aDecoder decodeObjectForKey:@"OAUserName"];
        _oaAccount = [aDecoder decodeObjectForKey:@"OAAccount"];
        _actionDesc = [aDecoder decodeObjectForKey:@"ActionDesc"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"UserID"];
    [aCoder encodeObject:self.userName forKey:@"UserName"];
    [aCoder encodeObject:self.oaUserID forKey:@"OAUserID"];
    [aCoder encodeObject:self.oaUserName forKey:@"OAUserName"];
    [aCoder encodeObject:self.oaAccount forKey:@"OAAccount"];
    [aCoder encodeObject:self.actionDesc forKey:@"ActionDesc"];
}

- (id)initWithUserID:(NSString *)userID userName:(NSString *)userName oaUserID:(NSString *)oaUserID oaUserName:(NSString *)oaUserName oaAccount:(NSString *)oaAccount actionDesc:(NSString *)actionDesc
{
    self = [super init];
    if (self) {
        _userID = userID;
        _userName = userName;
        _oaUserID = oaUserID;
        _oaUserName = oaUserName;
        _oaAccount = oaAccount;
        _actionDesc = actionDesc;
    }
    return self;
}

@end
