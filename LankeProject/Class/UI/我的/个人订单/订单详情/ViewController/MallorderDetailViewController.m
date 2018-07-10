//
//  MallorderDetailViewController.m
//  LankeProject
//
//  Created by itman on 17/1/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallorderDetailViewController.h"

#import "AddressHeaderView.h"
#import "OrderNumView.h"
#import "MallOrderInfoCenterView.h"
#import "MallOrderInfoFooterView.h"
#import "OrderBottomView.h"
#import "MallOrderPayViewController.h"
#import "ReservePayViewController.h"
#import "ApplyRefundViewController.h"
#import "MallcommentViewController.h"
#import "MallcommentModel.h"
#import "LogisticsDetailsViewController.h"
#import "OneShopLogisticsDetailsViewController.h"
#import "JDLogisticsDetailsViewController.h"
#import "DQAlertViewController.h"
//申请售后页面
#import "JDAddServiceViewController.h"
//电子发票
#import "JDInvoiceDetailViewController.h"

@interface MallorderDetailViewController ()
{
    NSDictionary *dataSource;
}

@property(nonatomic,strong)AddressHeaderView *address;
@property(nonatomic,strong)OrderNumView *orderNum;
@property(nonatomic,strong)MallOrderInfoCenterView *orderInfo;
@property(nonatomic,strong)MallOrderInfoFooterView *orderPrice;
@property(nonatomic,strong)OrderBottomView *bottomView;


@end

@implementation MallorderDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getGoodsOrderDetail];

}

-(void)getGoodsOrderDetail
{
    if (self.viewModel.isJDShop)
    {
//        //一号店商品详情
//        [UserServices
//         getYhdOrderDetailWithOrderCode:self.viewModel.orderData[@"orderCode"]
//         completionBlock:^(int result, id responseObject)
//         {
//             if (result==0)
//             {
//                 dataSource=responseObject[@"data"];
//                 self.viewModel=[GoodsOrderStatusViewModel JDShopviewModelWithData:dataSource];
//                 [self loadViewWithDataSource:dataSource];
//                 
//             }
//         }];
        //京东商品详情
        [UserServices
         getJDOrderDetailWithjdOrderId:self.viewModel.orderData[@"jdOrderId"]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
               
                 dataSource=responseObject[@"data"];
                 self.viewModel=[GoodsOrderStatusViewModel JDShopviewModelWithData:dataSource];
                 [self loadViewWithDataSource:dataSource];
                 
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
    else if (self.viewModel.isGroupGoods)
    {
        //团购商品详情
        [UserServices
         getGroupGoodsOrderDetailWithOrderCode:self.viewModel.orderData[@"orderCode"]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 dataSource=responseObject[@"data"];
                 self.viewModel=[GoodsOrderStatusViewModel groupGoodsOrderListviewModelWithData:dataSource];
                 [self loadViewWithDataSource:dataSource];
                 
             }
         }];
        
    }
    else
    {
        //自营商品详情
        [UserServices
         getGoodsOrderDetailWithOrderCode:self.viewModel.orderData[@"orderCode"]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 dataSource=responseObject[@"data"];
                 self.viewModel=[GoodsOrderStatusViewModel viewModelWithData:dataSource];
                 [self loadViewWithDataSource:dataSource];
                 
             }
         }];
    }
    

    
}

