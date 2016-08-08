//
//  DGLFileManager.m
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/13.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "DGLFileManager.h"

@implementation DGLFileManager

+ (NSInteger)getSizeDirectorySize:(NSString *)directroyPath {
    
    
    NSFileManager *filemaneger = [NSFileManager defaultManager];
    
    //获取文件夹下的所有文件
    NSArray *subpaths = [filemaneger subpathsAtPath:directroyPath];
    NSInteger totalSize = 0;
    for (NSString *subpath in subpaths) {
        NSString *filePath = [directroyPath stringByAppendingPathComponent:subpath];
        
        //排除文件夹
        BOOL isDirectory;
        BOOL isExist = [filemaneger fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory) continue;
        
        //隐藏文件
        if ([filePath containsString:@".DS"])continue;
        
        NSDictionary *attr = [filemaneger attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [attr fileSize];
        totalSize += size;
    }
    
    return totalSize;
    
}

+ (void)removeDirectoryPath:(NSString *)directoryPath {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 报错:抛异常
        NSException *excp = [NSException exceptionWithName:@"filePathError" reason:@"传错,必须传文件夹路径" userInfo:nil];
        
        [excp raise];
        
    }
    
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subpath in subpaths) {
        
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subpath];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }

}

@end
