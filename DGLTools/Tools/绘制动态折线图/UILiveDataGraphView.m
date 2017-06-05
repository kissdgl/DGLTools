//
//  UILiveDataGraphView.m
//  OBDll_Whole_UI
//
//  Created by IOS on 13-10-15.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import "UILiveDataGraphView.h"

#import "AUTDataStreamModel.h"

@interface UILiveDataGraphView()

//用于标识是否需要检测各数据的时间值是否在起始时间之后
@property (nonatomic, assign)BOOL bNeedCheckTime;
//Y轴最大值
@property (nonatomic, assign) float fYMaxValue;
//Y轴最小值
@property (nonatomic, assign) float fYMinValue;

//精度
@property (nonatomic, assign) NSInteger iJingdu;

//Y轴起始点的x
@property (nonatomic, assign)float fYAxis_x;

@end


@implementation UILiveDataGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bNeedCheckTime = YES;
        self.dataArr = nil;
        self.iJingdu = 0;
    
        self.coordinateDrawer.crtDelegate = self;
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    [self resetWithDataDic];
    
    [super drawRect:rect];
}

-(void)resetWithDataDic
{
    float fGetMax, fGetMin;
    
    if ( self.model) {

        fGetMax = self.model.upperValue;
        fGetMin = self.model.lowerValue;
        
        self.fYMaxValue = fGetMax;
        self.fYMinValue = fGetMin;
        
        self.dataArr = self.model.dataArr;
        
        NSString *lastDataYValue = @" ";
        if (self.dataArr && self.dataArr.count ) {
            lastDataYValue = (NSString *)[[self.dataArr objectAtIndex:0] objectForKey:@"y"];
        }
        
        NSRange rangeb = [lastDataYValue rangeOfString:@"."];
        NSInteger jinduTemp = 0;
        if (rangeb.location != NSNotFound) {
            jinduTemp = [lastDataYValue length] - rangeb.location - 1;
        }else{
            jinduTemp = 0;
        }
        self.iJingdu = (jinduTemp > self.iJingdu ? jinduTemp : self.iJingdu);
        
        
//        float y = [lastDataYValue doubleValue];
//        if ( y > self.fYMaxValue ) {
//            self.fYMaxValue = y;
//        }
//        if ( y < self.fYMinValue ) {
//            self.fYMinValue = y;
//        }
        
    }
    
}

+ (NSString *)getTimerWithInt:(unsigned long)num{
    unsigned long min = num / 60;
    unsigned long sec = num % 60;
    NSString *time = [NSString stringWithFormat:@"%.2d:%.2d",(int)min,(int)sec];
    return time;
}

#pragma mark - CoordinateDrawDelegate
-(BOOL)needSignCurrentDataWithCoordinateView:(UICoordinateView *)cdtView
{
    return NO;
}

