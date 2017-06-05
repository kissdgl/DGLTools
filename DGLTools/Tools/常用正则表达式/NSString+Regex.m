//
//  NSString+Regex.m
//  MobVDT
//
//  Created by autel on 17/3/21.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import "NSString+Regex.h"

#define REGULAR_FILE_NAME @"Regular"

// 判断邮件格式正则表达式
#define EMAIL_REGEX_NAME @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"

// 判断数字正则表达式
#define NUMBER_REGEX_NAME @"^[0-9]*$"

// 判断英文正则表达式
#define ENGLISH_REGEX_NAME @"^[A-Za-z]+$"

//英文+数字
#define ENGLISH_NUMBER_REGES_NAME @"^[A-Za-z0-9]+$"

// 判断中文正则表达式
#define CHINESE_REGEX_NAME @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$"

#define INTERNET_URL_REGEX_NAME @"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"

#define CARLICENCENUMBER    @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$"

#define ZIPCODENUMBER @"^[1-9]\d{5}$"

@implementation NSString (Regex)

// 邮件
- (BOOL)isValidateEmail
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX_NAME];
    return [regex evaluateWithObject:self];
}

// 数字
- (BOOL)isNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUMBER_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 英文
- (BOOL)isEnglish
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ENGLISH_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

//英文+数字
- (BOOL)isEnglishOrNumber {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ENGLISH_NUMBER_REGES_NAME];
    
    return [predicate evaluateWithObject:self];
}

// 汉字
- (BOOL)isChinese
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CHINESE_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 网址
- (BOOL)isInternetUrl
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", INTERNET_URL_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 正则判断手机号码格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)isCarLicenceNumber{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CARLICENCENUMBER];
    return [predicate evaluateWithObject:self];
    
}


- (BOOL)isZipCode{
    
    //    NSString *ZipCode = @"^[1-9]\\d{5}$";
    NSString *ZipCode = @"^\\d{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ZipCode];
    return [predicate evaluateWithObject:self];
    
}

- (BOOL)isEmptyString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (NSString*)stringWithNotWhitespaceAndNewlineCharacterSet
{
    NSString *str = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str  stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return str;
    
}

//只能输入中文、英文或数字的正则表达式
- (BOOL)isEnglishChineseNumber{
    NSString *nickNameReg = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNameReg];
    return [predicate evaluateWithObject:self];
}

@end
