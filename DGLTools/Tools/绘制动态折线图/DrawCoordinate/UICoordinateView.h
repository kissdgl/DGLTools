//
//  UICoordinateView.h
//  OBDllDataRraw
//  显示曲线图
//  Created by IOS on 13-9-8.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoordinateDrawer;

@interface UICoordinateView : UIView

@property(nonatomic, strong) CoordinateDrawer *coordinateDrawer;

@end
