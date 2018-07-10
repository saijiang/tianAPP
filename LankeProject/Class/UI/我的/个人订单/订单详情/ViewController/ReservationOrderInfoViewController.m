//
//  ReservationOrderInfoViewController.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationOrderInfoViewController.h"
#import "ReservePayViewController.h"

#import "AddressTwoView.h"
#import "OrderNumView.h"
#import "OrderInfoCenterView.h"
#import "OrderInfoFooterTwoView.h"
#import "OrderBottomView.h"
#import "DQAlertViewController.h"

@interface ReservationOrderInfoViewController ()
{
    NSDictionary *dataSource;
}

@property(nonatomic,strong)AddressTwoView *address;
@property(nonatomic,strong)OrderNumView *orderNum;
@property(nonatomic,strong)OrderInfoCenterView *orderInfo;
@property(nonatomic,strong)OrderInfoFooterTwoView *orderPrice;
@property(nonatomic,strong)OrderBottomView *bottomView;

@end

@implementation ReservationOrderInfoViewController


-(void)getReservationOrderDetail
{
    [UserServices
     getReservationOrderDetailWithorderId:self.viewModel.data[@"id"]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            dataSource=[responseObject[@"data"] firstObject];
            [self loadViewWithDataSource:dataSource];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(void)orderOperationWithObject:(NSString *)object
{
    if ([object isEqualToString:@"取消订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定取消订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices cancelMealOrderWithOrderId:self.viewModel.data[@"id"]
                                               orderType:@"01"
                                         reservationType:dataSource[@"reservationType"]
                                                 delType:@"02"
                                         completionBlock:^(int result, id responseObject)
                 {
                     
                     if (result == 0)
                     {
                         [self getReservationOrderDetail];
                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     }
                 }];

            }
        }];
        [alert showAlert:self];

        
    }
    else if ([object isEqualToString:@"删除订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定删除订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices cancelMealOrderWithOrderId:self.viewModel.data[@"id"]
                                               orderType:@"01"
                                         reservationType:dataSource[@"reservationType"]
                                                 delType:@"01"
                                         completionBlock:^(int result, id responseObject)
                 {
                     
                     if (result == 0)
                     {
                         if (self.bDeleteOrderHandle) {
                             self.bDeleteOrderHandle();
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     }
                 }];
            }
        }];
        [alert showAlert:self];

        
    }
    else if ([object isEqualToString:@"去付款"])
    {
        NSInteger  paymentId= [dataSource[@"paymentId"] integerValue];//支付方式 （01：支付宝 ，02：微信 ，03：钱包支付）
        PayType payType=PayTypeWallet;
        if (paymentId==1)
        {
            payType=PayTypeZFB;
        }
        else if (paymentId==2)
        {
            payType=PayTypeWX;
        }
        else if (paymentId==3)
        {
            payType=PayTypeWallet;
        }
        ReservePayViewController *pay=[[ReservePayViewController alloc]init];
        pay.priceInfo=[dataSource[@"orderSum"] floatValue];;
        pay.orderData=dataSource;
        pay.payType=payType;
        [self.navigationController pushViewController:pay animated:YES];
    }
    else
    {
        [UnityLHClass showHUDWithStringAndTime:object];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"订单详情"];

    [self getReservationOrderDetail];
}
-(void)createUI
{
    self.address =[[AddressTwoView alloc]init];
    [self addSubview:self.address];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        
    }];
    
    self.orderNum =[[OrderNumView alloc]init];
    [self addSubview:self.orderNum];
    [self.orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.address.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        
    }];
    
    self.orderInfo =[[OrderInfoCenterView alloc]init];
    [self addSubview:self.orderInfo];
    [self.orderInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNum.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        
    }];
    
    self.orderPrice =[[OrderInfoFooterTwoView alloc]init];
    [self addSubview:self.orderPrice];
    [self.orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderInfo.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-60);
    }];
    
    self.bottomView =[[OrderBottomView alloc]init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(50);
    }];
    
    [self.bottomView receiveObject:^(id object) {
        [self orderOperationWithObject:object];
    }];
}

-(void)loadViewWithDataSource:(NSDictionary *)data
{
    [self.address loadViewWithDatasource:data];
    
    [self.orderNum configWithViewModel:self.viewModel];
    
    [self.orderInfo loadViewWithReservationOrderInfo:data];
    [self.orderPrice loadViewWithDatasource:data];
    
    [self.bottomView configWithViewModel:self.viewModel];
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
