//
//  ReservePayViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservePayViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "LKBottomButton.h"
#import "BookPopupContentView.h"
#import "EntryPasswordPopupContentView.h"
#import "ModyPasswordViewController.h"

#import "AlipayManager.h"
#import "WXApiManager.h"

@interface ReservePayViewController ()<WXApiManagerDelegate,AlipayManagerDelegate>


@property (nonatomic ,strong) ReservePayAmountView * payAmountView;

@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;

@property (nonatomic ,strong) LKBottomButton * payButton;

@end

@implementation ReservePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [WXApiManager sharedManager].delegate=self;
    [AlipayManager sharedManager].delegate=self;
    self.title = @"支付";
    
    //
    self.payAmountView = [[ReservePayAmountView alloc] init];
    [self.payAmountView configPayAmountWithData:self.priceInfo];
    [self addSubview:self.payAmountView];
    
    //
    self.payTypeView = [[ReserveChoosePayTypeView alloc] init];
    self.payTypeView.bChoosePayTypeHandle = ^(NSInteger type){
        
    };
    [self addSubview:self.payTypeView];
    [self.payTypeView configPay:self.payType];

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
    
    NSString * orderType;
    NSString * orderCode;
    if ([self.orderData[@"orderCode"] length]>0)
    {
        orderCode=self.orderData[@"orderCode"];
        orderType=@"01";
    }
    else if ([self.orderData[@"takeOutType"] length]>0)
    {
        //外卖
        orderCode=self.orderData[@"id"];
        orderType=@"02";
    }
    else if ([self.orderData[@"reservationType"] length]>0)
    {
        //订餐
        orderCode=self.orderData[@"id"];
        orderType=@"01";
    }
    if (self.orderType)
    {
        orderType = self.orderType;
    }

    if (self.payTypeView.currentSelectPayType==1)
    {
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
    else if (self.payTypeView.currentSelectPayType==2)
    {
        //微信支付
        [WXApiManager wxPayinfo:orderCode orderType:orderType];
    }
    else
    {
        //支付宝支付
        [AlipayManager
         payActionWithorderSn:orderCode
         amount:[NSString stringWithFormat:@"%f",self.priceInfo]
         orderType:orderType
         completionBlock:^(int result)
         {
             if (result==0)
             {
                 [self paySuccess];
             }
         }];
    }

}

#pragma mark -
#pragma mark Network M

- (void) requestPayWithPassword:(NSString *)password{
    
    NSString * orderType;
    NSString * orderCode;
    if ([self.orderData[@"orderCode"] length]>0)
    {
        orderCode=self.orderData[@"orderCode"];
        orderType=@"01";
    }
    else if ([self.orderData[@"takeOutType"] length]>0)
    {
        //外卖
        orderCode=self.orderData[@"id"];
        orderType=@"02";
    }
    else if ([self.orderData[@"reservationType"] length]>0)
    {
        //订餐
        orderCode=self.orderData[@"id"];
        orderType=@"01";
    }
    if (self.orderType)
    {
        orderType = self.orderType;
    }
    [UserServices
     walletWithrUserId:[KeychainManager readUserId]
     orderCode:orderCode
     orderType:orderType
     userPassword:password
     completionBlock:^(int result, id responseObject)
    {
       
        if (result == 0)
        {
            [self paySuccess];
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}


-(void)paySuccess
{
    BookPopupContentView * popupContentView = [[BookPopupContentView alloc] init];
    popupContentView.iconImageView.image = [UIImage imageNamed:@"alert_icon_pay"];
    popupContentView.displayLabel.text = @"恭喜你，支付成功";
    [popupContentView configLeftButton:@"返回首页" handle:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KAPPDELEGATE.tabBar setSelectedIndex:0];
        });
    }];
    [popupContentView configRightButton:@"去个人中心" handle:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KAPPDELEGATE.tabBar setSelectedIndex:2];
        });
    }];
    HLLPopupView * popupView = [HLLPopupView alertInWindow:popupContentView];
    [popupView show:YES];

}
- (void)managerDidRecvPayResponse:(PayResp *)response
{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    switch (response.errCode)
    {
        case WXSuccess:
//            [UnityLHClass showHUDWithStringAndTime:@"支付结果：成功！"];
            [self paySuccess];
            break;
            
        default:
//            [UnityLHClass showHUDWithStringAndTime:@"支付结果：失败！"];
            
            break;
    }
    
}

-(void)managerDidRecvAliPayResponse:(NSInteger)response
{
    if (response==0)
    {
        [self paySuccess];
    }
}
@end
