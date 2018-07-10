//
//  ConfirmReserveViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ConfirmReserveViewController.h"
#import "ConfirmReserveDishesCell.h"
#import "ConfirmReserveInfoView.h"
#import "HLLValuationBottomView.h"
#import "ReservePayViewController.h"
#import "ReservationInfo.h"
#import "ReserveChoosePayTypeView.h"
#import "GroupBuyPayTypeView.h"
#import "LKShoppingCarManager.h"

@interface ConfirmReserveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * confirmReserveTableView;

@property (nonatomic ,strong) ConfirmReserveInfoView * infoHeaderView;

@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) NSArray * goodsInfoArray;

@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;

@property (nonatomic ,strong) NSArray * couponPaymentArray;


@end

@implementation ConfirmReserveViewController

//计算价格
-(void)getCouponPriceInfo
{
    //    couponPaymentType 	String 	支付类型（01：支付宝, 02：微信 , 03：钱包支付）
    //    payOrderAmount 	String 	实付金额
    //    couponOrderAmount 	String 	优惠金额
    
    NSArray *goosArr = self.orderInfo[@"goodsArray"];
    NSMutableArray *strJsonArray=[[NSMutableArray alloc]init];
    for (LKGoodsItem *item in goosArr)
    {
        NSMutableDictionary *goodsInfo=[NSMutableDictionary dictionaryWithDictionary:item.goodsInfo];
        [goodsInfo setValue:@(item.count) forKey:@"dishesNum"];
        [strJsonArray addObject:goodsInfo];
    }
    NSString *strJson=[JsonManager jsonWithDict:strJsonArray];
    
    [UserServices
     getCouponPriceInfoWithstrJson:strJson
     flag:@"01"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             self.couponPaymentArray=responseObject[@"data"];
             [self updateBottomViewPrice];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

-(void)getOrderPayType
{
    //    merchantId 	是 	string 	商家id (多个商家逗号隔开)
    //    flag 	是 	string 	01:订餐 02：购物（不含1号店） 03：团购
    //    goodAmount 	是 	string

    NSString *merchantId=self.restaurantData[@"id"];
    NSString *goodsPrice=[NSString stringWithFormat:@"%.2f",[self.orderInfo[@"price"] floatValue]];
    [UserServices
     getOrderPayTypeWithMerchantId:merchantId
     goodAmount:goodsPrice
     flag:@"01"
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
             self.confirmReserveTableView.tableFooterView = [self footerView:data.count];
            
             [_payTypeView configChoosePayTypeViewWithData:data];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

-(void)updateBottomViewPrice
{
  
    //    PayTypeWallet           =1,//钱包支付
    //    PayTypeWX               =2,//微信支付
    //    PayTypeZFB              =3,//支付宝支付
    
    //    couponPaymentType 	String 	支付类型（01：支付宝, 02：微信 , 03：钱包支付）
    //    payOrderAmount 	String 	实付金额
    //    couponOrderAmount 	String 	优惠金额
    
    PayType type= self.payTypeView.currentSelectPayType;
    CGFloat payOrderAmount=0.00;
    CGFloat couponOrderAmount=0.00;
    
    for (NSDictionary *priceDic in self.couponPaymentArray)
    {
        
        if ([priceDic[@"couponPaymentType"] integerValue]==1&&type==PayTypeZFB)
        {
            //
            payOrderAmount=[priceDic[@"payOrderAmount"] floatValue];
            couponOrderAmount=[priceDic[@"couponOrderAmount"] floatValue];
            
        }
        else if ([priceDic[@"couponPaymentType"] integerValue]==2&&type==PayTypeWX)
        {
            payOrderAmount=[priceDic[@"payOrderAmount"] floatValue];
            couponOrderAmount=[priceDic[@"couponOrderAmount"] floatValue];
        }
        else if ([priceDic[@"couponPaymentType"] integerValue]==3&&type==PayTypeWallet)
        {
            payOrderAmount=[priceDic[@"payOrderAmount"] floatValue];
            couponOrderAmount=[priceDic[@"couponOrderAmount"] floatValue];
        }
    }
    
    CGFloat price = payOrderAmount;
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",price];
    self.bottomView.price = price;
    self.bottomView.couponLabel.text=nil;
    if (couponOrderAmount>0) {
        self.bottomView.couponLabel.text=[NSString stringWithFormat:@"(已优惠￥ %.2f)",couponOrderAmount];
        
    }
        
    


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确定预定";
    [self addUI];
    
    self.goodsInfoArray = self.orderInfo[@"goodsArray"];
    [self getOrderPayType];
    [self getCouponPriceInfo];
}
- (UIView *) footerView:(NSInteger)indx
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * 3 + 100)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx + 50);
    _payTypeView = [[ReserveChoosePayTypeView alloc] initWithFrame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx)];
    
    [footerView addSubview:_payTypeView];
    footerView.toplineWithColor=[UIColor colorWithHexString:@"DFDFDF"];
    LKWeakSelf
    _payTypeView.bChoosePayTypeHandle=^(PayType type)
    {
        LKStrongSelf
        [_self updateBottomViewPrice];
        
    };
    return footerView;
}


