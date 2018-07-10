//
//  RegistFirstViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RegistFirstViewController.h"
#import "RegistSecondViewController.h"
#import "LKTextField.h"
#import "TimerButton.h"
#import "LKBottomButton.h"

@interface RegistFirstViewController ()

@property (nonatomic ,strong) LKTextField * phoneTetField;
@property (nonatomic ,strong) LKTextField * codeTextField;
@property (nonatomic ,strong) TimerButton * codeButton;

@property (nonatomic ,strong) NSString * messageID;

@end

@implementation RegistFirstViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 注册
    self.navigationItem.title = @"注册";
    
    [self creatUI];
    
}

- (void) creatUI{
    
    self.phoneTetField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_iphone"];
    self.phoneTetField.cornerRadius = 5.0f;
    self.phoneTetField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTetField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入您的手机号"];
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
    
    
    //下一步按钮
    UIButton *nextBtn = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(navigationToRegistNext) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(50);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.phoneTetField.mas_left);
        make.right.mas_equalTo(self.phoneTetField.mas_right);
    }];

}

- (BOOL) verifyPhoneNumberForGetAuthCode{
    
    if ([UnityLHClass checkTel:self.phoneTetField.text]){
        return YES;
    }else{
        [UnityLHClass showHUDWithStringAndTime:@"请输入正确的手机号"];
        return NO;
    }
}

- (BOOL) verifyAuthCodeForRegist{

    if (self.codeTextField.text.length > 0){
        return YES;
    }else{
        [UnityLHClass showHUDWithStringAndTime:@"请输入验证码"];
        return NO;
    }
}
#pragma mark -
#pragma mark Action M

- (void) getCodeBtnClick:(TimerButton *)button{

    if ([self verifyPhoneNumberForGetAuthCode]) {
        NSString * phoneNumber = self.phoneTetField.text;
        [UserServices sendAuthCodeWithMobileNum:phoneNumber type:@"1" completionBlock:^(int result, id responseObject) {
            
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

- (void) navigationToRegistNext{
    
    if ([self verifyAuthCodeForRegist]) {
        
        [UserServices nextStepWithMsgId:self.messageID authCode:self.codeTextField.text completionBlock:^(int result, id responseObject) {
           
            if (result == 0) {// 这里约定1为成功，其余地方还是0为成功
                
                RegistSecondViewController * nextRegist = [[RegistSecondViewController alloc] init];
                nextRegist.phoneNumber = self.phoneTetField.text;
                [self.navigationController pushViewController:nextRegist animated:YES];
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
}
@end
