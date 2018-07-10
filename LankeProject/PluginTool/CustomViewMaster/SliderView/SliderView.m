//
//  SliderView.m
//  LankeProject
//
//  Created by itman on 16/10/11.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

{
    UIImageView *sliderImageView;
    NSArray *itemArr;
}

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)typeArr
{
    self=[super initWithFrame:frame];
    if (self)
    {
        itemArr=typeArr;
        self.backgroundColor = BM_WHITE;
        for (int i=0; i<typeArr.count; i++)
        {
            UIButton *type=[[UIButton alloc]initWithFrame:CGRectMake(DEF_WIDTH(self)/typeArr.count*i, 0, DEF_WIDTH(self)/typeArr.count - 1, DEF_HEIGHT(self))];
            [self addSubview:type];
            type.tag=100+i;
            type.titleLabel.font=BM_FONTSIZE15;
            [type setTitle:typeArr[i] forState:UIControlStateNormal];
            [type setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [type setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
            [type addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *shuLine = [[UILabel alloc] initWithFrame:CGRectMake(DEF_RIGHT(type), 0, 1, DEF_HEIGHT(self))];
            shuLine.tag=200+i;
            shuLine.backgroundColor = [UIColor clearColor];
            [self addSubview:shuLine];
            
            if (i==0)
            {
                type.selected=YES;
            }
            if (i==typeArr.count-1)
            {
                
                sliderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + (DEF_WIDTH(self)/typeArr.count/2)/2, DEF_HEIGHT(self)-2, DEF_WIDTH(self)/typeArr.count/2, 2)];
                sliderImageView.backgroundColor = BM_Color_Blue;
                [self addSubview:sliderImageView];
            }
            
        }
        
        [self autoresizingFrame];
    }
    return self;
}
-(void)typeClick:(UIButton *)type
{
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton *)view;
            btn.selected=NO;
        }
    }
    type.selected=YES;
    [UIView animateWithDuration:0.3 animations:^{
        sliderImageView.centerX=type.centerX;
    }];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(slidingScrollView:didSeletedIndex:)])
    {
        [self.delegate slidingScrollView:self didSeletedIndex:type.tag-100];
    }
}
-(void)setSliderLineHight:(float)hight
{
    sliderImageView.frame=CGRectMake(DEF_LEFT(sliderImageView), DEF_HEIGHT(self)-hight, DEF_WIDTH(sliderImageView), hight);
}
-(void)setSliderLineWidth:(float)width
{
    float leftOffset=  (width -DEF_WIDTH(sliderImageView))/2.0;
    sliderImageView.frame=CGRectMake(DEF_LEFT(sliderImageView)-leftOffset, DEF_TOP(sliderImageView), width, DEF_HEIGHT(sliderImageView));
    
}

-(void)setSelectedIndex:(NSInteger)index
{
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton *)view;
            btn.selected=NO;
        }
    }
    UIButton *type=(UIButton *)[self viewWithTag:index+100];
    type.selected=YES;
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            sliderImageView.centerX=type.centerX;
            
        }];
        
    });
    
}
-(void)sliderImageViewHidden:(BOOL)hidden
{
    sliderImageView.hidden=hidden;
}
-(void)setSegmentLineColor:(UIColor *)color
{
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            UILabel *line=(UILabel *)view;
            line.backgroundColor=color;
        }
    }
    
}
-(void)autoresizingFrame
{
    UIView *lastSpaceView       = [UIView new];
    lastSpaceView.backgroundColor = [UIColor clearColor];
    [self addSubview:lastSpaceView];
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.and.top.and.bottom.equalTo(self);
     }];
    
    for (NSUInteger i = 0; i < itemArr.count; i++)
    {
        UIButton *itemView = [self viewWithTag:100+i];
        [self addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(lastSpaceView.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIView *spaceView         = [UIView new];
        spaceView.backgroundColor = [UIColor clearColor];
        [self addSubview:spaceView];
        
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView.mas_right).with.priorityHigh(); // 降低优先级，防止宽度不够出现约束冲突
            make.top.and.bottom.equalTo(self);
            make.width.equalTo(lastSpaceView.mas_width);
        }];
        
        lastSpaceView = spaceView;
    }
    
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.mas_right);
     }];
 

}

@end
