//
//  DGLPDFDrawer.h
//  DGLPDFDemo
//
//  Created by Autel_Ling on 2017/3/29.
//  Copyright © 2017年 Autel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AUTTroubleCodeModel.h"
#import "AUTVehicleModel.h"


@interface DGLPDFDrawer : NSObject


+ (instancetype)PDFDrawerWittFilePath:(NSString *)filePath;

- (void)addContentWithModelsDict:(NSDictionary *)dict keys:(NSArray *)keys vehicleModel:(AUTVehicleModel *)vehicleModel;

- (void)startDrawPDF;

@end
