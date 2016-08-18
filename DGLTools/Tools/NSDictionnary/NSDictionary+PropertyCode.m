//
//  NSDictionary+PropertyCode.m
//  05-runtimeKVC的实现
//
//  Created by 丁贵林 on 16/8/18.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "NSDictionary+PropertyCode.h"

@implementation NSDictionary (PropertyCode)

//自动生成属性
- (void)createPropertyCode {
    
    //模型中属性根据字典的key
    //有多少key 生成多少个属性
    
    
    NSMutableString *codes = [NSMutableString string];
    //遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
//        NSLog(@"%@", [value class]);
        NSString *code = nil;
        
        if ([value isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;", key];
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;", key];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;", key];
        } else if ([value isKindOfClass:[NSArray class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;", key];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;", key];
        }
        //拼接字符串
        [codes appendFormat:@"\n%@\n", code];
    }];
    
    NSLog(@"%@", codes);
}

@end
