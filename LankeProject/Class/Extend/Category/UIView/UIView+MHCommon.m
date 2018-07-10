//
//  UIView+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "UIView+MHCommon.h"

@implementation UIView (MHCommon)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.centerY);
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.centerX, centerY);
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (void)addSubviewOrBringToFront:(UIView *)subview
{
    BOOL found = NO;
    
    for (UIView *v in self.subviews) {
        if (v == subview) {
            found = YES;
            
            break;
        }
    }
    
    if (found) {
        [self bringSubviewToFront:subview];
        
    } else {
        [self addSubview:subview];
    }
}

- (void)frameSet:(NSString *)key value:(CGFloat)value
{
    CGRect rect = self.frame;
    
    if ([@"x" isEqualToString:key]) {
        rect.origin.x = value;
        
    } else if ([@"y" isEqualToString:key]) {
        rect.origin.y = value;
        
    } else if ([@"w" isEqualToString:key]) {
        rect.size.width = value;
        
    } else if ([@"h" isEqualToString:key]) {
        rect.size.height = value;
    }
    
    self.frame = rect;
}

- (void)frameSet:(NSString *)key1 value1:(CGFloat)value1 key2:(NSString *)key2 value2:(CGFloat)value2
{
    [self frameSet:key1 value:value1];
    [self frameSet:key2 value:value2];
}

- (void)addLine:(CGRect)rect
{
    [self addLine:[UIColor colorWithHexString:@"#A5A5A5"] inRect:rect];
}

- (void)addLine:(UIColor *)color inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0/[UIScreen mainScreen].scale);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
   	CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

/**
 *  左边线
 *
 *
 */
- (void)setLeftlineWithColor:(UIColor *)leftlineWithColor
{
    UIView *lineView=[self viewWithTag:10000];
    if (lineView)
    {
        lineView.backgroundColor=leftlineWithColor;
        return;
    }
    
    UIView *line=[[UIView alloc]init];
    line.tag=10000;
    line.backgroundColor=leftlineWithColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(self.mas_height);
    }];
}

/**
 *  上部边线
 *
 */
- (void)setToplineWithColor:(UIColor *)toplineWithColor
{
    UIView *lineView=[self viewWithTag:10001];
    if (lineView)
    {
        lineView.backgroundColor=toplineWithColor;
        return;
    }
    
    UIView *line=[[UIView alloc]init];
    line.tag=10001;
    line.backgroundColor=toplineWithColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(0.5);
    }];
    
}

/**
 *  右边线
 *
 */

- (void)setRightlineWithColor:(UIColor *)rightlineWithColor
{
    UIView *lineView=[self viewWithTag:10002];
    if (lineView)
    {
        lineView.backgroundColor=rightlineWithColor;
        return;
    }
    
    UIView *line=[[UIView alloc]init];
    line.tag=10002;
    line.backgroundColor=rightlineWithColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(self.mas_height);
    }];
    
}

/**
 *  底部线
 *
 */

- (void)setBottomlineWithColor:(UIColor *)bottomlineWithColor
{
    UIView *lineView=[self viewWithTag:10003];
    if (lineView)
    {
        lineView.backgroundColor=bottomlineWithColor;
        return;
    }
    
    UIView *line=[[UIView alloc]init];
    line.tag=10003;
    line.backgroundColor=bottomlineWithColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(1);
    }];
}



@end

@implementation UIView (Line)

+ (instancetype) lineView{

    UIView * view = [[self alloc] init];
    view.backgroundColor = BM_Color_SeparatorColor;
    return view;
}

@end

@implementation UIView (Snpashot)

- (UIImage *)captureImage
{
    return [self captureImageAtRect:self.bounds];
}

- (UIImage *)captureImageAtRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    [[self layer] renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
