//
//  ContextTools.m
//  test02
//
//  Created by apple on 13-4-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CoordinateContextTools.h"

@implementation CoordinateContextTools

+(CGContextRef)drawRectLine:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.4);//线条颜色
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    return context;
}

+(CGContextRef)drawLines:(CGContextRef)context lineColor:(ContextRGBSColor)color pointArray:(NSArray *)ary
{
    CGContextSetLineCap(context, kCGLineCapRound);         //线条风格
    CGContextSetRGBStrokeColor(context, color.fR, color.fG, color.fB, color.fAlpha);    //线条颜色
    CGContextBeginPath(context);
    //设置下一个坐标点
    if (ary.count>0) {
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        //初始坐标，读取第一条数据。
               
        for (int i=0; i< ary.count; i++) {
            NSValue *value = [ary objectAtIndex:i];
            CGPoint point = [value CGPointValue];
            if(i==0)
            {
                CGContextMoveToPoint(context, point.x, point.y);
            }else {
                
                CGContextAddLineToPoint(context, point.x, point.y);

            }
            
        }
    }
    
    CGContextStrokePath(context);
    
    return context;
}

//根据三点计算出曲线的控制点
+ (CGPoint)controlPointWithCurrentPoint:(CGPoint)curPoint prePoint:(CGPoint)prePoint pre2Point:(CGPoint)pre2Point {
    
    CGPoint ctrPoint = CGPointMake((curPoint.x + prePoint.x) * 0.5, (curPoint.y + prePoint.y) * 0.5);
    
    if (prePoint.y >= pre2Point.y) {
        
        ctrPoint.y -= 5;
        
    } else {
        ctrPoint.y += 5;
    }
    
    return ctrPoint;
}

+(CGContextRef)drawLines:(CGContextRef)context
              lineHeight:(float)lineHeight
               lineColor:(ContextRGBSColor)color
              pointArray:(NSArray *)ary
{
    CGContextSetLineWidth(context, lineHeight);
    [[self class] drawLines:context lineColor:color pointArray:ary];
    return context;
}


//最原始的绘制方法
+ (CGContextRef)drawLines:(CGContextRef)context lineStyle:(CGLineCap)lineStyle lineHeight:(float)lineHeight lineColor:(ContextRGBSColor)color starPoint:(CGPoint)pointStart endPoint:(CGPoint)pointEnd
{
    //画虚线,设置长度
    CGFloat lengths[] = {2, 1};
    CGContextSetLineDash(context, 0, lengths, 1);
    
    //设置线条样式
    CGContextSetLineCap(context, lineStyle);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, lineHeight);
    //设置颜色
    CGContextSetRGBStrokeColor(context, color.fR, color.fG, color.fB
                               , color.fAlpha);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    //初始坐标
    CGContextMoveToPoint(context, pointStart.x, pointStart.y);
    CGContextAddLineToPoint(context, pointEnd.x, pointEnd.y);
    
    //连接上面定义的坐标点
    CGContextStrokePath(context);
    return context;
}

+(CGContextRef)drawLine:(CGContextRef)context
             startPoint:(CGPoint)sp
               endPoint:(CGPoint)ep
              lineColor:(ContextRGBSColor)color
{
    CGContextSetLineCap(context, kCGLineCapSquare);         //线条风格
    CGContextSetRGBStrokeColor(context, color.fR, color.fG, color.fB, color.fAlpha);    //线条颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, sp.x, sp.y);
    CGContextAddLineToPoint(context, ep.x, ep.y);
    CGContextStrokePath(context);    
    return context;
}

+(CGContextRef)drawLine:(CGContextRef)context
             lineHeight:(float)lineHeight
             startPoint:(CGPoint)sp
               endPoint:(CGPoint)ep
              lineColor:(ContextRGBSColor)color
{
    //设置线条粗细宽度
    CGContextSetLineWidth(context, lineHeight);
    [[self class] drawLine:context startPoint:sp endPoint:ep lineColor:color];
    
    return context;
}

@end
