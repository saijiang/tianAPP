//
//  ChangePhoneNumberFirstViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ChangePhoneNumberFirstViewController.h"
#import "ChangePhoneNumberSecondViewController.h"

#import "LKTextField.h"
#import "TimerButton.h"
#import "LKBottomButton.h"

@interface ChangePhoneNumberFirstViewController ()
{
    id msgId;
}

@property (nonatomic ,strong) LKTextField * codeTextField;
@property (nonatomic ,strong) TimerButton * codeButton;

@end

@implementation ChangePhoneNumberFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更改绑定手机号
    self.title = @"更改绑定手机号";
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
    [codeBtn hll_setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    
    //按钮
    UIButton *nextBtn = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"确认" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(navigationToModifyPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(displayLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.codeTextField.mas_left);
        make.right.mas_equalTo(codeBtn.mas_right);
    }];
    
}
#pragma mark -
#pragma mark Action M

- (void) getCodeBtnClick:(TimerButton *)button{
    
    [UserServices
     sendAuthCodeWithMobileNum:[KeychainManager readMobileNum]
     type:@"3"
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            msgId=responseObject[@"data"];
            [button startTimer];

        }

    }];
    
    
}

- (void) navigationToModifyPhoneNumber{
    
    if (self.codeTextField.text.length>0)
    {
        
        [UserServices
         nextStepWithMsgId:msgId
         authCode:self.codeTextField.text
         completionBlock:^(int result, id responseObject)
        {
            if (result==1)
            {
                // 跳转至完成绑定手机号
                ChangePhoneNumberSecondViewController * changePhoneNumber = [[ChangePhoneNumberSecondViewController alloc] init];
                [self.navigationController pushViewController:changePhoneNumber animated:YES];
            }
            else
            {
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
     
    }
    else
    {
        [UnityLHClass showHUDWithStringAndTime:self.codeTextField.placeholder];
    }

}

@end
