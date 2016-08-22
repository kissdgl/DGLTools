//
//  DGLFlowLayout.m
//  01-UICollectionView基本使用
//
//  Created by 丁贵林 on 16/8/22.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "DGLFlowLayout.h"

@interface DGLFlowLayout()


@end

@implementation DGLFlowLayout

//- (void)prepareLayout {
//    
//    NSLog(@"%s", __func__);
//    
//}

//返回在rect区域内所有cell对应的布局
//超出指定区域就会调用
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //获取当前滚动区域
    CGFloat offsetX = self.collectionView.contentOffset.x;
    //collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    CGFloat collectionH = self.collectionView.bounds.size.height;
    //获取当前显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, collectionH);
    
    //获取当前显示区域内所有的cell
    NSArray *visableAtts = [super layoutAttributesForElementsInRect:visableRect];
    
    //遍历显示区域内的cell布局 并判断与中心点的距离
    for (UICollectionViewLayoutAttributes *attrs in visableAtts) {
        
        CGFloat delta = fabs((attrs.center.x - offsetX) - collectionW * 0.5);
        CGFloat scale = 1 - delta / collectionW * 0.5;
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return visableAtts;
}

//是否允许刷新布局 当bounds改变的时候
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


//调用时刻: 拖动完成的时候
//方法: 拖动完成的时候的滚动区域
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    CGFloat offsetX = proposedContentOffset.x;
    
    //获取显示的cell布局
    //获取显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, self.collectionView.bounds.size.height);
    
    //获取当前显示区域所有的cell布局
    NSArray *visableAttrs = [super layoutAttributesForElementsInRect:visableRect];
    
    //记录最小中心点位置
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in visableAttrs) {
        //计算中心点的距离
        CGFloat delta = attrs.center.x- (collectionW * 0.5 + proposedContentOffset.x);
        
        //获取上一个
        if (delta < fabs(minDelta)) {
            minDelta = delta;
        }
    }
    
    proposedContentOffset.x += minDelta;
    
    if (proposedContentOffset.x <= 0) {
        proposedContentOffset.x = 0;
    }
    
    return proposedContentOffset;
    
}


//collectionView的滚动范围
//- (CGSize)collectionViewContentSize {
//    
//    CGSize size = [super collectionViewContentSize];
//    
//    NSLog(@"%@", NSStringFromCGSize(size));
//    
//    return size;
//}

@end
