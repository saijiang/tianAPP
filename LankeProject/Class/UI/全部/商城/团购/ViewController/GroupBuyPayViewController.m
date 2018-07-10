//
//  GroupBuyPayViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyPayViewController.h"
#import "HLLValuationBottomView.h"
#import "LKOrderDeliveryTypeView.h"
#import "LKOrderRemarkView.h"
#import "MallOrderInfoCenterView.h"
#import "AddressViewController.h"
#import "GroupBuyPayTypeView.h"
#import "GroupBuyPayReuseView.h"
#import "EntryPasswordPopupContentView.h"
#import "BookPopupContentView.h"
#import "GroupBuyDeliverTypeView.h"
#import "ModyPasswordViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "AlipayManager.h"
#import "WXApiManager.h"
#import "MallOrderPayViewController.h"

@interface GroupBuyPayViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiManagerDelegate,AlipayManagerDelegate>

@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) GroupBuyDeliverTypeView * deliveryTypeView;
@property (nonatomic ,strong) UITableView * payTableView;
@property (nonatomic ,strong) LKOrderRemarkView * remarkView;
@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;

@property (nonatomic ,strong) NSArray * goodsInfoArray;
@property (nonatomic ,strong) id orderCode;
@property (nonatomic ,assign) BOOL finishPickAddress;
@property (nonatomic ,strong) GroupBuyDeliverTypeItem * item;
@end

@implementation GroupBuyPayViewController

-(void)getOrderPayType
{
    //    merchantId 	是 	string 	商家id (多个商家逗号隔开)
    //    flag 	是 	string 	01:订餐 02：购物（不含1号店） 03：团购
    //    goodAmount 	是 	string
    
    NSString *merchantId=self.payData[@"shopInfo"][@"merchantId"];
    NSString *goodsPrice=[NSString stringWithFormat:@"%f",self.bottomView.price];
    [UserServices
     getOrderPayTypeWithMerchantId:merchantId
     goodAmount:goodsPrice
     flag:@"03"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             
              NSArray *data=responseObject[@"data"];
             if (data.count==0) {
                 
                 self.bottomView.settleAccountsButton.enabled=NO;
             }else{
                 self.bottomView.settleAccountsButton.enabled=YES;
                 
             }
             self.payTableView.tableFooterView = [self footerView:data.count];
            
             [_payTypeView configChoosePayTypeViewWithData:data];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WXApiManager sharedManager].delegate=self;
    [AlipayManager sharedManager].delegate=self;
    
    [self showNavBarCustomByTitle:@"订单确认"];
    self.goodsInfoArray = self.payData[@"goods"];
//
    NSDictionary * goods = self.goodsInfoArray[0];
    CGFloat price = [goods[@"count"] integerValue] * [goods[@"price"] floatValue];
    
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",price];
    self.bottomView.price = price;
    
    [self getOrderPayType];


}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.deliveryTypeView updateAddress];
}

- (void)dealloc{
    
    _payTableView.delegate = nil;
    _payTableView.dataSource = nil;
}
-(void)updatePriceWithItem:(GroupBuyDeliverTypeItem*)item
{
    
    NSDictionary * goods = self.goodsInfoArray[0];
    CGFloat goodsPrice = [goods[@"count"] integerValue] * [goods[@"price"] floatValue];
    goodsPrice += item.price;
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",self.payTypeView.currentPrice+item.price];
    
    self.bottomView.price = self.payTypeView.currentPrice+item.price;
    self.bottomView.couponLabel.text=nil;
    if (self.payTypeView.couponOrderAmount>0) {
        self.bottomView.couponLabel.text=[NSString stringWithFormat:@"(已优惠￥ %.2f)",self.payTypeView.couponOrderAmount];

    }
    
}
- (void) createUI{
    
    LKWeakSelf
    
    _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.payTableView.dataSource = self;
    self.payTableView.delegate = self;
    self.payTableView.rowHeight = 35.0f;
    self.payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.payTableView.backgroundColor = [UIColor clearColor];
    self.payTableView.tableHeaderView = [self headerView];

    [self.payTableView registerClass:[GroupBuyPayHeaderView class]
  forHeaderFooterViewReuseIdentifier:[GroupBuyPayHeaderView identifier]];
    [self.payTableView registerClass:[GroupBuyPayFooterView class]
  forHeaderFooterViewReuseIdentifier:[GroupBuyPayFooterView identifier]];
    [self addSubview:self.payTableView];
    
    //
    self.bottomView = [[HLLValuationBottomView alloc] init];
    [self.bottomView updateBottomViewForHideShopingView];
    [self.bottomView.settleAccountsButton setTitle:@"提交订单" forState:UIControlStateNormal];
    self.bottomView.bSettleAccountsHandle = ^(){
        LKStrongSelf
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否确认下单？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                [_self navigationToPay];

            }
        }];
    };
    [self addSubview:self.bottomView];
    

}

