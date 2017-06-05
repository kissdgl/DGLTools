//
//  DGLPDFDrawer.m
//  DGLPDFDemo
//
//  Created by Autel_Ling on 2017/3/29.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import "DGLPDFDrawer.h"

#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

#define PDF_Width 612.0
#define PDF_Height 792.0
//#define PDF_ContentMargin 72.0
#define PDF_ContentMarginX 36.0
#define PDF_ContentMarginY 72.0
#define PDF_LineMarginTB 60.0
#define PDF_LineMarginLR 36.0

const CGFloat tableOriginY = 200;
const CGFloat rowHeight = 38;


@interface DGLPDFDrawer ()

@property (nonatomic, copy) NSString *filePath;

//内容
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *modelsDict;
@property (nonatomic, strong) AUTVehicleModel *vehicleModel;

//第一页内容的长度
@property (nonatomic, assign) CGFloat firstPageContentHeight;

@end

@implementation DGLPDFDrawer

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
    }
    return self;
}

+ (instancetype)PDFDrawerWittFilePath:(NSString *)filePath {
    
    DGLPDFDrawer *drawer = [[DGLPDFDrawer alloc] initWithFilePath:filePath];
    return drawer;
}

- (void)startDrawPDF {
    
    //计算出第一页内容的长度
    self.firstPageContentHeight = PDF_Height - PDF_ContentMarginY -tableOriginY - rowHeight * (self.keys.count + 1);
    
    NSAttributedString *content = [self generateContents];
    
    [self creatPDFFileWithString:content];

}


- (NSAttributedString *)generateContents {
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    //添加 codes
    
    for (int i = 0; i < self.keys.count; i ++) {
        
        NSString *key = [self.keys objectAtIndex:i];
        
        NSArray *arr = [self.modelsDict objectForKey:key];
        
        if (arr.count) {

            [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
            
            [arr enumerateObjectsUsingBlock:^(AUTTroubleCodeModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                if (idx == 0) {
                    
                    NSString *tmpStr = [NSString stringWithFormat:@"%d.%@ ———— %ld\n\n",(i+1),obj.systemName, arr.count];
                    
                    NSDictionary *tmpAttribute = @{NSForegroundColorAttributeName : [UIColor redColor],
                                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:16]};
                    
                    NSAttributedString * tmpAttributedStr = [[NSAttributedString alloc] initWithString:tmpStr attributes:tmpAttribute];
                    
                    [content appendAttributedString:tmpAttributedStr];

                }
                
                
                NSString *tmpStr = [NSString stringWithFormat:@"%ld. %@           ", idx+1, obj.pid];
                
                NSDictionary *tmpAttribute = @{NSForegroundColorAttributeName : [UIColor blackColor]};
                
                NSAttributedString * tmpAttributedStr = [[NSAttributedString alloc] initWithString:tmpStr attributes:tmpAttribute];
                
                [content appendAttributedString:tmpAttributedStr];
                
                
                
                tmpStr = [NSString stringWithFormat:@"%@\n\n", obj.name];
                
                tmpAttribute = @{NSForegroundColorAttributeName : [UIColor blackColor]};
                
                tmpAttributedStr = [[NSAttributedString alloc] initWithString:tmpStr attributes:tmpAttribute];
                
                [content appendAttributedString:tmpAttributedStr];
                
            }];
        }
    }
    
    return content.copy;
}

- (void)addContentWithModelsDict:(NSDictionary *)dict keys:(NSArray *)keys vehicleModel:(AUTVehicleModel *)vehicleModel{
    
    self.keys = keys;
    self.modelsDict = dict;
    self.vehicleModel = vehicleModel;
}

//根据string内容创建pdf文档
- (void)creatPDFFileWithString:(NSAttributedString *)content {
    
    CFAttributedStringRef currentText = CFAttributedStringCreateCopy(NULL, (CFAttributedStringRef)content);
    
    if (currentText) {
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {

            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(self.filePath, CGRectZero, nil);
            
            CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            
            do {
                
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, PDF_Width, PDF_Height), nil);
                
                // Draw a page number at the bottom of each page.
                currentPage++;
                [self drawPageNumber:currentPage];
                
                //Draw Top Content
                [self drawTopContent];
                //Draw Bottom Content
                [self drawBottomContent];
                
                //若为第一页 绘制表格和初始内容
                if (currentPage == 1) {
                    
                    [self drawVehicleInfo];
                    [self drawTables];
                }
                
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                currentRange = [self renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter];
                
                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText))
                    done = YES;
                
            } while (!done);

            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
            
            // Release the framewetter.
            CFRelease(framesetter);
            
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
        // Release the attributed string.
        CFRelease(currentText);
    } else {
        NSLog(@"Could not create the attributed string for the framesetter");
    }
}


- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter
{
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text. Use 72 point
    // margins all around the text.
    CGRect frameRect;
    if (pageNum == 1) {
        frameRect = CGRectMake(PDF_ContentMarginX, PDF_ContentMarginY, PDF_Width - 2 * PDF_ContentMarginX, self.firstPageContentHeight);

    } else {
        frameRect = CGRectMake(PDF_ContentMarginX, PDF_ContentMarginY, PDF_Width - 2 * PDF_ContentMarginX, PDF_Height - 2 * PDF_ContentMarginY);
    }
    
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    // The currentRange variable specifies only the starting point. The framesetter
    // lays out as much text as will fit into the frame.
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, PDF_Height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Update the current range based on what was drawn.
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    
    return currentRange;
}


- (void)drawPageNumber:(NSInteger)pageNum
{
    
    NSString *pageString = [NSString stringWithFormat:@"Page %ld", pageNum];
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(PDF_Width, 72);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    NSDictionary *attributes = @{NSFontAttributeName:theFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize pageStringSize = [pageString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil].size;
    
    CGRect stringRect = CGRectMake(((PDF_Width - pageStringSize.width) - PDF_LineMarginLR),
                                   PDF_Height - PDF_ContentMarginY + ((PDF_ContentMarginY - pageStringSize.height) / 2.0),
                                   pageStringSize.width,
                                   pageStringSize.height);
    
//    [pageString drawInRect:stringRect withAttributes:attributes];
    [pageString drawInRect:stringRect withAttributes:attributes];
}


- (void)drawTopContent {
    
    //address
    NSString *address = @"www.autel.com";
    UIFont *theFont = [UIFont boldSystemFontOfSize:16];
    CGSize maxSize = CGSizeMake(PDF_Width, 72);
    NSDictionary *attributes = @{NSFontAttributeName:theFont};

    CGSize addressStringSize = [address boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil].size;
    
    CGRect stringRect = CGRectMake(PDF_LineMarginLR,
                                   ((PDF_ContentMarginY - addressStringSize.height) / 2.0),
                                   addressStringSize.width,
                                   addressStringSize.height);
    
    [address drawInRect:stringRect withAttributes:attributes];
    
    //设置点击连接
    UIGraphicsSetPDFContextURLForRect([NSURL URLWithString:@"https://www.autel.com"], stringRect);
    
    //title
    NSString *titleString = @"Scan Report";

    CGSize titleStringSize = [titleString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes
                                                     context:nil].size;
    
    CGRect titleStringRect = CGRectMake(((PDF_Width - titleStringSize.width) / 2.0),
                                   ((PDF_ContentMarginY - titleStringSize.height) / 2.0),
                                   titleStringSize.width,
                                   titleStringSize.height);
    
    [titleString drawInRect:titleStringRect withAttributes:attributes];
    
    //app
    
    NSString *appString = @"MaxiAp";
    
    
    CGSize appStringSize = [titleString boundingRectWithSize:maxSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributes
                                                       context:nil].size;
    
    CGRect appStringRect = CGRectMake(((PDF_Width - appStringSize.width) - PDF_LineMarginLR),
                                        ((PDF_ContentMarginY - appStringSize.height) / 2.0),
                                        appStringSize.width,
                                        appStringSize.height);
    
    [appString drawInRect:appStringRect withAttributes:attributes];
    

    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(currentContext, PDF_LineMarginLR, PDF_LineMarginTB);
    CGContextAddLineToPoint(currentContext, PDF_Width - PDF_LineMarginLR, PDF_LineMarginTB);
//    CGContextSetLineWidth(currentContext, 1);
    CGContextStrokePath(currentContext);
}



- (void)drawBottomContent {
    
    
    // line
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(currentContext, PDF_LineMarginLR, PDF_Height - PDF_LineMarginTB);
    CGContextAddLineToPoint(currentContext, PDF_Width - PDF_LineMarginLR, PDF_Height - PDF_LineMarginTB);
    CGContextStrokePath(currentContext);
    
    
    //icon
    CGSize iamgeSize = CGSizeMake(81, 14);
    CGRect imageRect = CGRectMake(PDF_LineMarginLR, (PDF_Height - PDF_ContentMarginY + (PDF_ContentMarginY - iamgeSize.height) / 2.0), iamgeSize.width, iamgeSize.height);
    UIImage *image = [UIImage imageNamed:@"Home_Logo"];
    [image drawInRect:imageRect];
    
    //copyRight
    NSString *titleString = @"@CopyRight 2017";
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(PDF_Width, 72);
    NSDictionary *attributes = @{NSFontAttributeName:theFont};
    
    
    CGSize titleStringSize = [titleString boundingRectWithSize:maxSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributes
                                                       context:nil].size;
    
    CGRect titleStringRect = CGRectMake(((PDF_Width - titleStringSize.width) / 2.0),
                                        (PDF_Height - PDF_ContentMarginY + (PDF_ContentMarginY - titleStringSize.height) / 2.0),
                                        titleStringSize.width,
                                        titleStringSize.height);
    
    [titleString drawInRect:titleStringRect withAttributes:attributes];
    
}


//车辆信息
- (void)drawVehicleInfo{
    
    //第一行 时间
    NSDate *date = [NSDate date];
    //然后您需要定义一个NSDataFormat的对象
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    //然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:SS";
    //之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
    NSString * dateToString = [dateFormat stringFromDate:date];
    

    NSDictionary * attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    
    NSString *vehicle = NSLocalizedString(@"Report_vehicle_info", nil);
    NSString *title = [NSString stringWithFormat:@"%@\n", vehicle];
    
    CGSize titleSize = [self drawLeftWithString:title attribute:attributes origin:CGPointMake(PDF_ContentMarginX, PDF_ContentMarginY + 5)];
    
    NSMutableString *vehicleInfoString = [[NSMutableString alloc] init];
    
    [vehicleInfoString appendString:self.vehicleModel.carBrand ?:@""];
    
    [vehicleInfoString appendString:@"\n"];
    
    [vehicleInfoString appendString:[NSString stringWithFormat:@"VIN: %@",self.vehicleModel.vinCode]];
    
    [vehicleInfoString appendString:@"                                "];
    
    NSString *time = NSLocalizedString(@"Report_scan_time", nil);
    [vehicleInfoString appendString:[NSString stringWithFormat:@"%@: %@",time, dateToString]];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.lineSpacing = 5.0;
    
    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle};
    
    [self drawLeftWithString:vehicleInfoString attribute:attributes origin:CGPointMake(PDF_ContentMarginX, PDF_ContentMarginY + titleSize.height)];

}



