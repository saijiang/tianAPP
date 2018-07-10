//
//  UILabel+MHCommon.h
//  MHProject
//
//  Created by MengHuan on 16/3/25.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MHCommon)

- (CGFloat)originalHeight;

// 设置Label的文字显示方式从左上角开始
- (void)alignTop;

// 设置Label的文字显示方式从左下角开始
- (void)alignBottom;

@end
