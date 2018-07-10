//
//  UITextFieldInsets.m
//  BMProject
//
//  Created by 董駸 on 15/8/25.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "UITextFieldInsets.h"

@interface UITextFieldInsets ()

@property (nonatomic, assign) UIEdgeInsets insets;

@end

@implementation UITextFieldInsets

-(id)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.insets = insets;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, _insets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, _insets);
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    [self setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}




@end