-(float) coordinateView:(UICoordinateView*)cdtView getMarginWithType:(CoordinateMarginType)marginType
{
    switch ( marginType ) {
        case COORDINATE_MARGIN_LEFT:
        {
            float fMarginLeft = 43;
            float fMax = [self coordinateView:cdtView getYAxisMaxValueWithIndex:0];
            float fMin = [self coordinateView:cdtView getYAxisMinValueWithIndex:0];
            NSString *sMax = nil;
            NSString *sMin = nil;
            switch ( [self coordinateView:cdtView getYJinduWithIndex:0] ) {
                case 0:
                    sMax = [NSString stringWithFormat:@"%d",(int)fMax];
                    sMin = [NSString stringWithFormat:@"%d",(int)fMin];
                    break;
                case 1:
                    sMax = [NSString stringWithFormat:@"%.1f",fMax];
                    sMin = [NSString stringWithFormat:@"%.1f",fMin];
                    break;
                case 2:
                    sMax = [NSString stringWithFormat:@"%.2f",fMax];
                    sMin = [NSString stringWithFormat:@"%.2f",fMin];
                    break;
                case 3:
                    sMax = [NSString stringWithFormat:@"%.3f",fMax];
                    sMin = [NSString stringWithFormat:@"%.3f",fMin];
                    break;
                case 4:
                    sMax = [NSString stringWithFormat:@"%.4f",fMax];
                    sMin = [NSString stringWithFormat:@"%.4f",fMin];
                    break;
                case 5:
                    sMax = [NSString stringWithFormat:@"%.5f",fMax];
                    sMin = [NSString stringWithFormat:@"%.5f",fMin];
                    break;
                default:
                    sMax = [NSString stringWithFormat:@"%.2f",fMax];
                    sMin = [NSString stringWithFormat:@"%.2f",fMin];
                    break;
            }
            CGSize szMax = [sMax sizeWithAttributes:@{NSFontAttributeName : [self coordinateView:cdtView getYAxisMarkFontWithIndex:0]}];
            CGSize szMin = [sMin sizeWithAttributes:@{NSFontAttributeName : [self coordinateView:cdtView getYAxisMarkFontWithIndex:0]}];
            fMarginLeft = fmaxf(fmaxf(szMax.width, szMin.width) + 13, fMarginLeft);
        
            //设置Y轴起始点的x
            self.fYAxis_x = fMarginLeft;
            
            return fMarginLeft;//77;
        }
        case COORDINATE_MARGIN_BOTTOM:
            return 24;
        case COORDINATE_MARGIN_RIGHT:
            return 27;
        case COORDINATE_MARGIN_TOP:
            return 10;
        default:
            return 0;
    }
}

//获取y轴最大值
-(float) coordinateView:(UICoordinateView*)cdtView getYAxisMaxValueWithIndex:(int)index
{
    return self.fYMaxValue;
    //return 2;
}

//获取y轴最小值
-(float) coordinateView:(UICoordinateView *)cdtView getYAxisMinValueWithIndex:(int)index
{
    return self.fYMinValue;
}

//获取y轴个数
-(NSInteger) getNumOfYAxisWithCoordinateView:(UICoordinateView*)cdtView
{
    return 1;
}

//获取y轴标注个数
-(NSInteger) coordinateView:(UICoordinateView*)cdtView getNumOfYAxisMarkWithIndex:(int)index
{
    return 5;
}

//获取y的精度
-(NSInteger) coordinateView:(UICoordinateView*)cdtView getYJinduWithIndex:(int)index
{

    return self.iJingdu;
}

//获得y轴标注的文字字体
-(UIFont *) coordinateView:(UICoordinateView*)cdtView getYAxisMarkFontWithIndex:(NSInteger)index
{
    return [UIFont systemFontOfSize:AUTHandle(14)];
}

//获取y轴颜色
-(ContextRGBSColor) coordinateView:(UICoordinateView*)cdtView getYAxisColorWithIndex:(int)index
{
    ContextRGBSColor c;
    if ( !index ) {
        c.fR = 21.0 / 255.0;
        c.fG = 125.0 / 255.0;
        c.fB = 253.0 / 255.0;
        c.fAlpha = 1.0;
    }
    else
    {
        c.fR = 192.0 / 255.0;
        c.fG = 128.0 / 255.0;
        c.fB = 255.0 / 255.0;
        c.fAlpha = 1.0;
    }
    return c;
}

//获得y轴标注的文字颜色,下标index从0开始，0对应最左边的y轴
-(ContextRGBSColor) coordinateView:(UICoordinateView*)cdtView getYAxisMarkColorWithIndex:(int)index
{
    ContextRGBSColor c;
    if ( !index ) {
        c.fR = 21.0 / 255.0;
        c.fG = 125.0 / 255.0;
        c.fB = 253.0 / 255.0;
        c.fAlpha = 1.0;
    }
    else
    {
        c.fR = 192.0 / 255.0;
        c.fG = 128.0 / 255.0;
        c.fB = 255.0 / 255.0;
        c.fAlpha = 1.0;
    }
    return c;
}

