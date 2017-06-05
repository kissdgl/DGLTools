//
//  CoordinateDrawer.m
//  OBDllDataRraw
//
//  Created by IOS on 13-9-8.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import "CoordinateDrawer.h"
#import "UICoordinateView.h"

#define GET_X_VALUE(i, c) [self.crtDelegate coordinateView:COORDINATEVIEW getXValuewithIndex:(i) withDataIndex:(c)]
#define GET_Y_VALUE(i, c) [self.crtDelegate coordinateView:COORDINATEVIEW getYValuewithIndex:(i) withDataIndex:(c)]

#define COORDINATEVIEW (self.coordinateView)

@interface CoordinateDrawer()

@end

@implementation CoordinateDrawer


- (instancetype)init {
    if (self = [super init]) {
        _defualtColor.fR = 1.0;
        _defualtColor.fG = 1.0;
        _defualtColor.fB = 1.0;
        _defualtColor.fAlpha = 1.0;
        self.crtDelegate = nil;
        self.coordinateView = nil;
    }
    return self;
}

#pragma mark - x轴相关
-(CGPoint) getXAxisOrigin
{
    CGPoint origin;
    if (self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(getXAxisOriginWithCoordinateView:)]){
        origin = [self.crtDelegate getXAxisOriginWithCoordinateView:COORDINATEVIEW];
    }
    else
    {
        float fLeftMargin = INTMARGINLEFT;
        float fBottomMargin = INTMARGINBOTTOM;
        if (self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(coordinateView: getMarginWithType:)]) {
            fLeftMargin = [self.crtDelegate coordinateView:COORDINATEVIEW getMarginWithType:COORDINATE_MARGIN_LEFT];
            fBottomMargin = [self.crtDelegate coordinateView:COORDINATEVIEW getMarginWithType:COORDINATE_MARGIN_BOTTOM];
        }
        origin.y = self.coordinateView.frame.size.height - fBottomMargin;
        NSInteger c = [self getNumOfYAxis];
        origin.x = c * fLeftMargin;
    }
    return origin;
}

-(float) getXAxisLong
{
    CGPoint o = [self getXAxisOrigin];
    float fAxisLong;
    if ( self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(getXAxisLongWithCoordinateView:)]) {
        fAxisLong = [self.crtDelegate getXAxisLongWithCoordinateView:COORDINATEVIEW];
    }
    else{
        float fRightMargin = INTMARGINRIGHT;
        if (self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(coordinateView: getMarginWithType:)])
        {
            fRightMargin = [self.crtDelegate coordinateView:COORDINATEVIEW getMarginWithType:COORDINATE_MARGIN_RIGHT];
        }
        fAxisLong = self.coordinateView.frame.size.width - o.x - fRightMargin;
    }
    return fAxisLong;
}

-(UIFont*) getXAxisMarkFont
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(getXAxisMarkFontWithCoordinateView:)]) {
        return [self.crtDelegate getXAxisMarkFontWithCoordinateView:COORDINATEVIEW];
    }
    UIFont *font = [UIFont systemFontOfSize:AUTHandle(8)];
    return font;
}

-(ContextRGBSColor) getXAxisMarkColor
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(getXAxisMatkColorWithCoordinateView:)]) {
        return [self.crtDelegate getXAxisMatkColorWithCoordinateView:COORDINATEVIEW];
    }
    return  self.defualtColor;
}

-(ContextRGBSColor) getXAxisColor
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(getXAxisColorCoordinateView:)]) {
        return [self.crtDelegate getXAxisColorCoordinateView:COORDINATEVIEW];
    }
    return self.defualtColor;
}

-(NSInteger) getNumOfXAxisMark
{
    NSInteger cMarkCount = 0;
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(getXAxisNumOfMarkWithCoordinateView:)]) {
        cMarkCount = [self.crtDelegate getXAxisNumOfMarkWithCoordinateView:COORDINATEVIEW];
    }
    return cMarkCount;
}

-(BOOL)needSignCurrentData
{
    BOOL need = NO;
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(needSignCurrentDataWithCoordinateView:)] ) {
        need = [self.crtDelegate needSignCurrentDataWithCoordinateView:COORDINATEVIEW];
    }
    return  need;
}

