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
#import "GTMBase64.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation BLUserService

- (void)loginWithLoginID:(NSString *)loginID password:(NSString *)password block:(BLUserServiceLoginBlock)block
{
    // 给密码加密
    NSString *passwordUesDES = [BLUserService encryptUseDES:password key:@"01x15897"];
    
    [BLUserHTTPLogic loginWithUserID:loginID password:passwordUesDES block:^(id responseData, NSError *error) {
        if (error) {
            block(NO, @"登录失败，请检查您的网络或稍后再试。");
        }
        else {
            NSLog(@"Response [Login Data]: %@", [[NSString alloc] initWithData:responseData
                                                                      encoding:NSUTF8StringEncoding]);
            
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            BOOL loginResult = [[rootElement child:@"Body.PPCLoginResponse.PPCLoginResult"].text isEqualToString:@"true"];
            
            if (loginResult) {
                NSString *userID = [rootElement child:@"Body.PPCLoginResponse.userInfo.UserID"].text;
                NSString *userName = [rootElement child:@"Body.PPCLoginResponse.userInfo.UserName"].text;
                NSString *simIMSI = [rootElement child:@"Body.PPCLoginResponse.userInfo.SimIMSI"].text;
                NSString *phoneIMEI = [rootElement child:@"Body.PPCLoginResponse.userInfo.PhoneIMEI"].text;
                NSString *phoneNumber = [rootElement child:@"Body.PPCLoginResponse.userInfo.PhoneNumber"].text;
                NSString *companyName = [rootElement child:@"Body.PPCLoginResponse.userInfo.CompanyName"].text;
                NSString *oaUserName = [rootElement child:@"Body.PPCLoginResponse.userInfo.OA_UserName"].text;
                NSString *oaDeptName = [rootElement child:@"Body.PPCLoginResponse.userInfo.OA_DeptName"].text;
                NSString *oaUserId = [rootElement child:@"Body.PPCLoginResponse.userInfo.OA_UserId"].text;
                NSString *oaAccount = [rootElement child:@"Body.PPCLoginResponse.userInfo.OA_Account"].text;
                NSString *pwdString = [rootElement child:@"Body.PPCLoginResponse.userInfo.pwd_string"].text;
                NSString *bindDevice = [rootElement child:@"Body.PPCLoginResponse.userInfo.BindDevice"].text;
                NSString *phoneOfficeAuthy = [rootElement child:@"Body.PPCLoginResponse.userInfo.Phone_office_Authy"].text;
                NSString *phoneChartAuthy = [rootElement child:@"Body.PPCLoginResponse.userInfo.Phone_Chart_Authy"].text;
                NSString *isNeedCheckCode = [rootElement child:@"Body.PPCLoginResponse.userInfo.isNeedCheckCode"].text;
                NSString *checkCode = [rootElement child:@"Body.PPCLoginResponse.userInfo.CheckCode"].text;
                
                
                BLContextEntity *context = [[BLContextEntity alloc] initWithUserID:userID
                                                                          userName:userName
                                                                          oaUserID:oaUserId
                                                                        oaUserName:oaUserName
                                                                         oaAccount:oaAccount
                                                                        actionDesc:@""];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:context] forKey:@"Context"];
                [userDefaults setObject:loginID forKey:@"kLoginID"];
                
                // 设置默认「常用意见」
                NSMutableArray *commonOpinionList = [[userDefaults arrayForKey:[NSString stringWithFormat:@"%@%@", @"kCommonOpinionList", [[NSUserDefaults standardUserDefaults] stringForKey:@"kLoginID"]]] mutableCopy];
                if (!commonOpinionList) {
                    commonOpinionList = [NSMutableArray arrayWithObject:@"同意"];
                    [userDefaults setObject:commonOpinionList forKey:[NSString stringWithFormat:@"%@%@", @"kCommonOpinionList", [[NSUserDefaults standardUserDefaults] stringForKey:@"kLoginID"]]];
                }
                
                block(YES, nil);
            }
            else {
                NSString *errorMsg = [rootElement child:@"Body.PPCLoginResponse.errorMsg"].text;
                block(NO, errorMsg);
            }
        }
    }];
}


static Byte iv[] = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes,
                                          dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext =[GTMBase64 stringByEncodingData:data];
    }
    return ciphertext;
}

@end