//绘制表格
- (void)drawTables {
    
    
    NSString *title = NSLocalizedString(@"Report_system_state_report", nil);
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    
    [self drawLeftWithString:title attribute:attributes origin:CGPointMake(PDF_ContentMarginX, tableOriginY - 25)];
    
    CGFloat tableHeight = (self.keys.count + 1) * rowHeight;
    UIColor *headFillColor = [UIColor colorWithHexString:@"404040"]; //表头填充色
    UIColor *lightFillColor = [UIColor colorWithHexString:@"f9f8f7"];  //浅色填充色
    UIColor *lineColor = [UIColor colorWithHexString:@"e1e1e1"];


    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    //表
    for (int i = 0; i <= self.keys.count; i ++) {
        
        NSString *titleString;
        NSString *countString;
        NSDictionary *attributes;
        
        //标题
        UIFont *theFont = [UIFont systemFontOfSize:12];
        CGSize maxSize = CGSizeMake(PDF_Width, 72);
        

        if (i == 0) {
            
            titleString = NSLocalizedString(@"Report_system_name", nil);
            countString = NSLocalizedString(@"Report_DTC_count", nil);
            attributes = @{NSFontAttributeName:theFont, NSForegroundColorAttributeName: [UIColor whiteColor]};
            
            //填充表头
            CGContextSetFillColorWithColor(currentContext,headFillColor.CGColor);
            CGContextFillRect(currentContext, CGRectMake(PDF_LineMarginLR, tableOriginY, PDF_Width - 2*PDF_LineMarginLR, rowHeight));
            
        }else{
            
            
            if (i % 2 == 1) {
                //浅色填充
                CGContextSetFillColorWithColor(currentContext,lightFillColor.CGColor);
                CGContextFillRect(currentContext, CGRectMake(PDF_LineMarginLR, tableOriginY + (i + 1) * rowHeight, PDF_Width - 2*PDF_LineMarginLR, rowHeight));
            }
            
        
            titleString = self.keys[i - 1];
            NSArray *array = self.modelsDict[self.keys[i - 1]];
            countString = [NSString stringWithFormat:@"%ld",array.count];
            attributes = @{NSFontAttributeName:theFont, NSForegroundColorAttributeName: [UIColor blackColor]};

        }
        
        
        
        CGSize titleStringSize = [titleString boundingRectWithSize:maxSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:attributes
                                                           context:nil].size;
        
        CGRect titleStringRect = CGRectMake(((PDF_Width * 2.0/3.0 - titleStringSize.width) / 2.0),
                                            (tableOriginY + i * rowHeight + (rowHeight - titleStringSize.height) / 2.0),
                                            titleStringSize.width,
                                            titleStringSize.height);
        
        [titleString drawInRect:titleStringRect withAttributes:attributes];
        
        //数量
        CGSize countStringSize = [countString boundingRectWithSize:maxSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:attributes
                                                           context:nil].size;
        
        CGRect countStringRect = CGRectMake(( PDF_Width - PDF_LineMarginLR - (PDF_Width - 2 * PDF_LineMarginLR) * 1/6 - countStringSize.width/2.0),
                                            (tableOriginY + i * rowHeight + (rowHeight - countStringSize.height) / 2.0),
                                            countStringSize.width,
                                            countStringSize.height);
        
        [countString drawInRect:countStringRect withAttributes:attributes];
     
        // line
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor);
        CGContextMoveToPoint(currentContext, PDF_LineMarginLR, tableOriginY + (i + 1) * rowHeight);
        CGContextAddLineToPoint(currentContext, PDF_Width - PDF_LineMarginLR, tableOriginY + (i + 1) * rowHeight);
        CGContextStrokePath(currentContext);
    }
    
    // 第一条线
    CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor);
    CGContextMoveToPoint(currentContext, PDF_LineMarginLR, tableOriginY);
    CGContextAddLineToPoint(currentContext, PDF_Width - PDF_LineMarginLR, tableOriginY);
    CGContextStrokePath(currentContext);
    
    
    // 左边竖线
    CGContextMoveToPoint(currentContext, PDF_LineMarginLR, tableOriginY);
    CGContextAddLineToPoint(currentContext, PDF_LineMarginLR, tableOriginY + tableHeight);
    CGContextStrokePath(currentContext);
    
    // 中间竖线
    CGContextMoveToPoint(currentContext, (PDF_Width - 2 * PDF_LineMarginLR) * 2/3 + PDF_LineMarginLR, tableOriginY);
    CGContextAddLineToPoint(currentContext, (PDF_Width - 2 * PDF_LineMarginLR) * 2/3 + PDF_LineMarginLR, tableOriginY + tableHeight);
    CGContextStrokePath(currentContext);
    
    
    //右边竖线
    CGContextMoveToPoint(currentContext, PDF_Width - PDF_LineMarginLR, tableOriginY);
    CGContextAddLineToPoint(currentContext, PDF_Width - PDF_LineMarginLR, tableOriginY + tableHeight);
    CGContextStrokePath(currentContext);

    

    
}