-(CGContextRef) drawXAxisMark:(CGContextRef)ctx
{
    if ( COORDINATEVIEW ) {
        NSInteger c = [self getNumOfYAxis];
        if ( 0 == c ) {
            return ctx;
        }
        float fYLong = [self getYAxisLongWithIndex:(c - 1)];
        CGPoint xAxisOrigin, xMarkLineOrigin, xMarkLineEnd;
        xAxisOrigin = [self getXAxisOrigin];
        xMarkLineOrigin = xAxisOrigin;
        xMarkLineEnd = xMarkLineOrigin;
        xMarkLineEnd.y -= fYLong;
        
        NSInteger cMarkCount = [self getNumOfXAxisMark];
        if ( !cMarkCount ) {
            return ctx;
        }
        
        if ( !self.crtDelegate
            || ![self.crtDelegate respondsToSelector:@selector(coordinateView:getXAxisMarkValueWithmarkIndex:)]
            || ![self.crtDelegate respondsToSelector:@selector(getXAxisRangWithCoordinateView:)]
            || ![self.crtDelegate respondsToSelector:@selector(getXAxisMaxValueWithCoordinateView:)]
            )
        {
            return ctx;
        }
        
        float fXRang = [self.crtDelegate getXAxisRangWithCoordinateView:COORDINATEVIEW];
        if (fXRang < 0.0) {
            return ctx;
        }
        //float fValue = [self.crtDelegate coordinateView:COORDINATEVIEW getXAxisMarkValueWithmarkIndex:(cMarkCount-1)];
        float fValue = [self.crtDelegate coordinateView:COORDINATEVIEW getXAxisMarkValueWithmarkIndex:(0)];
        float fMax = [self.crtDelegate getXAxisMaxValueWithCoordinateView:COORDINATEVIEW];
        float fMin = fMax - fXRang;
        float fXLong = [self getXAxisLong];
        
        xMarkLineOrigin.x = xAxisOrigin.x + fXLong * (fValue - fMin) / fXRang;
        xMarkLineEnd.x = xMarkLineOrigin.x;
        ContextRGBSColor xxColor = {0.39, 0.39, 0.39, 1.0};
        [CoordinateContextTools drawLines:ctx
                                lineStyle:kCGLineCapSquare
                               lineHeight:1.0
                                lineColor:xxColor
                                starPoint:xMarkLineOrigin
                                 endPoint:xMarkLineEnd];
        //[CoordinateContextTools drawLine:ctx startPoint:xMarkLineOrigin endPoint:xMarkLineEnd lineColor:xxColor];
        
        ContextRGBSColor textColor = [self getXAxisMarkColor];
        UIFont *textFont = [self getXAxisMarkFont];
        NSString *strMark = nil;
        if ( self.crtDelegate
            && [self.crtDelegate respondsToSelector:@selector(coordinateView:getXAxisMarkStrWithmarkIndex:)]) {
            strMark = [self.crtDelegate coordinateView:COORDINATEVIEW getXAxisMarkStrWithmarkIndex:0];
        }
        else
        {
            strMark = [NSString stringWithFormat:@"%.2f", fValue];
        }
        
        CGSize sz = [strMark sizeWithAttributes:@{NSFontAttributeName : textFont}];
        CGContextSetRGBFillColor (ctx,  textColor.fR, textColor.fG, textColor.fB, textColor.fAlpha);
        [strMark drawInRect:CGRectMake(xMarkLineOrigin.x - sz.width / 2.0, xMarkLineOrigin.y + 3.0, sz.width, sz.height) withAttributes:@{NSFontAttributeName : textFont}];
        for ( int i = 1; i < cMarkCount; ++i ) {
            fValue = [self.crtDelegate coordinateView:COORDINATEVIEW getXAxisMarkValueWithmarkIndex:(i)];
            if ( (fValue < fMin) || (fValue > fMax)) {
                break;
            }
            xMarkLineOrigin.x = xAxisOrigin.x + fXLong * (fValue - fMin) / fXRang;
            xMarkLineEnd.x = xMarkLineOrigin.x;
            [CoordinateContextTools drawLines:ctx
                                    lineStyle:kCGLineCapSquare
                                   lineHeight:1.0
                                    lineColor:xxColor
                                    starPoint:xMarkLineOrigin
                                     endPoint:xMarkLineEnd];
            if ( self.crtDelegate
                && [self.crtDelegate respondsToSelector:@selector(coordinateView:getXAxisMarkStrWithmarkIndex:)]) {
                strMark = [self.crtDelegate coordinateView:COORDINATEVIEW getXAxisMarkStrWithmarkIndex:i];
            }
            else
            {
                strMark = [NSString stringWithFormat:@"%.2f", fValue];
            }
            
            sz = [strMark sizeWithAttributes:@{NSFontAttributeName : textFont}];
            CGContextSetRGBFillColor (ctx,  textColor.fR, textColor.fG, textColor.fB, textColor.fAlpha);
            CGRect rectMark =
            CGRectMake(xMarkLineOrigin.x - sz.width / 2.0, xMarkLineOrigin.y + 3.0, sz.width, sz.height);
            [strMark drawInRect:rectMark withAttributes:@{NSFontAttributeName : textFont}];
            //NSLog(@"%@ %d, rect:%f, %f, %f, %f\n", strMark, i, rectMark.origin.x, rectMark.origin.y
            //      , rectMark.size.width, rectMark.size.height);
        }
    }
    return ctx;
}

