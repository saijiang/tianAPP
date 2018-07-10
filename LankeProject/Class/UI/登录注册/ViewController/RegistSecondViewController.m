//
//  RegistSecondViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RegistSecondViewController.h"
#import "ProtocolViewController.h"
#import "LKTextField.h"
#import "TimerButton.h"
#import "LKBottomButton.h"

@interface RegistSecondViewController ()

@property (nonatomic ,strong) LKTextField * passwordTetField;
@property (nonatomic ,strong) LKTextField * rePasswordTextField;
@property (nonatomic ,strong) LKTextField * nickNameTextField;

@property (nonatomic ,strong) UIButton * agreeButton;
@property (nonatomic ,strong) UIButton * finishButton;
@end

@implementation RegistSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 注册
    self.title = @"注册";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];

    [self creatUI];
}

- (void) creatUI{
    
    self.passwordTetField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.passwordTetField.cornerRadius = 5.0f;
    self.passwordTetField.secureTextEntry = YES;
//    self.passwordTetField.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordTetField configTextFieldForLoginAndRegistWithPlaceholder:@"请设置6-20位登录密码"];
    [self addSubview:self.passwordTetField];
    [self.passwordTetField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
    }];
    
    self.rePasswordTextField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.rePasswordTextField.cornerRadius = 5.0f;
    self.rePasswordTextField.secureTextEntry = YES;
//    self.rePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.rePasswordTextField configTextFieldForLoginAndRegistWithPlaceholder:@"请再次输入密码"];
    [self addSubview:self.rePasswordTextField];
    [self.rePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.passwordTetField.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.passwordTetField.mas_left);
        make.height.mas_equalTo(self.passwordTetField.mas_height);
        make.right.mas_equalTo(self.passwordTetField.mas_right);
    }];
    
    self.nickNameTextField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_suo"];
    self.nickNameTextField.cornerRadius = 5.0f;
    [self.nickNameTextField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入昵称"];
    [self addSubview:self.nickNameTextField];
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.rePasswordTextField.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.rePasswordTextField.mas_left);
        make.height.mas_equalTo(self.rePasswordTextField.mas_height);
        make.right.mas_equalTo(self.rePasswordTextField.mas_right);
    }];

    
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeButton setImage:[UIImage imageNamed:@"no_choose"] forState:UIControlStateNormal];
    [self.agreeButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [self.agreeButton addTarget:self action:@selector(agressRegistProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeButton setTitle:@" 我同意" forState:UIControlStateNormal];
    self.agreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.agreeButton];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.nickNameTextField.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.nickNameTextField.mas_left).mas_offset(10);
    }];
    
    UIButton * protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolButton setTitle:@"《注册协议》" forState:UIControlStateNormal];
    [protocolButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    [protocolButton addTarget:self action:@selector(navigationToProtocol) forControlEvents:UIControlEventTouchUpInside];
    protocolButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:protocolButton];
    [protocolButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.agreeButton.mas_centerY);
        make.left.mas_equalTo(self.agreeButton.mas_right).mas_offset(5);
        make.height.mas_equalTo(30);
    }];
    
    //下一步按钮
    UIButton *nextBtn = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(finishRegistHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocolButton.mas_bottom).offset(50);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.passwordTetField.mas_left);
        make.right.mas_equalTo(self.passwordTetField.mas_right);
    }];
    self.finishButton = nextBtn;

}

- (BOOL) verifyPassword{
    
    if (self.passwordTetField.text && self.passwordTetField.text && [self.passwordTetField.text isEqualToString:self.rePasswordTextField.text] && self.passwordTetField.text.length >= 6 && self.passwordTetField.text.length <= 20& self.nickNameTextField.text.length >0)
    {
        return YES;
    }
    if (self.nickNameTextField.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请输入昵称"];

    }
    else
    {
        [UnityLHClass showHUDWithStringAndTime:@"请输入正确的密码"];

    }

    return NO;
}

#pragma mark -
#pragma mark Action M

- (void) agressRegistProtocol:(UIButton *)button{

    self.agreeButton.selected = !self.agreeButton.isSelected;
    
    self.finishButton.enabled = self.agreeButton.isSelected;
}

- (void) finishRegistHandle{
    
    if ([self verifyPassword]) {
        
        [UserServices
         registerWithUserAccount:self.phoneNumber
         userPassword:self.passwordTetField.text
         confirmPassword:self.rePasswordTextField.text
         registrationId:[JPUSHService registrationID]
         nickName:self.nickNameTextField.text
         completionBlock:^(int result, id responseObject)
        {
           
            if (result == 0)
            {
                
                id data = responseObject[@"data"];
                // 进入app首页
                UserInfo_Preferences * userInfo = [UserInfo_Preferences sharedInstance];
                userInfo.loginState = YES;
                userInfo.password = self.passwordTetField.text;
                userInfo.userId = data[@"userId"];
                userInfo.phoneNumber = data[@"mobileNum"];
                userInfo.loginInfo = self.phoneNumber;
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
    
}

- (void) navigationToProtocol{
    
    // 跳转至用户协议
    ProtocolViewController * protocol = [[ProtocolViewController alloc] init];
    [self.navigationController pushViewController:protocol animated:YES];
}
@end
