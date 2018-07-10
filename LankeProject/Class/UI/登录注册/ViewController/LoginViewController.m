//
//  LoginViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistFirstViewController.h"
#import "ForgetPasswordViewController.h"
#import "LKTextField.h"
#import "JPUSHService.h"

@interface UIButton (CornerRadius)
- (void) configButtonCornerRadius:(CGFloat)cornerRadius;
- (void) configTitle:(NSString *)title withFontSize:(CGFloat)fontSize;
@end
@interface LoginViewController ()

@property (nonatomic ,strong) LKTextField * phoneTextField;
@property (nonatomic ,strong) LKTextField * passwordTextField;

@end

@implementation LoginViewController

- (BOOL)hidenNavigationBar{

    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

- (void) creatUI{
    
    LocalhostImageView * backgroundImage = [[LocalhostImageView alloc] init];
    backgroundImage.image = [UIImage imageNamed:@"login_bg"];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:backgroundImage];
    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    UIImageView * loginImageView = [[UIImageView alloc] init];
    loginImageView.image = [UIImage imageNamed:@"login_logo"];
    loginImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:loginImageView];
    [loginImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UIImageView * sloganImageView = [[UIImageView alloc] init];
    sloganImageView.image = [UIImage imageNamed:@"login_slogan"];
    sloganImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:sloganImageView];
    [sloganImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(loginImageView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.centerX.mas_equalTo(loginImageView.mas_centerX);
    }];
    
    UIImageView * contentBackgroundImageView = [[UIImageView alloc] init];
    contentBackgroundImageView.image = [UIImage imageWithColor:[UIColor colorWithWhite:0. alpha:0.2]];
    contentBackgroundImageView.userInteractionEnabled = YES;
    [self addSubview:contentBackgroundImageView];
    {
        UserInfo_Preferences * userInfo = [UserInfo_Preferences sharedInstance];
        
        self.phoneTextField = [[LKTextField alloc] init];
        self.phoneTextField.text = userInfo.loginInfo;
        
        self.phoneTextField.leftImage = [UIImage imageNamed:@"login_iphone"];
        [self.phoneTextField configTextFieldForLogin:@"请输入您的手机号/员工工号"];
        [contentBackgroundImageView addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(contentBackgroundImageView).mas_offset(-40);
            make.top.mas_equalTo(30);
            make.height.mas_equalTo(40);
        }];
        
        UIView * phoneLineView = [[UIView alloc] init];
        phoneLineView.backgroundColor = [UIColor colorWithHexString:@"BBC2CC"];
        [contentBackgroundImageView addSubview:phoneLineView];
        [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(self.phoneTextField.mas_left).mas_offset(10);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.right.mas_equalTo(self.phoneTextField.mas_right);
            make.bottom.mas_equalTo(self.phoneTextField.mas_bottom);
        }];
        
        UIButton * forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetPasswordButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [forgetPasswordButton addTarget:self action:@selector(navigationToForgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [contentBackgroundImageView addSubview:forgetPasswordButton];
        [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(self.phoneTextField.mas_right);
            make.height.mas_equalTo(self.phoneTextField.mas_height);
            make.width.mas_equalTo(80);
            make.top.mas_equalTo(self.phoneTextField.mas_bottom).mas_offset(15);
        }];
        
        self.passwordTextField = [[LKTextField alloc] init];
        self.passwordTextField.secureTextEntry=YES;
        self.passwordTextField.leftImage = [UIImage imageNamed:@"login_suo"];
        [self.passwordTextField configTextFieldForLogin:@"请输入您的密码"];
        [contentBackgroundImageView addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(self.phoneTextField.mas_left);
            make.right.mas_equalTo(forgetPasswordButton.mas_left).mas_equalTo(-10);
            make.top.mas_equalTo(forgetPasswordButton.mas_top);
            make.height.mas_equalTo(self.phoneTextField.mas_height);
        }];
        
        UIView * passwordLineView = [[UIView alloc] init];
        passwordLineView.backgroundColor = [UIColor colorWithHexString:@"BBC2CC"];
        [contentBackgroundImageView addSubview:passwordLineView];
        [passwordLineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(phoneLineView.mas_left);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.right.mas_equalTo(phoneLineView.mas_right);
            make.bottom.mas_equalTo(self.passwordTextField.mas_bottom);
        }];
        
        UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton addTarget:self action:@selector(loginHandle) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loginButton configButtonCornerRadius:25];
        [loginButton hll_setBackgroundImageWithHexString:@"ffffff" forState:UIControlStateNormal];
        [contentBackgroundImageView addSubview:loginButton];
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.phoneTextField.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.phoneTextField.mas_right);
            make.height.mas_equalTo(50);
        }];
        
        UIButton * unRegistButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [unRegistButton addTarget:self action:@selector(navigationToUnregistered) forControlEvents:UIControlEventTouchUpInside];
        [unRegistButton configTitle:@"随便看看" withFontSize:15];
        [unRegistButton configButtonCornerRadius:20];
        [unRegistButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [unRegistButton hll_setBackgroundImageWithHexString:@"#7898AF" forState:UIControlStateNormal];
        [contentBackgroundImageView addSubview:unRegistButton];
        [unRegistButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(loginButton.mas_bottom).mas_offset(30);
            make.left.mas_equalTo(loginButton.mas_left);
            make.width.mas_equalTo(loginButton.mas_width).multipliedBy(0.45);
            make.height.mas_equalTo(40);
        }];
        
        UIButton * registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [registButton addTarget:self action:@selector(navigationToRegist) forControlEvents:UIControlEventTouchUpInside];
        [registButton configTitle:@"注册" withFontSize:15];
        [registButton configButtonCornerRadius:20];
        [registButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [registButton hll_setBackgroundImageWithHexString:@"#67B0D9" forState:UIControlStateNormal];
        [contentBackgroundImageView addSubview:registButton];
        [registButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(unRegistButton.mas_top);
            make.width.mas_equalTo(unRegistButton.mas_width);
            make.right.mas_equalTo(loginButton.mas_right);
            make.height.mas_equalTo(unRegistButton.mas_height);
        }];
        
        [contentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(sloganImageView.mas_bottom).mas_offset(20);
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(registButton.mas_bottom).mas_offset(40);
        }];
    }
}
- (BOOL) verifyLogin{
    
    if (self.passwordTextField.text.length > 0)
    {
        return YES;
    }
    else
    {
        [UnityLHClass showHUDWithStringAndTime:@"请输入密码"];
        return NO;
    }
}