//获取y轴起始点
-(CGPoint) coordinateView:(UICoordinateView*)cdtView getYAxisOriginWithIndex:(NSInteger)index
{
    [self coordinateView:cdtView getMarginWithType:COORDINATE_MARGIN_LEFT];
    
    float y = [self coordinateView:cdtView getMarginWithType:COORDINATE_MARGIN_BOTTOM];
    y = self.frame.size.height - y;
    
    return CGPointMake(self.fYAxis_x, y);
}

//获取x轴最大值
-(float) getXAxisMaxValueWithCoordinateView:(UICoordinateView*)cdtView
{
    if ( self.dataArr && self.dataArr.count) {
        return [self coordinateView:cdtView getXValuewithIndex:0 withDataIndex:0];
    }
    return [self getXAxisRangWithCoordinateView:cdtView];
}

//获取标注对应的x轴的值
-(float) coordinateView:(UICoordinateView*)cdtView getXAxisMarkValueWithmarkIndex:(int)mkIndex
{
    if ( self.dataArr ) {
        double dXValue = [self coordinateView:cdtView getXValuewithIndex:0 withDataIndex:0];
        float f = [self getXAxisRangWithCoordinateView:cdtView];
        float bStart = dXValue - f;
        bStart = ((bStart > 0.0) ? bStart : 0.0);
        bStart = floorf(bStart / 5) * 5;
        NSInteger n = [self getXAxisNumOfMarkWithCoordinateView:cdtView];
        return (bStart + (n - 1 - mkIndex) * 5.0);
    }
    return 0;
}

//获取x轴标注文字,下标mkIndex从0开始,0下标对应x轴最后一个标注
-(NSString *) coordinateView:(UICoordinateView*)cdtView getXAxisMarkStrWithmarkIndex:(int)mkIndex
{
    if ( self.dataArr ) {
        double dXValue = [self coordinateView:cdtView getXValuewithIndex:0 withDataIndex:0];
        float f = [self getXAxisRangWithCoordinateView:cdtView];
        float bStart = dXValue - f;
        bStart = ((bStart > 0.0) ? bStart : 0.0);
        bStart = floorf(bStart / 5) * 5;
        NSInteger n = [self getXAxisNumOfMarkWithCoordinateView:cdtView];
        int i = (bStart + (n - 1 - mkIndex) * 5.0);
        NSString *strMark = [[self class] getTimerWithInt:i];
        return strMark;
    }
    return @" ";
}

//获取x轴标注个数
-(NSInteger) getXAxisNumOfMarkWithCoordinateView:(UICoordinateView*)cdtView
{
    if ( self.dataArr ) {
        double dXValue = [self coordinateView:cdtView getXValuewithIndex:0 withDataIndex:0];

        if ( dXValue < 0 ) {
            return 0;
        }
        int i = ceil(dXValue/5.0);
        
        int maxnum = 5;
        return (i > maxnum ? maxnum : i);
    }
    return 0;
}

//获取x轴的量程
-(float) getXAxisRangWithCoordinateView:(UICoordinateView*)cdtView
{
//    if ( self.frame.size.width < 330.0 ) {
//        return [self getXAxisLongWithInterfaceOrientation:UIInterfaceOrientationPortrait];
//    }
//    return 35.0;
    
    return 20;
}

//x轴起点坐标
-(CGPoint) getXAxisOriginWithCoordinateView:(UICoordinateView*)cdtView
{
    return [self coordinateView:cdtView getYAxisOriginWithIndex:0];
}

//获取x轴颜色
-(ContextRGBSColor) getXAxisColorCoordinateView:(UICoordinateView*)cdtView
{
    ContextRGBSColor c;
    c.fR = 83.0 / 255.0;
    c.fG = 83.0 / 255.0;
    c.fB = 83.0 / 255.0;
    c.fAlpha = 1.0;
    return c;
}