- (void) addUI{
    
    self.confirmReserveTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.confirmReserveTableView.backgroundColor = [UIColor clearColor];
    self.confirmReserveTableView.dataSource = self;
    self.confirmReserveTableView.delegate = self;
    self.confirmReserveTableView.tableHeaderView = [self headerView];
    self.confirmReserveTableView.tableFooterView = [UIView new];
    self.confirmReserveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.confirmReserveTableView registerClass:[ConfirmReserveDishesCell class]
                         forCellReuseIdentifier:[ConfirmReserveDishesCell cellIdentifier]];
    self.confirmReserveTableView.rowHeight = [ConfirmReserveDishesCell cellHeight];
    [self addSubview:self.confirmReserveTableView];
    
    LKWeakSelf
    self.bottomView = [[HLLValuationBottomView alloc] init];
    [self.bottomView.settleAccountsButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.bottomView updateBottomViewForHideShopingView];
    self.bottomView.bShoppingCarHandle = ^(){
        LKStrongSelf
        
    };
    self.bottomView.bSettleAccountsHandle = ^(){
        LKStrongSelf
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否确认下单？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                [_self requestOrder];
                
            }
        }];
    };
    [self addSubview:self.bottomView];
    
}
- (UIView *) headerView{

    self.infoHeaderView = [[ConfirmReserveInfoView alloc] init];
    self.infoHeaderView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 100);
    [self.infoHeaderView configInfoViewWithData:self.reservationInfo];
    return self.infoHeaderView;
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.confirmReserveTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    
}
#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.goodsInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ConfirmReserveDishesCell * cell = [tableView dequeueReusableCellWithIdentifier:[ConfirmReserveDishesCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configCellWithData:self.goodsInfoArray[indexPath.row]];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10.0f;
}


#pragma mark -
#pragma mark Navigation M

- (void) navigationToPayWithData:(id)data{
    
    // 跳转至支付界面
    ReservePayViewController * pay = [[ReservePayViewController alloc] init];
    pay.priceInfo = self.bottomView.price;
    pay.orderData = data;
    pay.payType = self.payTypeView.currentSelectPayType;
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark -
#pragma mark Network M

- (void) requestOrder{
    
    //payMent 	是 	string 	支付方式（01：支付宝 ，02：微信 ， 03：钱包支付）
    //    PayTypeWallet           =1,//钱包支付
    //    PayTypeWX               =2,//微信支付
    //    PayTypeZFB              =3,//支付宝支付
    
  
    NSString *payMent=@"";
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

    ReservationInfo * info = (ReservationInfo *)self.reservationInfo;
    
    NSString * count = [NSString stringWithFormat:@"%ld",(long)info.count];
    
    [UserServices orderReservationWithUserId:[KeychainManager readUserId]
                                    userName:[KeychainManager readUserName]
                                restaurantId:self.restaurantData[@"id"]
                              restaurantName:self.restaurantData[@"restaurantName"]
                                 contactName:info.name
                               contactMobile:info.phoneNumber
                                  contactSex:info.sex
                                   dinersNum:count
                                 reserveDate:info.dateString
                                 reserveTime:info.timeString
                                    orderFlg:@"1"
                                   orderNote:info.note
                                     payMent:payMent
                             completionBlock:^(int result, id responseObject) {
                                 
                                 if (result == 0) {
                                     
                                     [self navigationToPayWithData:responseObject[@"data"]];
                                 }else{
                                     // error handle here
                                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                                 }
                             }];
}

@end
