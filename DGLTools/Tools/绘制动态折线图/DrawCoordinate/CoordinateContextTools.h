//
//  ContextTools.h
//  test02
//
//  Created by apple on 13-4-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef struct{
    float fR;
    float fG;
    float fB;
    float fAlpha;
}ContextRGBSColor;

@interface CoordinateContextTools : NSObject

+ (CGContextRef)drawRectLine:(CGContextRef)context rect:(CGRect)rect;

+(CGContextRef)drawLines:(CGContextRef)context
               lineColor:(ContextRGBSColor)color
              pointArray:(NSArray *)ary;

+(CGContextRef)drawLines:(CGContextRef)context
              lineHeight:(float)lineHeight
               lineColor:(ContextRGBSColor)color
              pointArray:(NSArray *)ary;

+ (CGContextRef)drawLines:(CGContextRef)context 
                lineStyle:(CGLineCap)lineStyle
               lineHeight:(float)lineHeight
                lineColor:(ContextRGBSColor)color
                starPoint:(CGPoint)pointStart
                 endPoint:(CGPoint)pointEnd;

+(CGContextRef)drawLine:(CGContextRef)context
             startPoint:(CGPoint)sp
               endPoint:(CGPoint)ep
              lineColor:(ContextRGBSColor)color;

+(CGContextRef)drawLine:(CGContextRef)context
             lineHeight:(float)lineHeight
             startPoint:(CGPoint)sp
               endPoint:(CGPoint)ep
              lineColor:(ContextRGBSColor)color;
@end
