//
//  BLUserHTTPLogic.h
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLUserHTTPLogicGeneralBlock)(id responseData, NSError *error);

@interface BLUserHTTPLogic : NSObject

+ (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(BLUserHTTPLogicGeneralBlock)block;

@end
