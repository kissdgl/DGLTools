//
//  DGLWaterflowLayout.h
//  01-瀑布流(基本框架)
//
//  Created by 丁贵林 on 16/8/21.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DGLWaterflowLayout;

@protocol DGLWaterflowLayoutDelegate <NSObject>

@required
/** 返回item的高度 */
- (CGFloat)waterflowLayout:(DGLWaterflowLayout *)layout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/** 返回列间距 */
- (CGFloat)columnCountInWaterflowLayout:(DGLWaterflowLayout *)waterflowLayout;
/** 返回列数 */
- (CGFloat)columnMarginInWaterflowLayout:(DGLWaterflowLayout *)waterflowLayout;
/** 返回行间距 */
- (CGFloat)rowMarginInWaterflowLayout:(DGLWaterflowLayout *)waterflowLayout;
/** 返回边距 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(DGLWaterflowLayout *)waterflowLayout;


@end

@interface DGLWaterflowLayout : UICollectionViewLayout

/** 代理 */
@property(nonatomic ,weak) id<DGLWaterflowLayoutDelegate> delegate;

@end