-(CGContextRef) drawCurrentDataLine:(CGContextRef)ctx
{
    if ( COORDINATEVIEW && [self needSignCurrentData] ) {
        NSInteger c = [self getNumOfDataWithTypeIndex:0];
        if ( 0 == c ) {
            return ctx;
        }
        float fYLong = [self getYAxisLongWithIndex:(c - 1)];
        CGPoint xAxisOrigin, xMarkLineOrigin, xMarkLineEnd;
        xAxisOrigin = [self getXAxisOrigin];
        xMarkLineOrigin = xAxisOrigin;
        xMarkLineEnd = xMarkLineOrigin;
        xMarkLineEnd.y -= fYLong;
        
        if ( !self.crtDelegate
            || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getXValuewithIndex: withDataIndex:)]
            || ![self.crtDelegate respondsToSelector:@selector(getXAxisRangWithCoordinateView:)]
            || ![self.crtDelegate respondsToSelector:@selector(getXAxisMaxValueWithCoordinateView:)]
            )
        {
            return ctx;
        }
        
        float fXRang = [self.crtDelegate getXAxisRangWithCoordinateView:COORDINATEVIEW];
        if (fXRang < 0.0) {
            return ctx;
        }
        float fValue = GET_X_VALUE(0, 0);
        float fMax = [self.crtDelegate getXAxisMaxValueWithCoordinateView:COORDINATEVIEW];
        float fMin = fMax - fXRang;
        float fXLong = [self getXAxisLong];
        
        xMarkLineOrigin.x = xAxisOrigin.x + fXLong * (fValue - fMin) / fXRang;
        xMarkLineEnd.x = xMarkLineOrigin.x;
        ContextRGBSColor xxColor = {0.39, 0.39, 0.39, 1.0};
        CGContextSetLineDash(ctx, 0, 0, 0);
        [CoordinateContextTools drawLine:ctx lineHeight:1.0 startPoint:xMarkLineOrigin endPoint:xMarkLineEnd lineColor:xxColor];
    }
    return ctx;
}

-(CGContextRef) drawXAxisWithContext:(CGContextRef)ctx
{
    if ( COORDINATEVIEW ) {
        CGPoint origin = [self getXAxisOrigin];        
        float fLong = [self getXAxisLong];
        CGPoint axisEnd = origin;
        axisEnd.x = axisEnd.x + fLong;
        ContextRGBSColor color = [self getXAxisColor];
        //[CoordinateContextTools drawLine:ctx startPoint:origin endPoint:axisEnd lineColor:color];
        [CoordinateContextTools drawLine:ctx lineHeight:4.0 startPoint:origin endPoint:axisEnd lineColor:color];
    }
    return ctx;
}

#pragma mark - y轴相关
-(NSInteger)getNumOfYAxis
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(getNumOfYAxisWithCoordinateView:)] ) {
        return [self.crtDelegate getNumOfYAxisWithCoordinateView:COORDINATEVIEW];
    }
    return 0;
}

