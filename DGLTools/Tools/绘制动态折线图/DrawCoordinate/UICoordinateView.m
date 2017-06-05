//
//  DrawRectViewSingle2.m
//  OBDllDataRraw
//
//  Created by IOS on 13-9-8.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import "UICoordinateView.h"
#import "UICoordinateDataView.h"
#import "CoordinateDrawer.h"

@interface UICoordinateView ()

@property(nonatomic, strong) UICoordinateDataView *uiVwDataView;

@end


@implementation UICoordinateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.coordinateDrawer = nil;
        [self addSubview:self.uiVwDataView];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect r = self.frame;
    CGContextClearRect(context, CGRectMake(0, 0, r.size.width, r.size.height));
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor);
    CGContextAddRect(context, r);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    if ( self.coordinateDrawer ) {
        //NSLog(@"%@\n", @"draw coordinate begging");
        [self.coordinateDrawer drawAxis:context];
        [self.coordinateDrawer setDataView:self.uiVwDataView];
        //(@"%@\n", @"draw coordinate ending");
    }
    
    if ( self.uiVwDataView ) {
        [self.uiVwDataView setNeedsDisplay];
    }
}

#pragma mark - lazyloading 
- (UICoordinateDataView *)uiVwDataView {
    if (!_uiVwDataView) {
        _uiVwDataView = [[UICoordinateDataView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        [_uiVwDataView setClearsContextBeforeDrawing: YES];
        [_uiVwDataView setBackgroundColor:[UIColor clearColor]];
        _uiVwDataView.crdDrawer = self.coordinateDrawer;
        
    }
    return _uiVwDataView;
}

- (CoordinateDrawer *)coordinateDrawer {
    if (!_coordinateDrawer) {
        _coordinateDrawer = [[CoordinateDrawer alloc] init];
        _coordinateDrawer.coordinateView = self;
    }
    return _coordinateDrawer;
}

@end
