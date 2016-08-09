//
//  UIView+Frame.h
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property CGFloat DGL_Width;
@property CGFloat DGL_Height;
@property CGFloat DGL_X;
@property CGFloat DGL_Y;
@property CGFloat DGL_CenterX;
@property CGFloat DGL_CenterY;

+ (instancetype)dgl_viewFromXib;

@end
