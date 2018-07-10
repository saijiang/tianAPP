//
//  UIImage+MHImageWithColor.h
//  MHProject
//
//  Created by MengHuan on 15/5/11.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

/**
 *  创建颜色图片
 */

#import <UIKit/UIKit.h>

@interface UIImage (MHImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColorHexString:(NSString *)hexString;


/**
 *  拥有一个具有渐变颜色的image实例
 *
 *  @param tintColor 需要渐变的颜色
 *
 *  @return 渐变的规则是由上至下变深，最深就是tintColor
 */
- (UIImage*)tintedGradientImageWithColor:(UIColor*)tintColor;
/**
 *  改变iamage实例的颜色
 *
 *  @param tintColor 想要的颜色
 *
 *  @return 改变过颜色的image实例
 */
- (UIImage*)tintedImageWithColor:(UIColor*)tintColor;

+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor rect:(CGRect)drawingRect;
@end
