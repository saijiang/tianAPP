//
//  ShopCarSliderView.h
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MHCommon.h"
@class ShopCarSliderView;

@protocol ShopCarSliderDelegate <NSObject>

- (void)slidingScrollView:(ShopCarSliderView *)SlidingScrollView didSeletedIndex:(NSInteger)index;

@end



@interface ShopCarSliderView : UIView

@property(nonatomic,assign)id<ShopCarSliderDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)typeArr;

-(void)setSliderLineHight:(float)hight;//设置底部划线高度

-(void)setSliderLineWidth:(float)width;//设置底部划线宽度

-(void)setSelectedIndex:(NSInteger)index;//设置默认选中

-(void)setSegmentLineColor:(UIColor *)color;//设置分割线的颜色

-(void)sliderImageViewHidden:(BOOL)hidden;

-(NSInteger)getSeletedIndex;


@end
