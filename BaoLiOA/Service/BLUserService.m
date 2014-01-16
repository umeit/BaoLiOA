//
//  BLUserService.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-30.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLUserService.h"
#import "BLUserHTTPLogic.h"
#import "RXMLElement.h"
#import "BLContextEntity.h"

@implementation BLUserService

- (void)loginWithLoginID:(NSString *)loginID password:(NSString *)password block:(BLUserServiceGeneralRetCode)block
{
    [BLUserHTTPLogic loginWithUserID:loginID password:password block:^(id responseData, NSError *error) {
        if (error) {
            block(-1);
        }
        else {
            NSLog(@"Response [Login Data]: %@", [[NSString alloc] initWithData:responseData
                                                                      encoding:NSUTF8StringEncoding]);
            
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            BOOL loginResult = [[rootElement child:@"Body.IOSLoginResponse.IOSLoginResult"].text isEqualToString:@"ture"];
            
            if (loginResult) {
                NSString *userID = [rootElement child:@"Body.IOSLoginResponse.userInfo.UserID"].text;
                NSString *userName = [rootElement child:@"Body.IOSLoginResponse.userInfo.UserName"].text;
                NSString *simIMSI = [rootElement child:@"Body.IOSLoginResponse.userInfo.SimIMSI"].text;
                NSString *phoneIMEI = [rootElement child:@"Body.IOSLoginResponse.userInfo.PhoneIMEI"].text;
                NSString *phoneNumber = [rootElement child:@"Body.IOSLoginResponse.userInfo.PhoneNumber"].text;
                NSString *companyName = [rootElement child:@"Body.IOSLoginResponse.userInfo.CompanyName"].text;
                NSString *oaUserName = [rootElement child:@"Body.IOSLoginResponse.userInfo.OA_UserName"].text;
                NSString *oaDeptName = [rootElement child:@"Body.IOSLoginResponse.userInfo.OA_DeptName"].text;
                NSString *oaUserId = [rootElement child:@"Body.IOSLoginResponse.userInfo.OA_UserId"].text;
                NSString *oaAccount = [rootElement child:@"Body.IOSLoginResponse.userInfo.OA_Account"].text;
                NSString *pwdString = [rootElement child:@"Body.IOSLoginResponse.userInfo.pwd_string"].text;
                NSString *bindDevice = [rootElement child:@"Body.IOSLoginResponse.userInfo.BindDevice"].text;
                NSString *bindDevice = [rootElement child:@"Body.IOSLoginResponse.userInfo.BindDevice"].text;
                NSString *phoneOfficeAuthy = [rootElement child:@"Body.IOSLoginResponse.userInfo.Phone_office_Authy"].text;
                NSString *phoneChartAuthy = [rootElement child:@"Body.IOSLoginResponse.userInfo.Phone_Chart_Authy"].text;
                NSString *isNeedCheckCode = [rootElement child:@"Body.IOSLoginResponse.userInfo.isNeedCheckCode"].text;
                NSString *checkCode = [rootElement child:@"Body.IOSLoginResponse.userInfo.CheckCode"].text;
                
                
                BLContextEntity *context = [[BLContextEntity alloc] initWithUserID:@"xuns"
                                                                          userName:@"登录名"
                                                                          oaUserID:@"HZ8181e5415cd79f01415d08d0a505e2"
                                                                        oaUserName:@"真实姓名"
                                                                         oaAccount:@"OA用户名"
                                                                        actionDesc:@""];
            }
            
            block(0);
        }
    }];
    
    block(0);
}

@end
