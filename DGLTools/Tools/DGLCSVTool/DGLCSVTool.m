//
//  DGLCSVTool.m
//  DGLCSVTool
//
//  Created by Autel_Ling on 2017/3/30.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import "DGLCSVTool.h"
#import "AUTDataStreamModel.h"

@interface DGLCSVTool ();

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSMutableString *content;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation DGLCSVTool


- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
    }
    return self;
}

+ (instancetype)csvWithFilePath:(NSString *)filePath {
    
    DGLCSVTool *tool = [[DGLCSVTool alloc] initWithFilePath:filePath];
    
    return tool;
}


- (void)addDataStreamArr:(NSArray *)dataArr {
    
//    for (AUTDataStreamModel *dataStreamModel in dataArr) {
//        
//        NSMutableArray *mArray = [NSMutableArray array];
//        
//        
//    }
    
    
    self.dataArr = dataArr;
}


- (void)generateCSVFile {
    
    [self appendContents];
    
    //创建文件夹
    [self creatDirectoryIfNotExistWithPath:CSV_ResultDirectory];
    
    //创建文件
    [self createFile:self.filePath];
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:self.filePath append:YES];
    [output open];
    
    if (![output hasSpaceAvailable]) return;//没有足够的空间
    
    const uint8_t *contentStr = (const uint8_t *)[self.content cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger headerLength = [self.content lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger result = [output write:contentStr maxLength:headerLength];
    if (result <= 0) {
        NSLog(@"写入错误");
    }
}

//拼接数据内容
- (void)appendContents {
    
    //创建title
    self.content = [NSMutableString stringWithString:@"MaxiAP Data Log\n"];
    
    //时间
    NSDate *date = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MM-dd yyyy HH:mm:SS";
    NSString * dateToString = [dateFormat stringFromDate:date];
    
    [self.content appendFormat:@"%@\n", dateToString];
    
    for (NSArray *frameData in self.dataArr) {
        
        NSString *frameStr = [frameData componentsJoinedByString:@","];
        frameStr = [NSString stringWithFormat:@"%@\n", frameStr];
        
        [self.content appendString:frameStr];
    }
    
}


//判断文件夹是否存在 不存在则创建
- (void)creatDirectoryIfNotExistWithPath:(NSString *)directPath {
    
    NSFileManager *fileManamger = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    BOOL isExist = [fileManamger fileExistsAtPath:directPath isDirectory:&isDirectory];
    
    if (!(isExist && isDirectory)) {//若不存在则创建文件夹
        
        NSError *error;
        BOOL flag = [fileManamger createDirectoryAtPath:directPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (flag) {
            NSLog(@"创建成功");
        } else {
            NSLog(@"创建失败");
            NSLog(@"%@", error.localizedDescription);
        }
    }
    
}


- (void)createFile:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    
    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        NSLog(@"不能创建文件");
    }
}


#pragma mark - lazyloading
//- (NSMutableString *)content {
//    if (!_content) {
//        _content = [NSMutableString string];
//    }
//    return _content;
//}


@end
