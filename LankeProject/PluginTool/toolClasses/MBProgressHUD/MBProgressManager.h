//
//  MBProgressManager.h
//  BlueMobiProject
//
//  Created by 步晓虎 on 14-8-13.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"



@interface MBProgressManager : NSObject 

/**
 *  显示文字的 类似安卓
 *
 *  @param text text description
 *  @param view view description
 */
+ (void)ShowWithText:(NSString *)text fromView:(UIView *)view;
/**
 *  隐藏菊花
 *
 *  @param view view description
 */
+ (void)hidFormView:(UIView *)view;
/**
 *  隐藏文字提示
 *
 *  @param view  view description
 *  @param delay delay description
 */
+ (void)hidFormView:(UIView *)view afterDelay:(CGFloat)delay;
/**
 *  显示菊花
 *
 *  @param view view description
 */
+ (void)SHowLoadingToView:(UIView *)view;

@end
