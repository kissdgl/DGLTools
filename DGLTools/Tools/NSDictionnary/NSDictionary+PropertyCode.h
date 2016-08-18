//
//  NSDictionary+PropertyCode.h
//  05-runtimeKVC的实现
//
//  Created by 丁贵林 on 16/8/18.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PropertyCode)

/**
 *  将字典转换为属性代码
 */
- (void)createPropertyCode;

@end
