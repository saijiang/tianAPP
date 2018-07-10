//
//  LeftImageBtn.m
//  DDXGMarkeProject
//
//  Created by itman on 16/5/10.
//  Copyright © 2016年 张涛. All rights reserved.
//


#import "LeftImageBtn.h"

@implementation LeftImageBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}

//重绘imageRect
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    //文字居右 图片居左
    return CGRectMake(0, (CGRectGetHeight(contentRect)-20)/2.0,15,15);
    
    
}

//重绘titleRect
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //文字居右 图片居左
    return CGRectMake(25, 0,CGRectGetWidth(contentRect) , CGRectGetHeight(contentRect));
}

@end

@implementation RightImageButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

//重绘imageRect
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = CGSizeMake(20, 20);
    
    //文字居右 图片居左
    return CGRectMake(CGRectGetWidth(contentRect) - size.width,
                      (CGRectGetHeight(contentRect)-size.height)/2.0,
                      size.width,
                      size.height);
}

//重绘titleRect
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize size = CGSizeMake(20, 20);

    //文字居右 图片居左
    return CGRectMake(0,
                      0,
                      CGRectGetWidth(contentRect) - size.width,
                      CGRectGetHeight(contentRect));
    
}

@end


@implementation TopImageButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

static CGFloat top_image_scale = 0.7;

//重绘imageRect
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //文字居右 图片居左
    return CGRectMake(0,
                      0,
                      contentRect.size.width,
                      contentRect.size.height * top_image_scale);
}

//重绘titleRect
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{    
    //文字居右 图片居左
    return CGRectMake(0,
                      contentRect.size.height * top_image_scale,
                      contentRect.size.width,
                      contentRect.size.height * (1-top_image_scale));
    
}
@end
