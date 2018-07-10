//
//  ForgetPasswordViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LKTextField.h"
#import "TimerButton.h"
#import "LKBottomButton.h"

@interface ForgetPasswordViewController ()

@property (nonatomic ,strong) LKTextField * phoneTetField;
@property (nonatomic ,strong) LKTextField * codeTextField;
@property (nonatomic ,strong) TimerButton * codeButton;

@property (nonatomic ,strong) LKTextField * passwordTetField;
@property (nonatomic ,strong) LKTextField * rePasswordTextField;

@property (nonatomic ,strong) UIButton * finishButton;

@property (nonatomic ,strong) NSString * messageID;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 忘记密码
    self.title = @"忘记密码";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self creatUI];
}


- (void) creatUI{
    
    self.phoneTetField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_iphone"];
    self.phoneTetField.cornerRadius = 5.0f;
    self.phoneTetField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTetField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入绑定的手机号(11位)"];
    [self addSubview:self.phoneTetField];
    [self.phoneTetField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
    }];
    
    
    TimerButton * codeBtn = [[TimerButton alloc] init];
    codeBtn.time = 60;
    codeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [codeBtn setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    [codeBtn hll_setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.titleLabel.font = BM_FONTSIZE15;
    codeBtn.layer.cornerRadius = 5.0f;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn hll_setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:codeBtn];
    
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.phoneTetField.mas_right);
        make.height.mas_equalTo(self.phoneTetField.mas_height);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(self.phoneTetField.mas_bottom).mas_offset(15);
    }];
    
    self.codeTextField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_dial"];
    self.codeTextField.cornerRadius = 5.0f;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeTextField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入短信验证码"];
    [self addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(codeBtn.mas_top);
        make.left.mas_equalTo(self.phoneTetField.mas_left);
        make.height.mas_equalTo(self.phoneTetField.mas_height);
        make.right.mas_equalTo(codeBtn.mas_left).mas_offset(-10);
    }];
    
    self.passwordTetField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.passwordTetField.cornerRadius = 5.0f;
    self.passwordTetField.secureTextEntry = YES;
    //    self.passwordTetField.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordTetField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入新密码(6-20个字符)"];
    [self addSubview:self.passwordTetField];
    [self.passwordTetField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.codeTextField.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(self.phoneTetField.mas_height);
        make.left.mas_equalTo(self.phoneTetField.mas_left);
        make.right.mas_equalTo(self.phoneTetField.mas_right);
    }];
    
    self.rePasswordTextField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.rePasswordTextField.cornerRadius = 5.0f;
    self.rePasswordTextField.secureTextEntry = YES;
    //    self.rePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.rePasswordTextField configTextFieldForLoginAndRegistWithPlaceholder:@"请再次输入新密码"];
    [self addSubview:self.rePasswordTextField];
    [self.rePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.passwordTetField.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.passwordTetField.mas_left);
        make.height.mas_equalTo(self.passwordTetField.mas_height);
        make.right.mas_equalTo(self.passwordTetField.mas_right);
    }];
    
    //下一步按钮
    UIButton *nextBtn = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(finishForgetPasswordHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rePasswordTextField.mas_bottom).offset(50);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.passwordTetField.mas_left);
        make.right.mas_equalTo(self.passwordTetField.mas_right);
    }];
    self.finishButton = nextBtn;
}

- (BOOL) verifyPhoneNumberForGetAuthCode{
    
    if ([UnityLHClass checkTel:self.phoneTetField.text]){
        return YES;
    }
    
    [UnityLHClass showHUDWithStringAndTime:@"请输入正确的手机号"];
    return NO;
}
- (BOOL) verifyPassword{
    
    if (self.passwordTetField.text && self.passwordTetField.text && [self.passwordTetField.text isEqualToString:self.rePasswordTextField.text] && self.passwordTetField.text.length >= 6 && self.passwordTetField.text.length <= 20)
    {
        return YES;
    }
    [UnityLHClass showHUDWithStringAndTime:@"请输入正确的密码"];
    return NO;
}
#pragma mark -
#pragma mark Action M

- (void) getCodeBtnClick:(TimerButton *)button{
    
    if ([self verifyPhoneNumberForGetAuthCode]) {
        
        NSString * phoneNumber = self.phoneTetField.text;
        [UserServices sendAuthCodeWithMobileNum:phoneNumber type:@"2" completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                
                [button startTimer];
                id data = responseObject[@"data"];
                self.messageID = [NSString stringWithFormat:@"%@",data];
                
            }else{
                
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
    
}
- (void) finishForgetPasswordHandle{
    
    if ([self verifyPassword]) {
        
        [UserServices getBackPasswordWithMobileNum:self.phoneTetField.text newPassword:self.passwordTetField.text confirmPassword:self.rePasswordTextField.text authCode:self.codeTextField.text msgId:self.messageID completionBlock:^(int result, id responseObject) {
           
            if (result == 0) {

                [UnityLHClass showHUDWithStringAndTime:@"修改密码成功"];
                // 退到登录界面
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                // error hadle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
}
@end
