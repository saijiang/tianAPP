//
//  UIImage+MHImageWithColor.m
//  MHProject
//
//  Created by MengHuan on 15/5/11.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "UIImage+MHImageWithColor.h"

@implementation UIImage (MHImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColorHexString:(NSString *)hexString{

    UIColor * color = [UIColor colorWithHexString:hexString];
    
    return [UIImage imageWithColor:color];
}

#pragma mark - Public methods

- (UIImage*)tintedGradientImageWithColor:(UIColor*)tintColor{
    
    return [self tintedImageWithColor:tintColor blendingMode:kCGBlendModeOverlay];
}

- (UIImage*)tintedImageWithColor:(UIColor*)tintColor{
    
    return [self tintedImageWithColor:tintColor blendingMode:kCGBlendModeDestinationIn];
}

#pragma mark - Private methods

- (UIImage*)tintedImageWithColor:(UIColor*)tintColor blendingMode:(CGBlendMode)blendMode{
    
    // 传递一个0.0用来确保绘制的图像是原来的尺寸，这点很重要。
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0.0f);
    
    [tintColor setFill];
    
    CGRect bounds = CGRectMake(0,0,self.size.width,self.size.height);
    
    UIRectFill(bounds);
    
    // 至于这里为什么这么写，我也不是很清楚，可以点进去看一下文档，是一些通道的算法
    if (blendMode != kCGBlendModeDestinationIn) {
        
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    }
    
    UIImage * tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor rect:(CGRect)drawingRect
{
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(drawingRect, 1.0f, 1.0f) cornerRadius:cornerRadius];
    if (strokeColor) {
        [strokeColor setStroke];
        [aPath stroke];
    }
    if (fillColor) {
        [fillColor setFill];
        [aPath fill];
    }
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

@end
