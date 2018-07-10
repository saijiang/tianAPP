//
//  LKStepView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LKStepView.h"

@interface UIButton (StepButton)

+ (UIButton *) stepButtonTitle:(NSString *)title;

@end

@interface LKStepView ()

@property (nonatomic ,strong) UIButton * minusButton;

@property (nonatomic ,strong) UIButton * addButton;
@end

@implementation LKStepView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.minusButton = [UIButton stepButtonTitle:@"-"];
        self.minusButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [self.minusButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.value -= 1;
            if (self.value >= self.minValue) {
                
                [self.valueButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.value]
                                  forState:UIControlStateNormal];
            }

            if (self.value == self.minValue && self.bReachMinValueHandle) {
                self.bReachMinValueHandle(self.minValue);
            }
            
            if (self.bStepValueChangeHandle) {
                self.bStepValueChangeHandle(self.value ,NO);
            }
        }];
        [self addSubview:self.minusButton];
        
        self.valueButton = [UIButton stepButtonTitle:[NSString stringWithFormat:@"%ld",(long)self.value]];
        self.valueButton.userInteractionEnabled = NO;
        [self addSubview:self.valueButton];
        
        self.addButton = [UIButton stepButtonTitle:@"+"];
        self.addButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [self.addButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.value += 1;
            if (self.value <= self.maxValue) {
                [self.valueButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.value]
                                  forState:UIControlStateNormal];
            }
            
            if (self.value == self.maxValue && self.bReachMaxValueHandle) {
                self.bReachMaxValueHandle(self.maxValue);
            }
            
            if (self.bStepValueChangeHandle) {
                self.bStepValueChangeHandle(self.value ,YES);
            }
        }];
        [self addSubview:self.addButton];
        
        self.minValue = 0;
        self.maxValue = 100;
        self.value = 0;
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat height = 30;
    
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(height, height));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(height, height));
    }];
    
    [self.valueButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.addButton.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(self.minusButton.mas_right).mas_offset(5);
    }];
}

- (void)setValue:(NSInteger)value{

    _value = value;
    
    self.minusButton.enabled = self.value > self.minValue;
    self.addButton.enabled = self.value < self.maxValue;
    
    [self.valueButton setTitle:[NSString stringWithFormat:@"%ld",(long)value]
                      forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

@end

@implementation UIButton (StepButton)

+ (UIButton *) stepButtonTitle:(NSString *)title{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderColor = BM_Color_SeparatorColor.CGColor;
    button.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    button.layer.cornerRadius = 3.0f;
    button.layer.masksToBounds = YES;
    [button setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
    [button setTitleColor:BM_Color_SeparatorColor forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return button;
}

@end
