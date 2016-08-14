//
//  ViewController.m
//  DGLTools
//
//  Created by 丁贵林 on 16/8/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "ViewController.h"
#import "DGLTools-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}



- (void)setup {
    
    LRTableView *lrTableView = [[LRTableView alloc] init];
    lrTableView.leftTableView.backgroundColor = [UIColor orangeColor];
    lrTableView.rightTableView.backgroundColor = [UIColor blueColor];
    lrTableView.frame = CGRectMake(100, 100, 100, 300);
    
    [self.view addSubview:lrTableView];
    
}

@end
