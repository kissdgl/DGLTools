//
//  ViewController.m
//  DGLTools
//
//  Created by 丁贵林 on 16/8/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "ViewController.h"
#import "DGLTools-Swift.h"
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}



- (void)setup {
    
    
    NSObject *objc = objc_msgSend([NSObject class], @selector(alloc));
    objc = objc_msgSend(objc, @selector(init));
    NSLog(@"%@", objc);
}

@end
