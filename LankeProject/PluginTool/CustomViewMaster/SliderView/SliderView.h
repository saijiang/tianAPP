//
//  SliderView.h
//  LankeProject
//
//  Created by itman on 16/10/11.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderView;
@protocol SliderViewDelegate <NSObject>

-(void)slidingScrollView:(SliderView *)SlidingScrollView didSeletedIndex:(NSInteger)index;

@end


@interface SliderView : UIView
@property(nonatomic,assign)id<SliderViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)typeArr;

-(void)setSliderLineHight:(float)hight;//设置底部划线

-(void)setSliderLineWidth:(float)width;//设置底部划线

-(void)setSelectedIndex:(NSInteger)index;//设置默认选中

-(void)setSegmentLineColor:(UIColor *)color;//设置分割线的颜色

-(void)sliderImageViewHidden:(BOOL)hidden;

@end