-(CGPoint) getYAxisOriginWithIndex:(NSInteger)index
{
    CGPoint origin;
    if (self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisOriginWithIndex:)]) {
        origin = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisOriginWithIndex:index];
    }
    else
    {
        float fLeftMargin = INTMARGINLEFT;
        float fBottomMargin = INTMARGINBOTTOM;
        if (self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(coordinateView: getMarginWithType:)]) {
            fLeftMargin = [self.crtDelegate coordinateView:COORDINATEVIEW getMarginWithType:COORDINATE_MARGIN_LEFT];
            fBottomMargin = [self.crtDelegate coordinateView:COORDINATEVIEW getMarginWithType:COORDINATE_MARGIN_BOTTOM];
        }
        origin.y = self.coordinateView.frame.size.height - fBottomMargin;
        origin.x = (index + 1) * fLeftMargin;
    }
    return origin;
}

-(float) getYAxisLongWithIndex:(NSInteger)index
{
    CGPoint o = [self getYAxisOriginWithIndex:index];
    float fAxisLong;
    if ( self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisLongWithIndex:)]) {
        fAxisLong = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisLongWithIndex:index];
    }
    else{
        float fTopMargin = INTMARGINRIGHT;
        if (self.crtDelegate && [self.crtDelegate respondsToSelector:@selector(coordinateView: getMarginWithType:)])
        {
            fTopMargin = [self.crtDelegate coordinateView:COORDINATEVIEW getMarginWithType:COORDINATE_MARGIN_TOP];
        }
        fAxisLong = o.y - fTopMargin;
    }
    return fAxisLong;
}

-(CGContextRef) drawYAxisWithContext:(CGContextRef)ctx WithIndex:(int)index
{
    if ( COORDINATEVIEW ) {
        CGPoint origin = [self getYAxisOriginWithIndex:index];
        float fLong = [self getYAxisLongWithIndex:index];
        CGPoint axisEnd = origin;
        axisEnd.y = axisEnd.y - fLong;
        ContextRGBSColor color = self.defualtColor;
        if ( self.crtDelegate
            && [self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisColorWithIndex:)])
        {
            color = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisColorWithIndex:index];
        }
        [CoordinateContextTools drawLine:ctx lineHeight:4.0 startPoint:origin endPoint:axisEnd lineColor:color];
        
        if ( !self.crtDelegate
            || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMaxValueWithIndex:)]
            || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMinValueWithIndex:)]) {
            return ctx;
        }
        float fYMinValue = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMinValueWithIndex:index];
        float fYMaxValue = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMaxValueWithIndex:index];
        if ( fabsf(fYMaxValue - fYMinValue) < 0.000000001 ) {
            return ctx;
        }
        NSInteger c = [self getNumOfYMarkWithIndex:index];
        NSInteger c1 = [self getNumOfYAxis] - 1;
        for (int i = 0; i < c; ++i ) {
            NSString *sMark = [self getYAxisMarkStrWithIndex:index markIndex:i];
            float fValue = [self getYAxisMarkValueWithIndex:index markIndex:i];
            CGPoint markPoint;
            markPoint.x = origin.x;
            markPoint.y = origin.y - fLong * (fValue - fYMinValue) / (fYMaxValue - fYMinValue);
            if ( c1 == index && fabs(markPoint.y - origin.y)>0.001) {
                //绘制水平虚线
                float fXLong = [self getXAxisLong];
                ContextRGBSColor xxColor = {0.39, 0.39, 0.39, 1.0};
                [CoordinateContextTools drawLines:ctx
                              lineStyle:kCGLineCapSquare
                             lineHeight:1.0
                              lineColor:xxColor
                              starPoint:markPoint
                               endPoint:CGPointMake(markPoint.x + fXLong, markPoint.y)];
            }
            
            UIFont *font = [self getYAxisMarkFontWithIndex:i];
            CGSize sz = [sMark sizeWithAttributes:@{NSFontAttributeName : font}];
            markPoint.x -= sz.width + 2.0;
            markPoint.x -= 3;
            markPoint.y -= (sz.height / 2.0);
            ContextRGBSColor cl = [self getYAxisMarkColorWithIndex:index];
            CGContextSetRGBFillColor (ctx,  cl.fR, cl.fG, cl.fB, cl.fAlpha);
            
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.alignment = NSTextAlignmentRight;
            paragraph.lineBreakMode = NSLineBreakByCharWrapping;
            [sMark drawInRect:CGRectMake(markPoint.x, markPoint.y, sz.width, sz.height) withAttributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraph}];
        }
    }
    return ctx;
}

