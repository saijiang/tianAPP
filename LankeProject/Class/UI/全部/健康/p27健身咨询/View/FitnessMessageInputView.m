//
//  FitnessMessageInputView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessMessageInputView.h"

@implementation FitnessMessageInputView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    
        [self addSubview:self.textInputView];
    
        [self addSubview:self.sendBtn];
        
    }
    return self;
}

- (void)dealloc{
}

- (UIButton*) sendBtn{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 5.0f;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.tag = 101010;
        [self addSubview:_sendBtn];
        
    }
    return _sendBtn;
}

-(UITextView*) textInputView{
    if (_textInputView == nil) {
        _textInputView = [[UITextView alloc] init];
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textInputView.scrollEnabled = YES;
        _textInputView.returnKeyType = UIReturnKeySend;
        _textInputView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _textInputView.delegate = self;
        _textInputView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _textInputView.layer.borderWidth = 0.65f;
        _textInputView.layer.cornerRadius = 6.0f;
        _textInputView.font = [UIFont systemFontOfSize:16];
//        _previousTextViewContentHeight = [self getTextViewContentH:_textInputView];
        CGFloat kDefaultMargin = 20;
        _textInputView.textContainerInset = UIEdgeInsetsMake(kDefaultMargin/4, kDefaultMargin/4, 0, kDefaultMargin/4);
        [self addSubview:_textInputView];
    }
    return _textInputView;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.textInputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        make.right.mas_equalTo(self.mas_right).mas_offset(-100);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.textInputView.mas_centerY);
        make.left.mas_equalTo(self.textInputView.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.height.mas_equalTo(35);
    }];
}

- (void)btnAction:(id)sender{
    
//    [self.textInputView resignFirstResponder];
    
    if (self.textInputView.text.length && self.bSendHandle) {
        self.bSendHandle(self.textInputView.text);
    }
    
    self.textInputView.text = @"";
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
//    self.audioBtn.selected = NO;
//    textView.inputView = self;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"])
//    {
//        if ([self.delegate respondsToSelector:@selector(sendText:)])
//        {
//            [self.delegate sendText:textView.text];
//            self.textInputView.text = @"";
//            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.textInputView]];
//        }
//        
//        return NO;
//    }
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView
{
//    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

- (BOOL)endEditing:(BOOL)force{
    [super endEditing:force];
    self.textInputView.text = @"";
    [self.textInputView resignFirstResponder];
    return YES;
}

+ (instancetype)view{

    return [[FitnessMessageInputView alloc] init];
}
@end
