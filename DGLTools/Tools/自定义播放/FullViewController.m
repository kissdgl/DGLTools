//
//  FullViewController.m
//  02-远程视频播放(AVPlayer)
//
//  Created by 丁贵林 on 16/8/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "FullViewController.h"
#import "FullView.h"

@interface FullViewController ()

@end

@implementation FullViewController

- (void)loadView
{
    FullView *fullView = [[FullView alloc] init];
    self.view = fullView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
