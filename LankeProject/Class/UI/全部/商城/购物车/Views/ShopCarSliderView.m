//
//  ShopCarSliderView.m
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ShopCarSliderView.h"

@implementation ShopCarSliderView
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
            //标题颜色 <color name="shakespeare">#47A7D5</color>
            [type setTitleColor:BM_BLACK forState:UIControlStateNormal];
            [type setTitleColor:[UIColor colorWithHexString:@"47A7D5"] forState:UIControlStateSelected];
            [type addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *shuLine = [[UILabel alloc] initWithFrame:CGRectMake(DEF_RIGHT(type), 0, 1, DEF_HEIGHT(self))];
            shuLine.tag=200+i;
            shuLine.backgroundColor = [UIColor clearColor];
            [self addSubview:shuLine];
            
            if (i==0)
            {
                type.selected=YES;
                sliderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + (DEF_WIDTH(self)/typeArr.count/2)/2, DEF_HEIGHT(self)-2, DEF_WIDTH(self)/typeArr.count/2, 2)];
                //背景色
                sliderImageView.backgroundColor = [UIColor colorWithHexString:@"47A7D5"];
                sliderImageView.centerX=type.centerX;
                [self addSubview:sliderImageView];
                
            }
            
        }
        [self autoresizingFrame];
        [self reloadLine];
        
        
        
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
    [self reloadLine];
    
    
}
//设置slider的宽度
-(void)setSliderLineWidth:(float)width
{
    float leftOffset=  (width -DEF_WIDTH(sliderImageView))/2.0;
    sliderImageView.frame=CGRectMake(DEF_LEFT(sliderImageView)-leftOffset, DEF_TOP(sliderImageView), width, DEF_HEIGHT(sliderImageView));
    
    [self reloadLine];
}

-(void)reloadLine
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (id view in self.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *btn=(UIButton *)view;
                if (btn.selected)
                {
                    sliderImageView.centerX=btn.centerX;
                    
                }
            }
        }
        
        
    });
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
    [UIView animateWithDuration:0.3 animations:^{
        sliderImageView.centerX=type.centerX;
        
    }];
    [self typeClick:type];
    
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

-(NSInteger)getSeletedIndex
{
    
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton *)view;
            if (btn.selected)
            {
                return btn.tag-100;
            }
        }
    }
    return 0;
    
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