//获得y轴标注的文字字体
-(UIFont *) getYAxisMarkFontWithIndex:(NSInteger)index
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMarkFontWithIndex:)]) {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMarkFontWithIndex:index];
    }
    UIFont *font = [UIFont systemFontOfSize:AUTHandle(8)];
    return font;
}

//获得y轴标注的文字颜色
-(ContextRGBSColor) getYAxisMarkColorWithIndex:(int)index
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView:getYAxisMarkColorWithIndex:)] ) {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMarkColorWithIndex:index];
    }
    return self.defualtColor;
}

-(CGContextRef) drawYAxisWithContext:(CGContextRef)ctx
{
    if ( COORDINATEVIEW )
    {
        NSInteger c = [self getNumOfYAxis];
        
        for ( int i = 0; i < c; ++i ) {
            ctx = [self drawYAxisWithContext:ctx WithIndex:i];
        }
    }
    return ctx;
}

-(CGContextRef)drawAxis:(CGContextRef)ctx
{
    
    [self drawXAxisWithContext:ctx];
    [self drawYAxisWithContext:ctx];
    [self drawXAxisMark:ctx];
    return ctx;
}

-(NSInteger)getNumOfYMarkWithIndex:(int)index
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView: getNumOfYAxisMarkWithIndex:)])
    {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getNumOfYAxisMarkWithIndex:index];
    }
    return 0;
}

-(float)getYAxisMarkValueWithIndex:(int)index markIndex:(int)mkIndex
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMarkValueWithIndex: markIndex:)]) {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMarkValueWithIndex:index markIndex:mkIndex];
    }
    
    NSInteger c = [self getNumOfYMarkWithIndex:index];
    if( c && c > mkIndex )
    {
        if ( self.crtDelegate
            && [self.crtDelegate respondsToSelector:@selector(coordinateView:getYAxisMinValueWithIndex:)]
            && [self.crtDelegate respondsToSelector:@selector(coordinateView:getYAxisMinValueWithIndex:)]) {
            float fYMinValue = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMinValueWithIndex:index];
            float fYMaxValue = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMaxValueWithIndex:index];
            if( 0 == mkIndex )
            {
                return fYMinValue;
            }
            else if( (mkIndex + 1) == c )
            {
                return fYMaxValue;
            }
            return fYMinValue + mkIndex * (fYMaxValue - fYMinValue) / (c - 1);
        }
    }
    return 0.0;
}

-(NSInteger)getYJinduWithIndex:(int)index
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView:getYJinduWithIndex:)] ) {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getYJinduWithIndex:index];
    }
    return 2;
}

-(NSString*)getYAxisMarkStrWithIndex:(int)index markIndex:(int)mkIndex
{
    NSString *sMark = nil;
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMarkStrWithIndex: markIndex: )] ) {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMarkStrWithIndex:index markIndex:mkIndex];
    }
    float fValue = [self getYAxisMarkValueWithIndex:index markIndex:mkIndex];
    NSInteger i = [self getYJinduWithIndex:index];
    switch ( i ) {
        case 0:
            sMark = [NSString stringWithFormat:@"%d",((int)fValue)];
            break;
        case 1:
            sMark = [NSString stringWithFormat:@"%.1f",fValue];
            break;
        case 2:
            sMark = [NSString stringWithFormat:@"%.2f",fValue];
            break;
        case 3:
            sMark = [NSString stringWithFormat:@"%.3f",fValue];
            break;
        case 4:
            sMark = [NSString stringWithFormat:@"%.4f",fValue];
            break;
        case 5:
            sMark = [NSString stringWithFormat:@"%.5f",fValue];
            break;
        default:
            sMark = [NSString stringWithFormat:@"%.2f",fValue];
            break;
    }
    return sMark;
}

