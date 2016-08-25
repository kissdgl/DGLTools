//
//  FullView.m
//  02-远程视频播放(AVPlayer)
//
//  Created by 丁贵林 on 16/8/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "FullView.h"

@implementation FullView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

@end
