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
#import <CommonCrypto/CommonCrypto.h>

@implementation BLUserService

- (void)loginWithLoginID:(NSString *)loginID password:(NSString *)password block:(BLUserServiceLoginBlock)block
{
    // 给密码加密
    NSString *passwordUesDES = [BLUserService encryptUseDES:password key:@"Poly"];
    
    [BLUserHTTPLogic loginWithUserID:loginID password:password block:^(id responseData, NSError *error) {
        if (error) {
            block(NO, @"登录失败，请检查您的网络或稍后再试。");
        }
        else {
            NSLog(@"Response [Login Data]: %@", [[NSString alloc] initWithData:responseData
                                                                      encoding:NSUTF8StringEncoding]);
            
            
            RXMLElement *rootElement = [RXMLElement elementFromXMLData:responseData];
            
            BOOL loginResult = [[rootElement child:@"Body.IOSLoginResponse.IOSLoginResult"].text isEqualToString:@"true"];
            
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
                NSString *phoneOfficeAuthy = [rootElement child:@"Body.IOSLoginResponse.userInfo.Phone_office_Authy"].text;
                NSString *phoneChartAuthy = [rootElement child:@"Body.IOSLoginResponse.userInfo.Phone_Chart_Authy"].text;
                NSString *isNeedCheckCode = [rootElement child:@"Body.IOSLoginResponse.userInfo.isNeedCheckCode"].text;
                NSString *checkCode = [rootElement child:@"Body.IOSLoginResponse.userInfo.CheckCode"].text;
                
                
                BLContextEntity *context = [[BLContextEntity alloc] initWithUserID:userID
                                                                          userName:userName
                                                                          oaUserID:oaUserId
                                                                        oaUserName:oaUserName
                                                                         oaAccount:oaAccount
                                                                        actionDesc:@""];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:context] forKey:@"Context"];
                
                block(YES, nil);
            }
            else {
                NSString *errorMsg = [rootElement child:@"Body.IOSLoginResponse.errorMsg"].text;
                block(NO, errorMsg);
            }
        }
    }];
}


const Byte iv[] = {1,2,3,4,5,6,7,8};
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self encode:data];
    }
    return ciphertext;
}



static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSString *)encode:(NSData *)data
{
    if (data.length == 0)
        return nil;
    
    char *characters = malloc(data.length * 3 / 2);
    
    if (characters == NULL)
        return nil;
    
    int end = data.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
    
}

+(NSData *)decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = data.length;
    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }
        
        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}

+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

@end
