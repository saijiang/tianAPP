//
//  PropertyPayBillViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayBillViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "LKBottomButton.h"
#import "BookPopupContentView.h"
#import "EntryPasswordPopupContentView.h"
#import "PropertyPayHistoryViewController.h"

@interface PropertyPayBillViewController ()

@property (nonatomic ,strong) ReservePayAmountView * payAmountView;

@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;

@property (nonatomic ,strong) LKBottomButton * payButton;
@end

@implementation PropertyPayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
}

- (void)createUI{
    //
    self.payAmountView = [[ReservePayAmountView alloc] init];
    [self.payAmountView configPayAmountWithData:self.sumPrice];
    [self addSubview:self.payAmountView];
    
    //
    self.payTypeView = [[ReserveChoosePayTypeView alloc] init];
    self.payTypeView.bChoosePayTypeHandle = ^(NSInteger type){
        
    };
    [self addSubview:self.payTypeView];
    [self.payTypeView configPay:PayTypeWallet];
    self.payTypeView.noteLabel.hidden=YES;
    
    //
    self.payButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(confirmPayHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.payButton];
    
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [self.payAmountView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    [self.payTypeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.payAmountView.mas_left);
        make.top.mas_equalTo(self.payAmountView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.payAmountView.mas_right);
        make.height.mas_equalTo(kTopHeight + kCommentHeight * 1);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.payTypeView.mas_bottom).mas_offset(50);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-40);
    }];
}

#pragma mark -
#pragma mark Action M

- (void) confirmPayHandle:(UIButton *)button{
    if (self.payTypeView.currentSelectPayType == 1) {
        
        
        [UserServices
         getWalletBalanceWithuserId:[KeychainManager readUserId]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 if ([responseObject[@"data"][@"isPwd"] integerValue] == 0)
                 {
                     // 0是设置密码
                     ModyPasswordViewController *password = [[ModyPasswordViewController alloc] init];
                     [self.navigationController pushViewController:password animated:YES];
                 }
                 else
                 {
                     //钱包支付
                     EntryPasswordPopupContentView * popupContentView = [[EntryPasswordPopupContentView alloc] init];
                     popupContentView.bSureHandle = ^(NSString * password){
                         
                         [self requestPayWithPassword:password];
                     };
                     HLLPopupView * popupView = [HLLPopupView alertInWindow:popupContentView];
                     [popupView show:YES];
                     
                 }
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
}

#pragma mark -
#pragma mark Network M

-(void)requestPayWithPassword:(NSString *)password
{
    [UserServices
     propertyWalletWithBillType:self.billType
     userId:[KeychainManager readUserId]
     districtId:[KeychainManager readDistrictId]
     userPassword:password
     billId:self.billIdS
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [UnityLHClass showHUDWithStringAndTime:@"缴费成功"];
             [self sendObject:@"reload"];
             PropertyPayHistoryViewController *history=[[PropertyPayHistoryViewController alloc]init];
             [self.navigationController pushViewController:history animated:YES];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    }];
}

@end
