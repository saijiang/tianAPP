//
//  UIImage+MHBlur.h
//  MHProject
//
//  Created by MengHuan on 15/5/11.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

/**
 *  图片模糊效果
 *
 *  @framework
 *      Accelerate.framework
 *      QuartzCore.framework
 */

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>


@interface UIImage (MHBlur)

// 0.0 to 1.0
- (UIImage*)blurredImage:(CGFloat)blurAmount;

//[self applyBlurWithRadius:0
//                tintColor:[UIColor colorWithWhite:0. alpha:0.3]
//    saturationDeltaFactor:1.4
//                maskImage:nil];

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;


@end
