//
//  LKBottomButton.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKBottomButton.h"

@implementation LKBottomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [self hll_setBackgroundImageWithColor:BM_Color_Blue
                                     forState:UIControlStateNormal];
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

+ (instancetype) buttonForOrder{

    LKBottomButton * button = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitleColor:BM_WHITE forState:UIControlStateNormal];
    [button hll_setBackgroundImageWithColor:BM_Color_Blue
                                   forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    return button;
}

- (void) configTextColor:(UIColor *)textColor text:(NSString *)text borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor{
    
    self.layer.borderColor = borderColor.CGColor;
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    [self hll_setBackgroundImageWithColor:backgroundColor
                                 forState:UIControlStateNormal];
}
@end
