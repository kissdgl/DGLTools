//
//  DGLFileManager.h
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/13.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGLFileManager : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directroyPath 传入文件夹全路径
 *
 *  @return 文件夹尺寸
 */
+ (NSInteger)getSizeDirectorySize:(NSString *)directroyPath;


/**
 *  删除文件夹下所有文件
 *
 *  @param directoryPath 文件夹全路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
