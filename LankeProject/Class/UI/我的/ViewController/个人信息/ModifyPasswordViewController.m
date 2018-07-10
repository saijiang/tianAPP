//
//  ModifyPasswordViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "LKTextField.h"
#import "TimerButton.h"
#import "LKBottomButton.h"

@interface ModifyPasswordViewController ()
{
    id msgId;
}

@property (nonatomic ,strong) LKTextField * codeTextField;
@property (nonatomic ,strong) TimerButton * codeButton;

@property (nonatomic ,strong) LKTextField * passwordTetField;
@property (nonatomic ,strong) LKTextField * rePasswordTextField;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更改密码
    self.title = @"更改密码";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self creatUI];
    
}

- (void) creatUI{
    
    TimerButton * codeBtn = [[TimerButton alloc] init];
    codeBtn.time = 60;
    codeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [codeBtn setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    codeBtn.titleLabel.font = BM_FONTSIZE15;
    codeBtn.layer.cornerRadius = 5.0f;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn hll_setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:codeBtn];
    
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.width.mas_equalTo(100);
    }];
    
    self.codeTextField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_dial"];
    self.codeTextField.cornerRadius = 5.0f;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeTextField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入短信验证码"];
    [self addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(codeBtn.mas_top);
        make.height.mas_equalTo(codeBtn.mas_height);
        make.right.mas_equalTo(codeBtn.mas_left).mas_offset(-10);
    }];
    
    UILabel * displayLabel = [UnityLHClass masonryLabel:@"(系统会向当前绑定的手机发送验证码)" font:13 color:[UIColor colorWithHexString:@"#9A9A9A"]];
    [self addSubview:displayLabel];
    [displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTextField.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.codeTextField.mas_left).mas_offset(15);
    }];
    
    self.passwordTetField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.passwordTetField.secureTextEntry=YES;
    self.passwordTetField.cornerRadius = 5.0f;
    //    self.passwordTetField.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordTetField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入新密码(6-20个字符)"];
    [self addSubview:self.passwordTetField];
    [self.passwordTetField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(displayLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(self.codeTextField.mas_height);
        make.left.mas_equalTo(self.codeTextField.mas_left);
        make.right.mas_equalTo(codeBtn.mas_right);
    }];
    
    self.rePasswordTextField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.rePasswordTextField.cornerRadius = 5.0f;
    self.rePasswordTextField.secureTextEntry=YES;

    //    self.rePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.rePasswordTextField configTextFieldForLoginAndRegistWithPlaceholder:@"请再次输入新密码"];
    [self addSubview:self.rePasswordTextField];
    [self.rePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.passwordTetField.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.passwordTetField.mas_left);
        make.height.mas_equalTo(self.passwordTetField.mas_height);
        make.right.mas_equalTo(self.passwordTetField.mas_right);
    }];
    
    //按钮
    UIButton *nextBtn = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(finishModifyPasswordHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rePasswordTextField.mas_bottom).offset(50);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.rePasswordTextField.mas_left);
        make.right.mas_equalTo(self.rePasswordTextField.mas_right);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) getCodeBtnClick:(TimerButton *)button
{
    [UserServices
     sendAuthCodeWithMobileNum:[KeychainManager readMobileNum]
     type:@"2"
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            msgId=responseObject[@"data"];
            [button startTimer];
 
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    
    
}

- (void) finishModifyPasswordHandle
{
    if (self.codeTextField.text==0)
    {
        [UnityLHClass showHUDWithStringAndTime:self.codeTextField.placeholder];
    }
    else if (self.passwordTetField.text.length<6 || self.passwordTetField.text.length>20)
    {
        [UnityLHClass showHUDWithStringAndTime:self.passwordTetField.placeholder];

    }
    else if (self.rePasswordTextField.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请输入新密码"];

    }
    else if (![self.rePasswordTextField.text isEqualToString:self.passwordTetField.text])
    {
        [UnityLHClass showHUDWithStringAndTime:@"两次输入密码不一致，请重新输入"];
        
    }
    else
    {
        [UserServices getBackPasswordWithMobileNum:[KeychainManager readMobileNum] newPassword:self.passwordTetField.text confirmPassword:self.rePasswordTextField.text authCode:self.codeTextField.text msgId:msgId completionBlock:^(int result, id responseObject) {
            
             if (result==0)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
}

@end
