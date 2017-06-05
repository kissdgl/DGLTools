//
//  NSString+Regex.h
//  MobVDT
//
//  Created by autel on 17/3/21.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

/**
 *  验证邮箱是不是可用
 *
 *  return YES / NO
 */
- (BOOL)isValidateEmail;

/**
 *  验证是不是数字
 *
 *  return YES / NO
 */
- (BOOL)isNumber;

/**
 *  验证是不是英文
 *
 *  return YES / NO
 */
- (BOOL)isEnglish;


/**
 验证是否为英文或数字

 @return YES/NO
 */
- (BOOL)isEnglishOrNumber;

/**
 *  验证是不是汉字
 *
 *  return YES / NO
 */
- (BOOL)isChinese;

/**
 *  验证是不是网络链接地址
 *
 *  return YES / NO
 */
- (BOOL)isInternetUrl;



//是不是邮编
- (BOOL)isZipCode;

/**
 *  是不是手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return YES / NO
 */

- (BOOL)isMobileNumber:(NSString *)mobileNum;

- (BOOL)isCarLicenceNumber;

// 判断字符串是否为空字符的方法
- (BOOL)isEmptyString;

//字符串去掉回车和空格
- (NSString*)stringWithNotWhitespaceAndNewlineCharacterSet;

//是否为英文中文数字
- (BOOL)isEnglishChineseNumber;


@end