//左对齐,上下居中
- (CGSize)drawLeftWithString:(NSString *) string  attribute:(NSDictionary *)attribute origin:(CGPoint)origin{
    
    NSDictionary *attributeDic;
    CGSize maxSize = CGSizeMake(PDF_Width, 72);
    
    if (!attribute) {
        
        attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }else{
        attributeDic = attribute;
    }
    
    CGSize titleStringSize = [string boundingRectWithSize:maxSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributeDic
                                                  context:nil].size;
    
    [string drawInRect:CGRectMake(origin.x, origin.y, titleStringSize.width, titleStringSize.height) withAttributes:attributeDic];
    
    return titleStringSize;
}


//左右居中，上下居中
- (CGSize)drawCenterWithString:(NSString *) string  attribute:(NSDictionary *)attribute center:(CGPoint)center{

    NSDictionary *attributeDic;
    CGSize maxSize = CGSizeMake(PDF_Width, 72);
    
    if (!attribute) {
        
        attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }else{
        attributeDic = attribute;
    }
    
    CGSize titleStringSize = [string boundingRectWithSize:maxSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributeDic
                                                  context:nil].size;
    
    [string drawInRect:CGRectMake(center.x - titleStringSize.width/2.0, center.y, titleStringSize.width, titleStringSize.height) withAttributes:attributeDic];
    
    return titleStringSize;
    
}


@end
