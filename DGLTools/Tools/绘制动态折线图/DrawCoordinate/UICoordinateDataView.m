//
//  UICoordinateDataView.m
//  OBDllDataRraw
//
//  Created by IOS on 13-9-8.
//  Copyright (c) 2013年 IOS. All rights reserved.
//

#import "UICoordinateDataView.h"
#import "CoordinateDrawer.h"

@implementation UICoordinateDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.crdDrawer = nil;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"%@\n", @"draw data begging");
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect r = self.frame;
    CGContextClearRect(context, CGRectMake(0, 0, r.size.width, r.size.height));
    if ( self.crdDrawer ) {
        [self.crdDrawer drawDataView:self withContext:context];
    }
    //NSLog(@"%@\n\n", @"draw data ending");
}


@end
