//
//  CommonHeaderView.h
//  LankeProject
//
//  Created by itman on 16/10/11.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopScrollView.h"


@class CommonHeaderView;

@protocol CommonHeaderViewDelegate <NSObject>

// 点选bannerimage的操作
- (void) commonHeaderView:(CommonHeaderView *)comonHeaderView didSelectedBannerImageAtIndex:(NSInteger)index;

@end

@interface CommonHeaderView : UIView

/**
 *  轮播视图，1:3
 */
@property (nonatomic ,strong) LoopScrollView * bannerView;


/**
 *  代理，用来传递要调转的视图控制器
 */
@property (nonatomic ,weak) id<CommonHeaderViewDelegate> delegate;

/**
 *  配置banner视图的图片以及需要跳转的视图
 *
 *  @param imageData 图片(本地或者网络图片)、点击跳转的视图
 */
- (void) configureBannerViewWithImageData:(NSArray *)imageData;

- (void) confiBannerViewWithImageData:(NSArray *)imageData fotKeyPath:(NSString *)keyPath;

///移除定时器
-(void)timerEnd;
@end
