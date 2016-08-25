//
//  VideoPlayView.h
//  02-远程视频播放(AVPlayer)
//
//  Created by 丁贵林 on 16/8/8.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayView : UIView

+ (instancetype)videoPlayView;

//@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, copy) NSString *urlString;

/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;

@end
