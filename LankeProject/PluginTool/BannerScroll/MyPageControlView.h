//
//  MyPageControlView.h
//  bannerScroll
//
//  Created by Appolls on 15-2-9.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControlView : UIPageControl

- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) UIColor *normalColor;
@end
