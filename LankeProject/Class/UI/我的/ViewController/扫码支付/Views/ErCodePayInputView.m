//
//  ErCodePayInputView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ErCodePayInputView.h"

@interface ErCodePayInputView ()<UITextFieldDelegate>

@property (nonatomic ,strong) UILabel * displayLabe;
@property (nonatomic ,strong) UILabel * $Label;
@property (nonatomic ,strong) UITextField * inpputTextField;

@property (nonatomic ,strong) UIView * lineView;


@end

@implementation ErCodePayInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabe = [UnityLHClass masonryLabel:@"金额" font:15 color:BM_BLACK];
        [self addSubview:self.displayLabe];
        
        self.$Label = [UnityLHClass masonryLabel:@"￥" font:23 color:BM_BLACK];
        [self addSubview:self.$Label];
        
        self.inpputTextField = [[UITextField alloc] init];
        self.inpputTextField.placeholder = @"";
        self.inpputTextField.font = [UIFont systemFontOfSize:40];
        self.inpputTextField.delegate = self;
        self.inpputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.inpputTextField addTarget:self action:@selector(inputEditing:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.inpputTextField];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self addSubview:self.lineView];
        
        self.payButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
        self.payButton.enabled = NO;
        [self.payButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.inpputTextField resignFirstResponder];
            if (self.bPayHandle) {
                self.bPayHandle();
            }
        }];
        [self addSubview:self.payButton];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.displayLabe mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    [self.$Label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.displayLabe.mas_left);
        make.top.mas_equalTo(self.displayLabe.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.inpputTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.$Label.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.$Label.mas_top);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.displayLabe.mas_left);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.top.mas_equalTo(self.inpputTextField.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.inpputTextField.mas_right);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.displayLabe.mas_left);
        make.right.mas_equalTo(self.inpputTextField.mas_right);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(20);
    }];
}

+ (instancetype)view{

    return [[self alloc] init];
}

- (void) inputEditing:(UITextField *)textField{
    
    self.payButton.enabled = textField.text.length;
}

- (void) inputViewBecomeFirstResponder{

    if (!self.inpputTextField.isEditing) {
        
        [self.inpputTextField becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
// 最多5位，
// 小数点后2位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // textField.text is `2`
    // replace is `.`
    // phone displayText is `2.`
    NSString * displayText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    NSInteger location = [displayText rangeOfString:@"."].location;

    if (location != NSNotFound) {// 有`.`
        return location != displayText.length - 4;
    }
    
    NSLog(@"text:%@",textField.text);
    NSLog(@"replacementString:%@",string);
    return textField.text.length <= 5 || string.length != 1;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    self.price = [textField.text floatValue];
}

@end