-(CGContextRef)drawDataView:(UIView*)dataView
        withContext:(CGContextRef)ctx
          withIndex:(int)index
{
    if ( self.crtDelegate && COORDINATEVIEW && dataView ) {
        NSInteger c = [self getNumOfDataWithTypeIndex:index];
        if ( c ) {
            if ( !self.crtDelegate
                || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMaxValueWithIndex:)]
                || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getYAxisMinValueWithIndex:)]
                || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getXValuewithIndex: withDataIndex:)]
                || ![self.crtDelegate respondsToSelector:@selector(coordinateView: getYValuewithIndex: withDataIndex:)]
                || ![self.crtDelegate respondsToSelector:@selector(getXAxisRangWithCoordinateView:)]) {
                return ctx;
            }
            double dXValue = GET_X_VALUE(index, 0);
            double dYValue = GET_Y_VALUE(index, 0);
            float fXLong = dataView.frame.size.width;
            float fYLong = dataView.frame.size.height;
            float fXMax = dXValue;
            float fXRang = [self.crtDelegate getXAxisRangWithCoordinateView:COORDINATEVIEW];
            float fYMinValue = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMinValueWithIndex:index];
            float fYMaxValue = [self.crtDelegate coordinateView:COORDINATEVIEW getYAxisMaxValueWithIndex:index];

            float fYMax = fYMaxValue;
            float fYRang = fYMaxValue - fYMinValue;
            CGPoint p;
            p.x = fXLong;
            p.y = fYLong * (fYMax - dYValue) / fYRang;
            CGPoint signPoint = p;

            NSValue *v = [NSValue valueWithCGPoint:p];
            NSMutableArray *pointAry = [NSMutableArray arrayWithCapacity:0];
            [pointAry addObject:v];
            for (int i = 1; i < c; ++i) {
                dXValue = GET_X_VALUE(index, i);
                dYValue = GET_Y_VALUE(index, i);
                p.x = fXLong - fXLong * (fXMax - dXValue) / fXRang;
                p.y = fYLong * (fYMax - dYValue) / fYRang;
                v = [NSValue valueWithCGPoint:p];
                [pointAry addObject:v];
                if ( p.x < 0.0 ) {
                    break;
                }
            }
            ContextRGBSColor color = [self getYAxisMarkColorWithIndex:index];
            if ( self.crtDelegate
                && [self.crtDelegate respondsToSelector:@selector(coordinateView:getDataLineCorlorWithIndex:)]) {
                color = [self.crtDelegate coordinateView:COORDINATEVIEW getDataLineCorlorWithIndex:index];
            }
            //[CoordinateContextTools drawLines:ctx lineColor:color pointArray:pointAry];
            [CoordinateContextTools drawLines:ctx lineHeight:3.0 lineColor:color pointArray:pointAry];
            
            if ( [self needSignCurrentData] ) {
                //CGContextAddArc(ctx, signPoint.x, signPoint.y, 5.0, M_PI+(M_PI/2), 0, 0);
                CGRect ellipseRect = CGRectMake(signPoint.x-5, signPoint.y-3, 6, 6);
                CGContextAddEllipseInRect(ctx, ellipseRect);
                CGContextSetLineWidth(ctx, 2);
                [[UIColor redColor] setStroke];
                [[UIColor redColor] setFill];
                CGContextFillEllipseInRect(ctx, ellipseRect);
                CGContextStrokeEllipseInRect(ctx, ellipseRect);
            }
        }
    }
    return ctx;
}

//获得数据种类个数
-(NSInteger) getNumOfDataType
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(getNumOfDataTypeWithCoordinateView:)]) {
        return [self.crtDelegate getNumOfDataTypeWithCoordinateView:COORDINATEVIEW];
    }
    return 0;
}

//获得指定数据种类的数据个数
-(NSInteger) getNumOfDataWithTypeIndex:(int)index
{
    if ( self.crtDelegate
        && [self.crtDelegate respondsToSelector:@selector(coordinateView: getNumOfDataWithIndex:)]) {
        return [self.crtDelegate coordinateView:COORDINATEVIEW getNumOfDataWithIndex:index];
    }
    return 0;
}

-(CGContextRef)drawDataView:(UIView*)dataView withContext:(CGContextRef)ctx
{
    if ( self.crtDelegate && COORDINATEVIEW && dataView )
    {
        NSInteger c = [self getNumOfDataType];
        for ( int i = 0; i < c; ++i ) {
            [self drawDataView:dataView withContext:ctx withIndex:i];
        }
    }
    return ctx;
}

-(void)setDataView:(UIView*)dataView
{
    CGPoint origin = [self getXAxisOrigin];
    float fXLong = [self getXAxisLong];
    float fYLong = [self getYAxisLongWithIndex:0];
    dataView.frame = CGRectMake(origin.x, origin.y - fYLong, fXLong, fYLong);
}
@end
