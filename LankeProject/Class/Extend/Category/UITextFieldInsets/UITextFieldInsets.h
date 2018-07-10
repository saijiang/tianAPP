//
//  UITextFieldInsets.h
//  BMProject
//
//  Created by 董駸 on 15/8/25.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldInsets : UITextField

@property (nonatomic ,strong) UIColor *placeHolderColor;//占位字颜色

- (id)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;

@end
