//
//  DGLCSVTool.h
//  DGLCSVTool
//
//  Created by Autel_Ling on 2017/3/30.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGLCSVTool : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;
+ (instancetype)csvWithFilePath:(NSString *)filePath;

- (void)addDataStreamArr:(NSArray *)dataArr;

- (void)generateCSVFile;

@end
