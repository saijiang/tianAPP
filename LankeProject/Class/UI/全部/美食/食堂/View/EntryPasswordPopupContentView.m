//
//  EntryPasswordPopupContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/29.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "EntryPasswordPopupContentView.h"

@interface EntryPasswordPopupContentView ()

@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) UITextField * inputTextField;




@end

@implementation EntryPasswordPopupContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UnityLHClass masonryLabel:@"提示" font:17 color:[UIColor whiteColor]];
        _titleLabel.backgroundColor = BM_Color_Blue;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.placeholder = @"请输入支付密码";
        _inputTextField.layer.cornerRadius = 5.0f;
        _inputTextField.font = [UIFont systemFontOfSize:15];
        UIView * leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 20, 20);
        _inputTextField.leftView = leftView;
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.textColor = BM_Color_BlackColor;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _inputTextField.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _inputTextField.secureTextEntry = YES;
        [self addSubview:_inputTextField];
        
        _commitButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitButton];
        
        _cancelButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self closePopup];
        }];
        [_cancelButton hll_setBackgroundImageWithHexString:@"cbcbcb" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.inputTextField.mas_left);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH / 4);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.inputTextField.mas_bottom).mas_offset(20);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.commitButton.mas_top);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH / 4);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) commitButtonHandle:(UIButton *)button{
    
    if (self.bSureHandle) {
        
        self.bSureHandle(self.inputTextField.text);
    }
    
    [self closePopup];
}


#pragma mark -
#pragma mark PopupContentViewDelegate

- (CGRect)showRect{
    
    CGFloat height = 0.0f;
    height += 50;
    height += 20;
    height += 45.0f;
    height += 20.0f;
    height += 45.0f;
    height += 20;
    
    return CGRectMake(50, (DEF_SCREEN_HEIGHT - height) / 2, DEF_SCREEN_WIDTH - 100, height);
}

// YES：击返回空的区域
- (BOOL)isAlert
{
    return NO;
}

@end
