//
//  UIView+Frame.m
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

+ (instancetype)dgl_viewFromXib {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


- (void)setDGL_Width:(CGFloat)DGL_Width {
    
    CGRect frame = self.frame;
    frame.size.width = DGL_Width;
    self.frame = frame;
    
}

- (void)setDGL_Height:(CGFloat)DGL_Height {
    
    CGRect frame = self.frame;
    frame.size.height = DGL_Height;
    self.frame = frame;
    
}

- (void)setDGL_X:(CGFloat)DGL_X {
    
    CGRect frame = self.frame;
    frame.origin.x = DGL_X;
    self.frame = frame;
    
}

- (void)setDGL_Y:(CGFloat)DGL_Y {
    
    CGRect frame = self.frame;
    frame.origin.y = DGL_Y;
    self.frame = frame;
    
}


- (void)setDGL_CenterX:(CGFloat)DGL_CenterX {
    
    CGPoint center = self.center;
    center.x = DGL_CenterX;
    self.center = center;
}

- (void)setDGL_CenterY:(CGFloat)DGL_CenterY {
    
    CGPoint center = self.center;
    center.y = DGL_CenterY;
    self.center = center;
    
}

- (CGFloat)DGL_Width {
    
    return self.frame.size.width;
    
}

- (CGFloat)DGL_Height {
    
    return self.frame.size.height;
}

- (CGFloat)DGL_X {
    
    return self.frame.origin.x;
}

- (CGFloat)DGL_Y {
    
    return self.frame.origin.y;
}

- (CGFloat)DGL_CenterX {
    
    return self.center.x;
}

- (CGFloat)DGL_CenterY {
    
    return self.center.y;
}



@end
