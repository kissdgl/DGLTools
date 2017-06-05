//
//  AUTJsonManager.m
//  MobVDT
//
//  Created by Autel_Ling on 2017/3/20.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import "AUTJsonManager.h"

@implementation AUTJsonManager

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    
    if (jsonString == nil) {
        return nil;
    }
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];


    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;

    
}

@end
