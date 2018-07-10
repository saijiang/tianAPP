//
//  StarView.m
//  EvaluationStar
//
//  Created by 赵贺 on 15/11/26.
//  Copyright © 2015年 赵贺. All rights reserved.
//

#import "StarView.h"

#define imageW  self.bounds.size.width/10

@interface StarView ()
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@property (nonatomic, assign) int starNumber;//星星数

@property (nonatomic, assign) float starWidth;//宽

@property (nonatomic, assign) float starHeight;//高

@end
@implementation StarView

#pragma mark -  Attention 算法：如何计算出需要显示的评分控件的高度；大概的显示区域的宽度 / 星星个数 / 2
- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star withStarNumber:(int)starNum
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.starWidth = frame.size.width / (starNum*1.3); // -- 一颗星星的宽度算法：总长度/2/2
        self.starNumber = starNum;
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty];
        self.starForegroundView = [self buidlStarViewWithImageName:Star];
        [self addSubview:self.starBackgroundView];
        self.userInteractionEnabled = YES;
        
        /**点击手势*/
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        /**滑动手势*/
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:panGR];
    }
    return self;
}

/**
 *  画星星
 *
 *  @param imageName imageName description
 *
 *  @return return value description
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    
    for (int j = 0; j < self.starNumber; j ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        imageView.frame = CGRectMake(1.3*j*self.starWidth, DEF_HEIGHT(self)/2 - self.starWidth/2, self.starWidth, self.starWidth); // 根据宽限制高
        [view addSubview:imageView];
    }
    
    return view;
}

/**
 *  显示星级
 *
 *  @param starNum starNum description
 *
 *  @return return value description
 */
- (void )buildStarViewWithImageNum:(float)starNum
{
    self.starForegroundView.frame = CGRectMake(0, 0, starNum*1.3*self.starWidth, self.frame.size.height); // -- 选中星星的覆盖
    [self addSubview:self.starForegroundView];
}


-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint point =[tapGR locationInView:self];
    if (point.x<0) {
        point.x = 0;
    }    
    int X = (int) point.x/(1.3*self.starWidth);  // - 整形
    self.starForegroundView.frame = CGRectMake(0, 0, (X+1)*1.3*self.starWidth, DEF_HEIGHT(self)); // -- 选中星星的覆盖
    if (self.starBlock)
    {
        self.starBlock(X);
    }
}

- (void)showStarNumber:(starNumber)starValue;
{
    self.starBlock = [starValue copy];
}

@end