- (UIView *) headerView{
    
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 180.0f);
    
    LKWeakSelf
    self.deliveryTypeView = [[GroupBuyDeliverTypeView alloc] initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 200)];
    [self.deliveryTypeView configDeliveyTypeForGroupBuyWithData:self.payData[@"shopInfo"] changeHeight:^(CGFloat height) {
        headerView.height = height + 10;
        self.deliveryTypeView.height = height;
        [self.payTableView reloadData];
    }];
   
    self.deliveryTypeView.bChooseTypeHandle = ^(GroupBuyDeliverTypeItem * item){
        
        LKStrongSelf
        _self.item=item;
        [_self updatePriceWithItem:item];
    };

    self.deliveryTypeView.bOrderDeliveryTypeChooseAddressHandle = ^(){
        LKStrongSelf
        [_self navigationToSelectAddress];
    };
    [headerView addSubview:self.deliveryTypeView];
    
    return headerView;
}

- (UIView *) footerView:(NSInteger)indx
{
    LKWeakSelf
    UIView * footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx + 120);
    _remarkView = [[LKOrderRemarkView alloc] init];
    _remarkView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 90);
    [footerView addSubview:_remarkView];
    
    _payTypeView = [[ReserveChoosePayTypeView alloc] initWithFrame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx)];
    [footerView addSubview:_payTypeView];
    [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_remarkView.mas_bottom).offset(10);
        make.left.mas_equalTo(footerView.mas_left);
        make.right.mas_equalTo(footerView.mas_right);
    }];
    _payTypeView.bChoosePayTypeHandle=^(PayType type)
    {
        LKStrongSelf
        [_self updatePriceWithItem:_self.deliveryTypeView.typeItem];
    };
    return footerView;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.goodsInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallOrderInfoCenterCell *cell = [MallOrderInfoCenterCell cellWithTableView:tableView];
    
    [cell configForGroupBuyPay:self.goodsInfoArray[indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 20.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 50.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupBuyPayHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[GroupBuyPayHeaderView identifier]];
    
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    GroupBuyPayFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[GroupBuyPayFooterView identifier]];
    NSDictionary * goods = self.goodsInfoArray[0];
    
    CGFloat price = [goods[@"count"] integerValue] * [goods[@"price"] floatValue];
    
    [footerView price:price];
    
    return footerView;
}
#pragma mark -
#pragma mark Navigation M

- (void) navigationToPay{
    
    [self requestCommitOrder];
    
}

