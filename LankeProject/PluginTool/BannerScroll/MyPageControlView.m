//
//  MyPageControlView.m
//  bannerScroll
//
//  Created by Appolls on 15-2-9.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MyPageControlView.h"

@interface MyPageControlView(private)  // 声明一个私有方法, 该方法不允许对象直接使用
- (void)updateDots;
@end


@implementation MyPageControlView  // 实现部分

- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    self.userInteractionEnabled=NO;
    
    return self;
}


- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    _imagePageStateHighlighted = image;
    [self updateDots];
}


- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    _imagePageStateNormal = image;
    [self updateDots];
}

- (void)setCurrentColor:(UIColor *)currentColor { // 设置高亮状态点按钮图片
    _currentColor = currentColor;
    [self setCurrentPageIndicatorTintColor:self.currentColor];
}

- (void)setNormalColor:(UIColor *)normalColor { // 设置高亮状态点按钮图片
    _normalColor = normalColor;
    [self setPageIndicatorTintColor:self.normalColor];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    
    
    if (_imagePageStateNormal || _imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIView *dot = [subview objectAtIndex:i];  // 以下不解释, 看了基本明白
            dot.backgroundColor=BM_CLEAR;
            [dot removeAllSubviews];
            
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(dot), DEF_WIDTH(dot))];
            bgImgView.contentMode=UIViewContentModeScaleAspectFit;
            [dot addSubview:bgImgView];
            
            if (self.currentPage == i)
            {
                bgImgView.image=_imagePageStateHighlighted;
              
            }
            else
            {
                bgImgView.image=_imagePageStateNormal;

            }
            
        }
    }
}


- (void)dealloc { // 释放内存
}

@end
