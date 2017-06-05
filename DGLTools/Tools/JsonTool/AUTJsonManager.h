//
//  AUTJsonManager.h
//  MobVDT
//
//  Created by Autel_Ling on 2017/3/20.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUTJsonManager : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)convertToJsonData:(NSDictionary *)dict;

@end
