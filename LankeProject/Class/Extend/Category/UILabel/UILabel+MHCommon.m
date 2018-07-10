//
//  UILabel+MHCommon.m
//  MHProject
//
//  Created by MengHuan on 16/3/25.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "UILabel+MHCommon.h"
#import <objc/runtime.h>

static const char* UILabelHeightEnhancementKey = "uilabel_height_associated_key";

@implementation UILabel (MHCommon)

- (CGFloat)originalHeight
{
    id obj = objc_getAssociatedObject(self, UILabelHeightEnhancementKey);
    
    if (obj && [obj respondsToSelector:@selector(floatValue)]) {
        return [obj floatValue];
    }
    
    // 还从来没设置过，这是第一次调用，以当前高度作为初始高度设置上去
    objc_setAssociatedObject(self, UILabelHeightEnhancementKey, [NSNumber numberWithFloat:self.frame.size.height], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return self.frame.size.height;
}

- (void)alignTop
{
    CGFloat width       = self.frame.size.width;
    self.numberOfLines  = 0;
    
    [self sizeToFit];
    [self frameSet:@"w" value:width];
}

- (void)alignBottom
{
    // 为了使得UILabel里的文字始终在下边缘显示，需要重新设置UILabel的y位置，在此之前需要以UILabel的初始高度算出其距离底部的恒定距离是多少
    CGFloat width       = self.frame.size.width;
    CGFloat height      = self.originalHeight;
    CGFloat bottom      = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
    self.numberOfLines  = 0;
    
    [self sizeToFit];
    
    // 判断当前UILabel里的这些文字是否已经超出原定高度了，若超出则需要重新限定高度
    if (self.frame.size.height > height || self.frame.size.height == 0) {
        [self frameSet:@"h" value:height];
    }
    
    [self frameSet:@"w" value1:width
              key2:@"y" value2:self.superview.frame.size.height - bottom - self.frame.size.height
     ];
}

@end