- (void) navigationToSelectAddress{
    
    // 跳转至挑选地址界面
    AddressViewController * vc = [AddressViewController new];
    vc.bSelectAddressHandle = ^(id addressData){
//        self.finishPickAddress = YES;
        [self.deliveryTypeView updateAddressInfoWithData:addressData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *) goodsListJson{
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * gooods in self.goodsInfoArray) {
        
        NSDictionary * temp = @{@"merchantId":NSStringWithNunull(self.payData[@"shopInfo"][@"merchantId"]),
                                @"merchantName":NSStringWithNunull(self.payData[@"shopInfo"][@"merchantName"]),
                                @"shippingFee":@(self.deliveryTypeView.typeItem.price),
                                @"shippingName":NSStringWithNunull(self.deliveryTypeView.typeItem.flag),
                                @"leaveMessage":self.remarkView.remarkTextView.text,
                                @"listGoods":@[@{
                                        @"goodsId":NSStringWithNunull(gooods[@"id"]),
                                       // @"goodsName":NSStringWithNunull(gooods[@"name"]),
                                        @"groupPrice":NSStringWithNunull(gooods[@"price"]),
                                        @"goodsNum":NSStringWithNunull(gooods[@"count"])}]
                                };
        
        [array addObject:temp];
    }
    
    return [array JSONFragment];
}
/*
 */
#pragma mark -
#pragma mark Network M

- (void) requestCommitOrder{
    
    if ((!self.deliveryTypeView.addressId) && ![self.deliveryTypeView.typeItem.flag  isEqualToString: @"01"]) {
        
        [UnityLHClass showAlertView:@"请设置收货地址"];
        return;
    }
    
    //payMent 	是 	string 	支付方式（01：支付宝 ，02：微信 ， 03：钱包支付）
    //    PayTypeWallet           =1,//钱包支付
    //    PayTypeWX               =2,//微信支付
    //    PayTypeZFB              =3,//支付宝支付
    NSString *payMent=@"03";
    if (self.payTypeView.currentSelectPayType==PayTypeWallet)
    {
        payMent=@"03";
    }
    else if (self.payTypeView.currentSelectPayType==PayTypeWX)
    {
        payMent=@"02";
    }
    else if (self.payTypeView.currentSelectPayType==PayTypeZFB)
    {
        payMent=@"01";
    }
    
    // 提交订单接口
    [UserServices
     addGroupGoodsOrderWithUserId:[KeychainManager readUserId]
     userName:[KeychainManager readUserName]
     addressId:self.deliveryTypeView.addressId
     orderList:[self goodsListJson]
     payMent:payMent
     completionBlock:^(int result, id responseObject)
    {
        if (result == 0) {
            
            if (self.bOrderDidCommitFinishHandle) {
                self.bOrderDidCommitFinishHandle();
            }
            id yhdOrderCode = responseObject[@"data"];// 返回订单号
           // CGFloat sumPrice = [responseObject[@"data"][@"orderAmount"] floatValue];// 总价格
            
            //订单类型：01、订座订单，02、外卖订单， 03、自营商城多个商家合并支付 ，04、1号店订单， 05、团购商品，06、自营商品我的订单页面进入
            // 去支付界面
            MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
            pay.orderCode = yhdOrderCode;// 订单号
            pay.orderType = @"06";
            pay.payType=self.payTypeView.currentSelectPayType;
            pay.sumPrice =   self.bottomView.price;
            pay.timeStr=self.timeStr;
            pay.typeStr=@"detail";
            [self.navigationController pushViewController:pay animated:YES];
            
            [self removeSelfFromNavigationStack];
//        
//        if (result == 0)
//        {
//            
//            id data = responseObject[@"data"];
//            self.orderCode = data;
//            
//            if (self.payTypeView.currentSelectPayType==1)
//            {
//                [UserServices
//                 getWalletBalanceWithuserId:[KeychainManager readUserId]
//                 completionBlock:^(int result, id responseObject)
//                 {
//                     if (result==0)
//                     {
//                         if ([responseObject[@"data"][@"isPwd"] integerValue] == 0)
//                         {
//                             // 0是设置密码
//                             ModyPasswordViewController *password = [[ModyPasswordViewController alloc] init];
//                             [self.navigationController pushViewController:password animated:YES];
//                         }
//                         else
//                         {
//                             //钱包支付
//                             EntryPasswordPopupContentView * popupContentView = [[EntryPasswordPopupContentView alloc] init];
//                             popupContentView.bSureHandle = ^(NSString * password){
//                                 
//                                 [self requestPayWithPassword:password];
//                             };
//                             HLLPopupView * popupView = [HLLPopupView alertInWindow:popupContentView];
//                             [popupView show:YES];
//                             
//                         }
//                     }
//                     else
//                     {
//                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//                     }
//                 }];
//
//            }
//            else if (self.payTypeView.currentSelectPayType==2)
//            {
//                //微信支付
//                [WXApiManager wxPayinfo:self.orderCode orderType:@"05"];
//            }
//            else
//            {
//               //支付宝支付
//                [AlipayManager
//                 payActionWithorderSn:self.orderCode
//                 amount:[NSString stringWithFormat:@"%f",self.bottomView.price]
//                 orderType:@"05"
//                 completionBlock:^(int result)
//                 {
//                    if (result==0)
//                    {
//                        [self paySuccess];
//                    }
//                }];
//            }
//           
//        }
        } else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
- (void) requestPayWithPassword:(NSString *)password{
    
    [UserServices
     orderWalletWithrUserId:[KeychainManager readUserId]
     orderCode:self.orderCode
     orderType:@"06"
     userPassword:password
     completionBlock:^(int result, id responseObject)
     {
        
        if (result == 0)
        {
            [self paySuccess];
            
        }else
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

- (void)managerDidRecvAliPayResponse:(NSInteger)response
{
    if (response==0)
    {
        [self paySuccess];

    }
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

@end
