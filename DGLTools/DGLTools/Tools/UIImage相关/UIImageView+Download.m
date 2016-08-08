//
//  UIImageView+Download.m
//  BUDEJIE
//
//  Created by 丁贵林 on 16/7/21.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import "UIImageView+Download.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>


@implementation UIImageView (Download)


- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage {

    [self dgl_setImageWithOriginalURL:originalImageURL thumbnailURL:thumbnailImageURL placeholderImage:placeholderImage completed:nil];
    
}

- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL {
    
    [self dgl_setImageWithOriginalURL:originalImageURL thumbnailURL:thumbnailImageURL placeholderImage:nil completed:nil];
}

- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock {
    
    //从内存或沙盒中获得原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalImageURL];
    if (originalImage) {
        
        [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholderImage completed:completedBlock];
        
    } else {
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        if (manager.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholderImage completed:completedBlock];
        } else if (manager.isReachableViaWWAN){
//#warning 从沙盒中读取用户配置: 在3G/4G网络下任然下载原图
            BOOL alwaysDownloadOriginalImage = [[NSUserDefaults standardUserDefaults] boolForKey:@"alwaysDownloadOriginalImage"];
            if (alwaysDownloadOriginalImage) {
                [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholderImage completed:completedBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage completed:completedBlock];
            }
        } else {
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage completed:completedBlock];
            } else {
                [self sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];
            }
        }
    }
    
}

- (void)dgl_setImageWithOriginalURL:(NSString *)originalImageURL thumbnailURL:(NSString *)thumbnailImageURL completed:(SDWebImageCompletionBlock)completedBlock {
    
    [self dgl_setImageWithOriginalURL:originalImageURL thumbnailURL:thumbnailImageURL placeholderImage:nil completed:completedBlock];
}


@end
