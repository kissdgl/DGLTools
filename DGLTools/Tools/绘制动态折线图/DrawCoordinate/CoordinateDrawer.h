//
//  CoordinateDrawer.h
//  OBDllDataRraw
//
//  Created by IOS on 13-9-8.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateContextTools.h"

#define INTMARGIN 30        //边距 （左边和下边
#define INTMARGINTOP   20
#define INTMARGINRIGHT 20   // 上 右 边距  //考虑将时间倍数等按钮放在右边，根据最终需要确定是否舍去
#define INTMARGINBOTTOM 30
#define INTMARGINLEFT  30

@class UICoordinateView;

typedef enum{
    COORDINATE_MARGIN_LEFT = 0,
    COORDINATE_MARGIN_BOTTOM,
    COORDINATE_MARGIN_RIGHT,
    COORDINATE_MARGIN_TOP
}CoordinateMarginType;

//绘制代理
#pragma mark - 绘制代理
@protocol CoordinateDrawDelegate <NSObject>

@optional
//获取各方向的边距
-(float) coordinateView:(UICoordinateView*)cdtView getMarginWithType:(CoordinateMarginType)marginType;

#pragma mark - 绘制代理 : y轴相关
//获取y轴个数
-(NSInteger) getNumOfYAxisWithCoordinateView:(UICoordinateView*)cdtView;
//获取y轴起始点
-(CGPoint) coordinateView:(UICoordinateView*)cdtView getYAxisOriginWithIndex:(NSInteger)index;
//获取y轴长度
-(float) coordinateView:(UICoordinateView*)cdtView getYAxisLongWithIndex:(NSInteger)index;
//获取y轴颜色
-(ContextRGBSColor) coordinateView:(UICoordinateView*)cdtView getYAxisColorWithIndex:(int)index;

#pragma mark - 绘制代理 : y轴标注相关
//获取y轴标注个数
-(NSInteger) coordinateView:(UICoordinateView*)cdtView getNumOfYAxisMarkWithIndex:(int)index;
//获得y轴标注的文字字体
-(UIFont *) coordinateView:(UICoordinateView*)cdtView getYAxisMarkFontWithIndex:(NSInteger)index;
//获得y轴标注的文字颜色,下标index从0开始，0对应最左边的y轴
-(ContextRGBSColor) coordinateView:(UICoordinateView*)cdtView getYAxisMarkColorWithIndex:(int)index;
//获取y轴标注文字,下标index从0开始，0对应最左边的y轴
-(NSString*) coordinateView:(UICoordinateView*)cdtView getYAxisMarkStrWithIndex:(int)index markIndex:(int)mkIndex;
//获取标注对应的y轴的值,下标index从0开始，0对应最左边的y轴
-(float) coordinateView:(UICoordinateView*)cdtView getYAxisMarkValueWithIndex:(int)index markIndex:(int)mkIndex;
//获取y的精度
-(NSInteger) coordinateView:(UICoordinateView*)cdtView getYJinduWithIndex:(int)index;

#pragma mark - 绘制代理 : x轴相关
//获取x轴起始(屏幕坐标)
-(CGPoint) getXAxisOriginWithCoordinateView:(UICoordinateView*)cdtView;
//获取x轴长度
-(float) getXAxisLongWithCoordinateView:(UICoordinateView*)cdtView;
//获取x轴颜色
-(ContextRGBSColor) getXAxisColorCoordinateView:(UICoordinateView*)cdtView;

#pragma mark - 绘制代理 : x轴标注相关
//获取x轴标注文字字体
-(UIFont *) getXAxisMarkFontWithCoordinateView:(UICoordinateView*)cdtView;
//获取x轴标注文字颜色
-(ContextRGBSColor) getXAxisMatkColorWithCoordinateView:(UICoordinateView*)cdtView;
//获取x轴标注个数
-(NSInteger) getXAxisNumOfMarkWithCoordinateView:(UICoordinateView*)cdtView;
//获取x轴标注文字,下标mkIndex从0开始,0下标对应x轴最后一个标注
-(NSString*) coordinateView:(UICoordinateView*)cdtView getXAxisMarkStrWithmarkIndex:(int)mkIndex;
//获取标注对应的x轴的值,下标mkIndex从0开始,0下标对应x轴最后一个标注
-(float) coordinateView:(UICoordinateView*)cdtView getXAxisMarkValueWithmarkIndex:(int)mkIndex;
//获取数据线颜色
-(ContextRGBSColor) coordinateView:(UICoordinateView*)cdtView getDataLineCorlorWithIndex:(int)index;
//是否绘制最后一个值的标识线
-(BOOL) needSignCurrentDataWithCoordinateView:(UICoordinateView*)cdtView;

#pragma mark - 必须实现的接口
@required
//获取y轴最大值,下标index从0开始,0对应最左边的y轴
-(float) coordinateView:(UICoordinateView*)cdtView getYAxisMaxValueWithIndex:(int)index;
//获取y轴最小值,下标index从0开始,0对应最左边的y轴
-(float) coordinateView:(UICoordinateView *)cdtView getYAxisMinValueWithIndex:(int)index;
//获取x轴最大值
-(float) getXAxisMaxValueWithCoordinateView:(UICoordinateView*)cdtView;
//获取x轴的量程
-(float) getXAxisRangWithCoordinateView:(UICoordinateView*)cdtView;
#pragma mark - 数据相关
//获取数据个数,下标index从0开始,0下标对应最后一个坐标点
-(NSInteger) coordinateView:(UICoordinateView *)cdtView getNumOfDataWithIndex:(int)index;
//获得数据种类个数
-(NSInteger) getNumOfDataTypeWithCoordinateView:(UICoordinateView*)cdtView;
//获得指定数据的x值,下标dataIndex从0开始，0下标对应最后一个坐标点
-(double) coordinateView:(UICoordinateView*)cdtView
        getXValuewithIndex:(int)index
        withDataIndex:(int)dataIndex;
//获得指定数据的y值,下标dataIndex从0开始，0下标对应最后一个坐标点
-(double) coordinateView:(UICoordinateView *)cdtView
        getYValuewithIndex:(int)index
           withDataIndex:(int)dataIndex;
@end

@interface CoordinateDrawer : NSObject

@property (nonatomic, assign) ContextRGBSColor defualtColor;
@property(nonatomic, strong) UICoordinateView *coordinateView;
@property(nonatomic, weak) id<CoordinateDrawDelegate> crtDelegate;

-(NSInteger)getNumOfYAxis;
-(CGContextRef)drawAxis:(CGContextRef)ctx;
-(CGContextRef)drawDataView:(UIView*)dataView withContext:(CGContextRef)ctx;
-(void)setDataView:(UIView*)dataView;

@end
