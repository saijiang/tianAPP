//
//  UIButton+ImageWithColor.m
//  CategoryDemo
//
//  Created by Youngrocky on 16/6/15.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import "UIButton+ImageWithColor.h"

@implementation UIButton (ImageWithColor)

/**
 *  根据一个颜色值设置对应状态下的image
 */
- (void) hll_setImageWithColor:(UIColor *)color
                      forState:(UIControlState)state{
    
    [self setImage:[UIImage imageWithColor:color]
          forState:state];
}
- (void)hll_setImageWithHexString:(NSString *)hexString forState:(UIControlState)state{

    [self hll_setImageWithColor:[UIColor colorWithHexString:hexString] forState:state];
}

/**
 *  根据一个颜色值设置对应状态下的backgroundImage
 */
- (void) hll_setBackgroundImageWithColor:(UIColor *)color
                                forState:(UIControlState)state{
    
    [self setBackgroundImage:[UIImage imageWithColor:color]
                    forState:state];
}

-(void)hll_setBackgroundImageWithHexString:(NSString *)hexString forState:(UIControlState)state{

    [self hll_setBackgroundImageWithColor:[UIColor colorWithHexString:hexString] forState:state];
}
@end

@implementation UIButton (EventHandleBlock)

- (void)setBTouchUpInsideBlock:(void (^)())bTouchUpInsideBlock{

    [self addTarget:self action:@selector(touchUpInsideHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, @selector(bTouchUpInsideBlock), bTouchUpInsideBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)())bTouchUpInsideBlock{

    return objc_getAssociatedObject(self, _cmd);
}

- (void) touchUpInsideHandle:(UIButton *)button{
    
    if (self.bTouchUpInsideBlock) {
        self.bTouchUpInsideBlock();
    }
}

@end
