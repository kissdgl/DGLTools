//
//  UILiveDataGraphView.h
//  OBDll_Whole_UI
//
//  Created by IOS on 13-10-15.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinateDrawer.h"
#import "UICoordinateView.h"

@class AUTDataStreamModel;

@interface UILiveDataGraphView : UICoordinateView<CoordinateDrawDelegate>

@property (nonatomic, assign) double fBeginTime;

@property (nonatomic, strong) NSArray *dataArr;

//@property (nonatomic, assign, setter = setInterfaceOrientation:) UIInterfaceOrientation infcOrientation;

//模型 用于更新数据
@property (nonatomic, strong) AUTDataStreamModel *model;

//-(void)resetWithDataDic;
//-(float)getXAxisLongWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
//- (CGPoint)readPointValue:(NSArray *)pointArr andOrder:(int)order;
//+ (NSString *)getTimerWithInt:(unsigned long)num;


@end
