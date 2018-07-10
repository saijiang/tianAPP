//
//  ChangePhoneNumberSecondViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ChangePhoneNumberSecondViewController.h"
#import "LKTextField.h"
#import "TimerButton.h"
#import "LKBottomButton.h"

@interface ChangePhoneNumberSecondViewController ()
{
    id msgId;
}

@property (nonatomic ,strong) LKTextField * phoneTetField;
@property (nonatomic ,strong) LKTextField * codeTextField;
@property (nonatomic ,strong) TimerButton * codeButton;

@end

@implementation ChangePhoneNumberSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更改绑定手机号
    self.title = @"更改绑定手机号";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self creatUI];
    
}

- (void) creatUI{
    
    self.phoneTetField = [LKTextField whiteTextFieldWithLeftImage:@"leftView_iphone"];
    self.phoneTetField.cornerRadius = 5.0f;
    self.phoneTetField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTetField configTextFieldForLoginAndRegistWithPlaceholder:@"请输入绑定的手机号码(11位)"];
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
    
    //按钮
    UIButton *nextBtn = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"完成绑定" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(finishModifyPhoneNumberHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(50);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.phoneTetField.mas_left);
        make.right.mas_equalTo(self.phoneTetField.mas_right);
    }];
    
}
#pragma mark -
#pragma mark Action M

- (void) getCodeBtnClick:(TimerButton *)button
{
    if ([UnityLHClass checkTel:self.phoneTetField.text])
    {
        [UserServices
         sendAuthCodeWithMobileNum:self.phoneTetField.text
         type:@"3"
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
    else
    {
        [UnityLHClass showHUDWithStringAndTime:self.phoneTetField.placeholder];
    }
    
}

- (void) finishModifyPhoneNumberHandle
{
    if (![UnityLHClass checkTel:self.phoneTetField.text])
    {
        [UnityLHClass showHUDWithStringAndTime:self.phoneTetField.placeholder];

    }
    else if (self.codeTextField.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:self.codeTextField.placeholder];

    }
    else
    {
        [UserServices
         updateMobileNumWithuserId:[KeychainManager readUserId]
         mobileNum:self.phoneTetField.text
         msgId:msgId
         authCode:self.codeTextField.text
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 [UnityLHClass showHUDWithStringAndTime:@"完成绑定"];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
    }
    
}
@end
