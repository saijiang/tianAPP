//
//  tabbarItem.m
//  ZTFramework
//
//  Created by kzss on 15/10/24.
//  Copyright © 2015年 ZT. All rights reserved.
//
//图片距顶部
#define IMAGE_TOP                       (8.0)
//图片宽度
#define IMAGE_WIDTH                     (20.0)
//图片高度
#define IMAGE_HEIGHT                    (20.0)
//文字高度
#define TITLE_HEIGHT                    (15.0)
//图片文字间隔
#define ICON_TITLE_INTERVAL             (3.0)

#import "TabbarItem.h"

@implementation TabbarItem

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.badgeView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.badgeView.layer.masksToBounds=YES;
        self.badgeView.layer.cornerRadius=DEF_WIDTH(self.badgeView)/2.0;
        self.badgeView.backgroundColor=[UIColor redColor];
        self.badgeView.titleLabel.textColor=[UIColor whiteColor];
        self.badgeView.titleLabel.font=[UIFont systemFontOfSize:10];
        self.badgeView.hidden=YES;
        [self addSubview:self.badgeView];
    }
    return self;
}
-(void)setBadgeValue:(NSString *)badgeValue
{
    self.badgeView.hidden=NO;
    if ([badgeValue integerValue]==0)
    {
        self.badgeView.hidden=YES;
    }
    [self.badgeView setTitle:badgeValue forState:UIControlStateNormal];;
}
//重绘imageRect
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    //文字居下 图片居上
    return CGRectMake((CGRectGetWidth(contentRect)-IMAGE_WIDTH)/2.0, IMAGE_TOP, IMAGE_WIDTH, IMAGE_HEIGHT);

    
}

//重绘titleRect
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
   
    
    //文字居下 图片居上
    return CGRectMake(0,  IMAGE_TOP+IMAGE_HEIGHT+ICON_TITLE_INTERVAL,
                      CGRectGetWidth(contentRect),
                      TITLE_HEIGHT);

}

@end
