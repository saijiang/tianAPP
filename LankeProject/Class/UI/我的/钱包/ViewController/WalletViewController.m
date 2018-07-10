//
//  WalletViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "WalletViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "ModyPasswordViewController.h"
#import "ExpenseViewController.h"
@interface WalletViewController ()
{
    UILabel *moneyLB;
}
@property (nonatomic ,strong) UIButton *passwordBtn;
@end

@implementation WalletViewController

-(void)getWalletBalance
{
    [UserServices
     getWalletBalanceWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             moneyLB.text=[NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"WalletBalance"] floatValue]];
             
             if ([responseObject[@"data"][@"isPwd"] integerValue] == 0) {// 0是设置密码 1是修改密码
                 [self.passwordBtn setTitle:@"设置支付密码" forState:UIControlStateNormal];
             }else{
                 [self.passwordBtn setTitle:@"修改支付密码" forState:UIControlStateNormal];
             }
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"i币"];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getWalletBalance];
}

- (void)initUI
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = BM_WHITE;
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    UIImageView *walletIcon = [[UIImageView alloc] init];
    walletIcon.image = [UIImage imageNamed:@"Wallet-icon"];
    [self.view addSubview:walletIcon];
    
    moneyLB = [UnityLHClass masonryLabel:@"0.00" font:23.0 color:[UIColor colorWithRed:0.99 green:0.6 blue:0.15 alpha:1]];
    moneyLB.textAlignment = NSTextAlignmentCenter;
    [moneyLB setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0]];
    [self.view addSubview:moneyLB];
    
    
    UILabel *titleLB = [UnityLHClass masonryLabel:@"当前余额" font:13.0 color:[UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:1]];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    
    [walletIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.top.mas_equalTo(topView.mas_top).offset(20);
        make.width.and.height.offset(50);
    }];
    
    [moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.top.mas_equalTo(walletIcon.mas_bottom).offset(10);
    }];
    
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.top.mas_equalTo(moneyLB.mas_bottom).offset(10);
    }];

    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.left.and.right.offset(0);
        make.bottom.mas_equalTo(titleLB.mas_bottom).offset(20);
    }];
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = BM_WHITE;
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    UIButton *passwordBtn = [[UIButton alloc] init];
    [passwordBtn addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBtn setImage:[UIImage imageNamed:@"Wallet-password"] forState:UIControlStateNormal];
    [passwordBtn setTitle:@"设置支付密码" forState:UIControlStateNormal];
    [passwordBtn setTitleColor:BM_BLACK forState:UIControlStateNormal];
    passwordBtn.titleLabel.font = BM_FONTSIZE12;
    passwordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [bottomView addSubview:passwordBtn];
    self.passwordBtn = passwordBtn;
    
    
    UIButton *expenseBtn = [[UIButton alloc] init];
    [expenseBtn addTarget:self action:@selector(expenseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [expenseBtn setImage:[UIImage imageNamed:@"Wallet-info"] forState:UIControlStateNormal];
    [expenseBtn setTitleColor:BM_BLACK forState:UIControlStateNormal];
    [expenseBtn setTitle:@"消费记录" forState:UIControlStateNormal];
    expenseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    expenseBtn.titleLabel.font = BM_FONTSIZE12;
    [bottomView addSubview:expenseBtn];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(topView.mas_bottom).offset(15);
    }];
    
    [passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.5);
        make.top.and.bottom.offset(0);
        make.left.offset(0);
    }];
    [passwordBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    
    [expenseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.5);
        make.top.and.bottom.offset(0);
        make.left.mas_equalTo(passwordBtn.mas_right);
    }];
    [expenseBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    
    [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(topView.mas_bottom).offset(15);
        make.height.offset(70);
    }];
}

#pragma mark - 密码
- (void)passwordAction:(UIButton *)sender
{
    ModyPasswordViewController *password = [[ModyPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:password animated:YES];
}

#pragma mark - 消费记录
- (void)expenseBtnAction:(UIButton *)sender
{
    ExpenseViewController *expen = [[ExpenseViewController alloc] init];
    [self.navigationController pushViewController:expen animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
