//
//  MallOrderPayViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderPayViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "LKBottomButton.h"
#import "BookPopupContentView.h"
#import "EntryPasswordPopupContentView.h"
#import "SelfSupportGoodsDetailViewController.h"
#import "NumberOneGoodsDetailViewController.h"
#import "JDShopListViewController.h"
#import "GroupBuyListViewController.h"

#import "WXApiManager.h"
#import "AlipayManager.h"

@interface MallOrderPayViewController ()<WXApiManagerDelegate,AlipayManagerDelegate>

@property (nonatomic ,strong) ReservePayAmountView * payAmountView;

@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;

@property (nonatomic ,strong) LKBottomButton * payButton;

@end

@implementation MallOrderPayViewController

-(void)getPayType
{
    
    if ([self.orderType integerValue]==4)
    {
        [self.payTypeView configShopOnePay];
        
    }  else if ([self.orderType integerValue]==7){
        //京东
        [self.payTypeView configJDShopPay];
        [self createZKOrderId];
        
    }
    else
    {
        [self.payTypeView configPay:self.payType];

    }
}
-(void)createZKOrderId
{
    [UserServices getJDOrderDetailWithjdOrderId:self.orderCode
                                completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             NSDictionary *dataSource=responseObject[@"data"];
             self.sumPrice = [dataSource[@"zkOrderPrice"] integerValue];
             [self.payAmountView configPayAmountWithData:self.sumPrice];

         }
     }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WXApiManager sharedManager].delegate=self;
    [AlipayManager sharedManager].delegate=self;

    self.title = @"支付";
    
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(baseBackBtnAction:);
    
    [self getPayType];
    
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
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.payTypeView.mas_bottom).mas_offset(50);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-40);
    }];
}

- (void)baseBackBtnAction:(UIButton *)btn{
    
    if ([self.orderType isEqualToString:@"06"]&&[self.typeStr isEqualToString:@"detail"]&&self.timeStr.length!=0) {
            
        NSString*time=[NSString stringWithFormat:@"单提交成功后%@分钟内未支付将被取消",self.timeStr];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:time delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                BOOL bingo = NO;
                for (UIViewController * vc in self.navigationController.viewControllers) {
                    /*
                     <HomepageViewController: 0x11dd32440>,
                     <MallHomepageViewController: 0x11fbbd360>,
                     <JDShopListViewController: 0x11fc3faa0>,
                     <ShoppingCarListViewController: 0x11fd87cd0>,
                     <MallOrderPayViewController: 0x11fe3edd0>
                     
                     */
                    if ([vc isKindOfClass:[SelfSupportGoodsDetailViewController class]] ||
                        [vc isKindOfClass:[NumberOneGoodsDetailViewController class]] || [vc isKindOfClass:[JDShopListViewController class]]||[vc isKindOfClass:[GroupBuyListViewController class]]) {
                        bingo = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                if (!bingo) {
                    [super baseBackBtnAction:btn];
                }

            }else{
                
                return ;

            }
        }];
        
   
        
    }else{
        BOOL bingo = NO;
        for (UIViewController * vc in self.navigationController.viewControllers) {
            /*
             <HomepageViewController: 0x11dd32440>,
             <MallHomepageViewController: 0x11fbbd360>,
             <JDShopListViewController: 0x11fc3faa0>,
             <ShoppingCarListViewController: 0x11fd87cd0>,
             <MallOrderPayViewController: 0x11fe3edd0>
             
             */
            if ([vc isKindOfClass:[SelfSupportGoodsDetailViewController class]] ||
                [vc isKindOfClass:[NumberOneGoodsDetailViewController class]] || [vc isKindOfClass:[JDShopListViewController class]]||[vc isKindOfClass:[GroupBuyListViewController class]]) {
                bingo = YES;
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        if (!bingo) {
            [super baseBackBtnAction:btn];
        }
        

    }
    
}
#pragma mark -
#pragma mark Action M

- (void) confirmPayHandle:(UIButton *)button
{
    
    if (self.payTypeView.currentSelectPayType == 1)
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
        NSString *orderType=self.orderType;
        if ([self.orderType integerValue]==5)
        {
            orderType=@"06";

        }
        if ([self.orderType integerValue]==6)
        {
            orderType=@"05";
            
        }
        [WXApiManager wxPayinfo:self.orderCode orderType:orderType];
    }
    else
    {
        //支付宝支付
        NSString *orderType=self.orderType;
        if ([self.orderType integerValue]==5)
        {
            orderType=@"06";
            
        }
        if ([self.orderType integerValue]==6)
        {
            orderType=@"05";
            
        }
        //支付宝支付
        [AlipayManager
         payActionWithorderSn:self.orderCode
         amount:[NSString stringWithFormat:@"%f",self.sumPrice]
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
  
    
    
    [UserServices orderWalletWithrUserId:[KeychainManager readUserId] orderCode:self.orderCode orderType:self.orderType userPassword:password completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            [self paySuccess];
        }else{
            // error handle here
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