#pragma mark -
#pragma mark Action M

- (void) loginHandle{
    
    [self.view endEditing:YES];
    
    if ([self verifyLogin]) {
        
        [UserServices loginWithUserAccount:self.phoneTextField.text userPassword:self.passwordTextField.text registrationId:[JPUSHService registrationID] completionBlock:^(int result, id responseObject) {
            
            if (result == 0)
            {
                id data = responseObject[@"data"];
                
                UserInfo_Preferences * userInfo = [UserInfo_Preferences sharedInstance];
                userInfo.loginState = YES;
                userInfo.password = self.passwordTextField.text;
                userInfo.userName = data[@"userName"];
                userInfo.userId = data[@"userId"];
                userInfo.phoneNumber = data[@"mobileNum"];
                userInfo.employeeNumber = data[@"employeeNum"];
                userInfo.loginInfo = self.phoneTextField.text;
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^(){
                }];
                
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
}

- (void) navigationToUnregistered{
    
    [self.view endEditing:YES];
    
    // 跳转至首页，没有注册的用户
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        [self.topViewController.navigationController popToRootViewControllerAnimated:NO];
        KAPPDELEGATE.tabBar.selectedIndex=0;
    }];
}

- (void) navigationToRegist{
    
    [self.view endEditing:YES];
    
    RegistFirstViewController * regist = [[RegistFirstViewController alloc] init];
    
    [self.navigationController pushViewController:regist animated:YES];
}

- (void) navigationToForgetPassword{
    
    [self.view endEditing:YES];
    
    // 跳转至忘记密码
    ForgetPasswordViewController * forgetPassword = [[ForgetPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:forgetPassword animated:YES];
}
@end

@implementation UIButton (CornerRadius)

- (void)configButtonCornerRadius:(CGFloat)cornerRadius{

    if (cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }
}
- (void) configTitle:(NSString *)title withFontSize:(CGFloat)fontSize{

    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}
@end