//自营商品对应操作
//orderFlag 	是 	string 	类型（01：取消订单 ，02：确认收货，03：删除订单）
-(void)orderOperationWithObject:(NSString *)object
{
    if ([object isEqualToString:@"取消订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定取消订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices
                 changeOrderStatusWithOrderCode:dataSource[@"orderCode"]
                 orderFlag:@"01" completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
                         [self getGoodsOrderDetail];
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
    else if ([object isEqualToString:@"确认收货"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"是否确认收货？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices
                 changeOrderStatusWithOrderCode:dataSource[@"orderCode"]
                 orderFlag:@"02" completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
                         [self getGoodsOrderDetail];
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
            if (buttonIndex == 1) {
                [UserServices
                 changeOrderStatusWithOrderCode:dataSource[@"orderCode"]
                 orderFlag:@"03" completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
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

        MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
        if (self.viewModel.isJDShop)
        {
            pay.orderType = @"04";
            
        }
        else
        {
            pay.orderType = @"05";
            
        }
        
        pay.payType=payType;
        pay.orderCode = dataSource[@"orderCode"];
        pay.sumPrice = [dataSource[@"orderAmount"] floatValue];
        [self.navigationController pushViewController:pay animated:YES];
    }
    else if ([object isEqualToString:@"评价"])
    {
        NSMutableArray *evaluateList=[[NSMutableArray alloc]init];
        for (NSDictionary *data in dataSource[@"listGoods"])
        {
            MallcommentModel *model=[MallcommentModel initModelwithDataSource:data];
            [evaluateList addObject:model];
        }
        MallcommentViewController *comment=[[MallcommentViewController alloc]init];
        comment.tableArray=evaluateList;
        comment.orderCode=dataSource[@"orderCode"];
        
        comment.merchantId=dataSource[@"merchantId"];
        comment.merchantName=dataSource[@"merchantName"];
        
        
        [self.navigationController pushViewController:comment animated:YES];
        [comment receiveObject:^(id object) {
            //刷新我的订单列表
            [self sendObject:@"reload"];
        }];
    }
    else if ([object isEqualToString:@"查看物流"])
    {
        LogisticsDetailsViewController *logistic=[[LogisticsDetailsViewController alloc]init];
        logistic.orderInfo=self.viewModel.orderData;
        logistic.isGroup=self.viewModel.isGroupGoods;
        [self.navigationController pushViewController:logistic animated:YES];
    }
    
}
//一号店对应操作
-(void)orderOperationOneShopWithObject:(NSString *)object
{
   
    
    if ([object isEqualToString:@"取消订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定取消订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices
                 cancelOrderWithOrderCode:dataSource[@"orderCode"]
                 completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
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
    else if ([object isEqualToString:@"确认收货"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"是否确认收货？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices
                 changeOrderStatusWithOrderCode:dataSource[@"orderCode"]
                 orderFlag:@"02" completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
                         [self getGoodsOrderDetail];
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
                
                [UserServices
                 deleteOrderWithOrderCode:dataSource[@"orderCode"]
                 completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
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
       
        MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
        pay.orderType = @"04";
        pay.orderCode = dataSource[@"orderCode"];
        pay.sumPrice = [dataSource[@"orderAmount"] floatValue];
        [self.navigationController pushViewController:pay animated:YES];
    }
    else if ([object isEqualToString:@"评价"])
    {
        NSMutableArray *evaluateList=[[NSMutableArray alloc]init];
        for (NSDictionary *data in dataSource[@"orderItemList"])
        {
            MallcommentModel *model=[MallcommentModel initOneShopModelwithDataSource:data];
            [evaluateList addObject:model];
        }
        MallcommentViewController *comment=[[MallcommentViewController alloc]init];
        comment.tableArray=evaluateList;
        comment.orderCode=dataSource[@"orderCode"];
        comment.merchantId=@"YHD";
        comment.merchantName=@"YHD";

        [self.navigationController pushViewController:comment animated:YES];
        [comment receiveObject:^(id object) {
            //刷新我的订单列表
            [self sendObject:@"reload"];
        }];
    }
    else if ([object isEqualToString:@"查看物流"])
    {
        OneShopLogisticsDetailsViewController *logistic=[[OneShopLogisticsDetailsViewController alloc]init];
        logistic.orderCode=dataSource[@"orderCode"];
        [self.navigationController pushViewController:logistic animated:YES];
        
 
        
    }

}
//JD店对应操作
-(void)orderOperationJDShopWithObject:(NSString *)object
{
   
    if ([object isEqualToString:@"确认收货"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定收货？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex)
            {
                
                [UserServices
                 changeGroupOrderStatusWithjdOrderId:dataSource[@"jdOrderId"]completionBlock:^(int result, id responseObject)
                 {
                     
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];

//                         [self getGoodsOrderDetail];
                         [self.navigationController popViewControllerAnimated:YES];                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     }

                 }];
            }
        }];
        [alert showAlert:self];
    }
   else if ([object isEqualToString:@"取消订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定取消订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices cancelJDOrderWithuserId:[KeychainManager readUserId] jdOrderId:dataSource[@"jdOrderId"] completionBlock:^(int result, id responseObject) {
                    if (result == 0)
                    {
                        //刷新我的订单列表
                        [self sendObject:@"reload"];
                        [self getGoodsOrderDetail];
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
                [UserServices deleteJDOrderWithuserId:[KeychainManager readUserId] jdOrderId:dataSource[@"jdOrderId"]  completionBlock:^(int result, id responseObject) {
                    if (result == 0)
                    {
                        //刷新我的订单列表
                        [self sendObject:@"reload"];
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
        
        MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
        pay.orderType = @"07";
        pay.orderCode = dataSource[@"jdOrderId"];
        pay.sumPrice = [dataSource[@"zkOrderPrice"] floatValue];
        [self.navigationController pushViewController:pay animated:YES];
//        [UserServices
//         checkJDOrderStatusWithuserId:[KeychainManager readUserId]
//         completionBlock:^(int result, id responseObject)
//         {
//             if (result==0)
//             {
//                 MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
//                 pay.orderType = @"07";
//                 pay.orderCode = dataSource[@"jdOrderId"];
//                 pay.sumPrice = [dataSource[@"zkOrderPrice"] floatValue];
//                 [self.navigationController pushViewController:pay animated:YES];
//             }
//             else
//             {
//                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//                 [self refresh];
//             }
//         }];
//        MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
//        pay.orderType = @"04";
//        pay.orderCode = dataSource[@"orderCode"];
//        pay.sumPrice = [dataSource[@"orderAmount"] floatValue];
//        [self.navigationController pushViewController:pay animated:YES];
    }
    else if ([object isEqualToString:@"评价"])
    {
        NSMutableArray *evaluateList=[[NSMutableArray alloc]init];
        for (NSDictionary *data in dataSource[@"zkJdOrderItemMapList"])
        {
//            MallcommentModel *model=[MallcommentModel initJDShopModelwithDataSource:data];
//            [evaluateList addObject:model];
            
            MallcommentModel *model=[MallcommentModel initJDShopModelwithDataSource:data];
            model.goodsId = data[@"sku"];
            [evaluateList addObject:model];
        }
        MallcommentViewController *comment=[[MallcommentViewController alloc]init];
        comment.tableArray=evaluateList;
        comment.orderCode=dataSource[@"jdOrderId"];
        comment.merchantId=@"JD";
        comment.merchantName=@"JD";
        comment.isJD = YES;

        [self.navigationController pushViewController:comment animated:YES];
        [comment receiveObject:^(id object) {
            //刷新我的订单列表
            [self sendObject:@"reload"];
        }];
    }
    else if ([object isEqualToString:@"电子发票"])
    {

        
        JDInvoiceDetailViewController * Invoice = [[JDInvoiceDetailViewController alloc] init];
        Invoice.jdOrderId = dataSource[@"jdOrderId"];
        [self.navigationController pushViewController:Invoice animated:YES];
     
    }
    else if ([object isEqualToString:@"查看物流"])
    {
        //        OneShopLogisticsDetailsViewController *logistic=[[OneShopLogisticsDetailsViewController alloc]init];
        //        logistic.orderCode=dataSource[@"orderCode"];
        //        [self.navigationController pushViewController:logistic animated:YES];
        
        JDLogisticsDetailsViewController *logistic=[[JDLogisticsDetailsViewController alloc]init];
        logistic.orderCode=dataSource[@"jdOrderId"];
        [self.navigationController pushViewController:logistic animated:YES];
        
    }
    
}

//团购商品对应操作
//orderFlag 	是 	string 	类型（01：确认收货，02：删除订单）
-(void)groupOrderOperationWithObject:(NSString *)object
{
    if ([object isEqualToString:@"确认收货"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"是否确认收货？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex)
            {
                
                [UserServices
                 changeGroupOrderStatusWithOrderCode:dataSource[@"orderCode"]
                 orderFlag:@"01" completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
                       
                         [self getGoodsOrderDetail];
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
        
        MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
        pay.orderType = @"06";
        pay.payType=payType;
        pay.orderCode = dataSource[@"orderCode"];
        pay.sumPrice = [dataSource[@"orderAmount"] floatValue];
        [self.navigationController pushViewController:pay animated:YES];

    }
    else if ([object isEqualToString:@"删除订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定删除订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [UserServices
                 changeGroupOrderStatusWithOrderCode:dataSource[@"orderCode"]
                 orderFlag:@"02" completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         //刷新我的订单列表
                         [self sendObject:@"reload"];
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
    else if ([object isEqualToString:@"查看物流"])
    {
        LogisticsDetailsViewController *logistic=[[LogisticsDetailsViewController alloc]init];
        logistic.orderInfo=self.viewModel.orderData;
        logistic.isGroup=self.viewModel.isGroupGoods;
        [self.navigationController pushViewController:logistic animated:YES];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"订单详情"];

}

-(void)createUI
{
    self.address =[[AddressHeaderView alloc]init];
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
    
    self.orderInfo =[[MallOrderInfoCenterView alloc]init];
    [self addSubview:self.orderInfo];
    [self.orderInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNum.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        
    }];
    [self.orderInfo receiveObject:^(id object) {
        //退款
        DEF_DEBUG(@"%@",object);
        
        ApplyRefundViewController *refund=[[ApplyRefundViewController alloc]init];

        if (self.viewModel.isJDShop)
        {
//            ApplyRefundModel *model=[ApplyRefundModel ApplyOneShopRefundModelModelWithData:dataSource withIndex:[object integerValue]];
//            refund.model=model;
//            refund.model.orderType=@"02";
            //进入申请呢售后服务页面
            //申请售后
            JDAddServiceViewController *vc = [[JDAddServiceViewController alloc]init];
            NSInteger num=[object integerValue];
            vc.orderData = dataSource[@"zkJdOrderItemMapList"][num];
            
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if (self.viewModel.isGroupGoods)
        {
            ApplyRefundModel *model=[ApplyRefundModel ApplyRefundModelModelWithData:dataSource];
            refund.model=model;
            refund.model.orderType=@"03";
            [self.navigationController pushViewController:refund animated:YES];

        }
        else
        {
            ApplyRefundModel *model=[ApplyRefundModel ApplyRefundModelModelWithData:dataSource withIndex:[object integerValue]];
            refund.model=model;
            refund.model.orderType=@"01";
            [self.navigationController pushViewController:refund animated:YES];

        }
       
    }];
    
    self.orderPrice =[[MallOrderInfoFooterView alloc]init];
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
    
    [self.bottomView receiveObject:^(id object)
     {
        
         
         if (self.viewModel.isJDShop)
         {
             [self orderOperationJDShopWithObject:object];

         }
         else if (self.viewModel.isOneNumberShop)
         {
             [self orderOperationOneShopWithObject:object];
             
         }
         else if (self.viewModel.isGroupGoods)
         {
             [self groupOrderOperationWithObject:object];
         }
         else
         {
             [self orderOperationWithObject:object];

         }
     }];
    

    
}

-(void)loadViewWithDataSource:(NSDictionary *)data
{
    [self.address configWithMallViewModel:self.viewModel];
    [self.orderNum configWithMallViewModel:self.viewModel];
    [self.orderInfo configWithMallViewModel:self.viewModel];
    [self.orderPrice configMallWithViewModel:self.viewModel];
    if (self.viewModel.isJDShop)
    {
        if ([self.viewModel.orderData[@"state"] integerValue] == 3)
        {
//            //是否已经评价
//            if ([self.viewModel.orderData[@"isEvaluate"] integerValue] == 1)
//            {
//                //已经评价过了
//                self.bottomView.hidden = NO;
//            }
//            else
//            {
                self.bottomView.hidden = NO;
                [self.bottomView configMallWithViewModel:self.viewModel];
           // }
        }
        else
        {
            self.bottomView.hidden = NO;
            [self.bottomView configMallWithViewModel:self.viewModel];
        }
    }
    else
    {
        [self.bottomView configMallWithViewModel:self.viewModel];
    }
    

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
