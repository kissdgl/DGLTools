//
//  UIImage+Render.m
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)

+ (UIImage *)imageNameWithOriginal:(UIImage *)image {
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

@end
