//
//  NSObject+Model.m
//  runtimeKVC的实现
//
//  Created by 丁贵林 on 16/8/18.
//  Copyright © 2016年 丁贵林. All rights reserved.
//
#import "NSObject+Model.h"
#import <objc/message.h>

@implementation NSObject (Model)

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    
    id objc = [[self alloc] init];
    
    //runtime
    int count = 0;
    
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    
    //遍历所有的成员变量
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        NSString *key = [ivarName substringFromIndex:1];
        
//        NSLog(@"%@", key);
        //从字典中取出对应的value
        id value = dict[key];
        
        //获取成员变量的类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
        type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        //只有是字典才转换
        if ([value isKindOfClass:[NSDictionary class]] && ![type containsString:@"NS"]) {
            //字典转模型

            
            //获取类对象
            Class className = NSClassFromString(type);
            
            //字典转模型
            value = [className modelWithDict:value];
        }
        
        NSLog(@"%@", [value class]);
        //给模型中属性赋值
        [objc setValue:value forKey:key];
    }
    
    return objc;
}

@end
