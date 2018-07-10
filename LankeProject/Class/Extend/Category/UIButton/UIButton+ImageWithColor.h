//
//  UIButton+ImageWithColor.h
//  CategoryDemo
//
//  Created by Youngrocky on 16/6/15.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageWithColor)

/**
 *  根据一个颜色值设置对应状态下的image
 */
- (void) hll_setImageWithColor:(UIColor *)color
                      forState:(UIControlState)state;
- (void) hll_setImageWithHexString:(NSString *)hexString
                      forState:(UIControlState)state;

/**
 *  根据一个颜色值设置对应状态下的backgroundImage
 */
- (void) hll_setBackgroundImageWithColor:(UIColor *)color
                                forState:(UIControlState)state;
- (void) hll_setBackgroundImageWithHexString:(NSString *)hexString
                                    forState:(UIControlState)state;
@end

@interface UIButton (EventHandleBlock)

@property (nonatomic ,copy) void (^bTouchUpInsideBlock)();

@end
