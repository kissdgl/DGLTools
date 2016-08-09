//
//  UIImageView+Download.h
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/21.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (Download)

/**
 *  设置imageview的显示图片
 *
 *  @param originalImageURL  原始图片URL
 *  @param thumbnailImageURL 缩略图URL
 *  @param placeholderImage  占位图片
 */
- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage;

/**
 *  设置imageview的显示图片
 *
 *  @param originalImageURL  原始图片URL
 *  @param thumbnailImageURL 缩略图URL
 */
- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL;


/**
 *  设置imageview的显示图片
 *
 *  @param originalImageURL  原始图片URL
 *  @param thumbnailImageURL 缩略图URL
 *  @param placeholderImage  占位图片
 *  @param completedBlock    获取图片完成后调用block
 */
- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock;

/**
 *  设置imageview的显示图片
 *
 *  @param originalImageURL  原始图片URL
 *  @param thumbnailImageURL 缩略图URL
 *  @param completedBlock    获取图片完成后调用block
 */
- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL completed:(SDWebImageCompletionBlock)completedBlock;

@end