//获取x轴标注文字颜色
-(ContextRGBSColor) getXAxisMatkColorWithCoordinateView:(UICoordinateView*)cdtView
{
    ContextRGBSColor c;
    c.fR = 42.0 / 255.0;
    c.fG = 42.0 / 255.0;
    c.fB = 42.0 / 255.0;
    c.fAlpha = 1.0;
    return c;
}

//获取x轴标注文字字体
-(UIFont *) getXAxisMarkFontWithCoordinateView:(UICoordinateView*)cdtView
{
    return [UIFont systemFontOfSize:AUTHandle(14)];
}

#pragma mark - 数据相关
//获取数据个数
-(NSInteger) coordinateView:(UICoordinateView *)cdtView getNumOfDataWithIndex:(int)index
{
    if (self.dataArr.count > 1 ) {
        if ( self.bNeedCheckTime ) {
            //不绘制时间起点之前的数据
            int i;
            double d1 = [self coordinateView:cdtView getXValuewithIndex:index withDataIndex:0];
            double d2 = d1;
            double d;
            if ( d1 > 0 ) {
                for ( i = 1; i < self.dataArr.count; ++i )
                {
                    d = [self coordinateView:cdtView getXValuewithIndex:index withDataIndex:i];
                    if ( d < 0 )
                    {
                        break;
                    }
                    d2 = d;
                }
            }
            else
            {
                return 0;   //d1小于0说明所有数据都在时间起点以前
            }
            if ( fabs( d1 - d2 ) > [self getXAxisRangWithCoordinateView:self] ) {
                //如果在时间起点之后的数据点已经暂满整个x轴,那么就不需要再检测了
                self.bNeedCheckTime = NO;
            }
            return i;
        }
        return self.dataArr.count;
    }
    return self.dataArr.count;
}

//获得数据种类个数
-(NSInteger) getNumOfDataTypeWithCoordinateView:(UICoordinateView*)cdtView
{
    return 1;
}

//获取数据线颜色
-(ContextRGBSColor) coordinateView:(UICoordinateView*)cdtView getDataLineCorlorWithIndex:(int)index
{
    ContextRGBSColor c;
    if ( !index ) {
        c.fR = 21.0 / 255.0;
        c.fG = 125.0 / 255.0;
        c.fB = 253.0 / 255.0;
        c.fAlpha = 1.0;
    }
    else
    {
        c.fR = 192.0 / 255.0;
        c.fG = 128.0 / 255.0;
        c.fB = 255.0 / 255.0;
        c.fAlpha = 1.0;
    }

    return c;
}

//获得指定数据的x值
-(double) coordinateView:(UICoordinateView*)cdtView
      getXValuewithIndex:(int)index
           withDataIndex:(int)dataIndex
{
    if ( 0 == index && self.dataArr.count ) {
        CGPoint p = [self readPointValue:self.dataArr andOrder:dataIndex];
        return p.x;
    }
    return 0.0;
}

//获得指定数据的y值
-(double) coordinateView:(UICoordinateView *)cdtView
      getYValuewithIndex:(int)index
           withDataIndex:(int)dataIndex
{
    if ( 0 == index && self.dataArr && self.dataArr.count > dataIndex ) {
        return [[[self.dataArr objectAtIndex:dataIndex] valueForKey:@"y"] doubleValue];
    }
    NSLog(@"UILiveDataGraphView getYValuewithIndex: [self.dataArr count] =< dataIndex\n");
    return 0.0;
}

- (CGPoint)readPointValue:(NSArray *)pointArr andOrder:(int)order{
    double x = 0.0;
    double y = 0.0;
    if ( pointArr && pointArr.count > order ) {
        NSDictionary *pointDic = [pointArr objectAtIndex:order];
        x = [[pointDic valueForKey:@"x"] doubleValue];
        x = x - self.fBeginTime;
        y = [[pointDic valueForKey:@"y"] doubleValue];
    }
    else
    {
        NSLog(@"UILiveDataGraphView readPointValue: [pointArr count] =< order\n");
    }

    CGPoint point = CGPointMake(x, y);
    return point;
}
@end
