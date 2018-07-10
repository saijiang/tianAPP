//
//  TakeOutOrderViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "TakeOutOrderViewController.h"
#import "HLLValuationBottomView.h"
#import "LKOrderDeliveryTypeView.h"
#import "LKOrderRemarkView.h"
#import "LKOrderDishesContentCell.h"
#import "AddressViewController.h"
#import "ReservePayViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "GroupBuyPayTypeView.h"
#import "LKShoppingCarManager.h"

@interface TakeOutOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) LKOrderDeliveryTypeView * deliveryTypeView;

@property (nonatomic ,strong) LKOrderRemarkView * remarkView;

@property (nonatomic ,strong) UITableView * dishesContentTableView;

@property (nonatomic ,strong) NSArray * goodsInfoArray;
@property (nonatomic ,strong) NSString * orderNote;

@property (nonatomic ,assign) BOOL finishPickAddress;

@property (nonatomic ,strong) ReserveChoosePayTypeView *payTypeView;

@property (nonatomic ,strong) NSArray *couponPaymentArray;


@end

@implementation TakeOutOrderViewController

//计算价格
-(void)getCouponPriceInfo
{
//    couponPaymentType 	String 	支付类型（01：支付宝, 02：微信 , 03：钱包支付）
//    payOrderAmount 	String 	实付金额
//    couponOrderAmount 	String 	优惠金额

    NSArray *goosArr = self.takeOutOrderInfo[@"goodsArray"];
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
            [self updatePrice];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(void)updatePrice
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
    
 
    if ([self.restaurantData[@"startSendFlg"] integerValue]==0) {
        self.deliveryTypeView.typeOfHomeDeliveryButton.enabled=YES;
        self.deliveryTypeView.shadowView.hidden=YES;
    }else{
        if (price>=[self.restaurantData[@"startSendMoney"] floatValue]) {
            
            self.deliveryTypeView.typeOfHomeDeliveryButton.enabled=YES;
            self.deliveryTypeView.shadowView.hidden=YES;
            
        }else{
            self.deliveryTypeView.typeOfHomeDeliveryButton.enabled=NO;
            self.deliveryTypeView.shadowView.hidden=NO;
            
        }
    }
        
    
    if ([self.restaurantData[@"freeSendFlg"] integerValue]==0){
        
        if (!self.deliveryTypeView.typeOfSelfTake)
        {
            
            price += [self.restaurantData[@"takeOutFee"] floatValue];
        }
        self.deliveryTypeView.titleLabelTwo.hidden=YES;
        self.deliveryTypeView.displayLabel.hidden=NO;

        
    }else{
        
        if (price>=[self.restaurantData[@"freeSendMoney"] floatValue]) {
            if ([self.restaurantData[@"freeSendMoney"] floatValue]<[self.restaurantData[@"startSendMoney"] floatValue]&&price<[self.restaurantData[@"startSendMoney"] floatValue]) {
                self.deliveryTypeView.titleLabelTwo.hidden=YES;
                self.deliveryTypeView.displayLabel.hidden=NO;


            }else{
                
                self.deliveryTypeView.titleLabelTwo.hidden=YES;
                self.deliveryTypeView.orderPriceLabel.text=@"免运费";
                self.deliveryTypeView.displayLabel.hidden=YES;

            }
            
            
            
        }else{
            
            if (!self.deliveryTypeView.typeOfSelfTake)
            {
                
                price += [self.restaurantData[@"takeOutFee"] floatValue];
            }
            self.deliveryTypeView.titleLabelTwo.hidden=YES;
            
        }
    }
        
    
 

    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",price];
    self.bottomView.price = price;
    self.bottomView.couponLabel.text=nil;
    if (couponOrderAmount>0) {
        
        self.bottomView.couponLabel.text=[NSString stringWithFormat:@"(已优惠￥ %.2f)",couponOrderAmount] ;
        
    }
   
    
}

//支付方式
-(void)getOrderPayType
{
    //    merchantId 	是 	string 	商家id (多个商家逗号隔开)
    //    flag 	是 	string 	01:订餐 02：购物（不含1号店） 03：团购
    //    goodAmount 	是 	string
    
    NSString *merchantId=self.restaurantData[@"id"];
    NSString *goodsPrice=[NSString stringWithFormat:@"%f",self.bottomView.price];
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
             self.dishesContentTableView.tableFooterView = [self footerView:data.count];
             
             [_payTypeView configChoosePayTypeViewWithData:data];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self requestDefaultAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点餐订单";
    
    [self creatUI];
    
    self.goodsInfoArray = self.takeOutOrderInfo[@"goodsArray"];
    
//    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[self.takeOutOrderInfo[@"price"] floatValue]];
//    self.bottomView.price = [self.takeOutOrderInfo[@"price"] floatValue];
    
    [self getOrderPayType];
    
    [self getCouponPriceInfo];
}

- (void)dealloc{

    _dishesContentTableView.delegate = nil;
    _dishesContentTableView.dataSource = nil;
}


- (void) creatUI{
    
    LKWeakSelf

    _dishesContentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.dishesContentTableView.dataSource = self;
    self.dishesContentTableView.delegate = self;
    self.dishesContentTableView.rowHeight = 35.0f;
    self.dishesContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dishesContentTableView.backgroundColor = [UIColor clearColor];
    self.dishesContentTableView.tableFooterView = [UIView new];
    self.dishesContentTableView.tableHeaderView = [self headerView];
    [self.dishesContentTableView registerClass:[LKOrderDishesContentCell class]
                        forCellReuseIdentifier:[LKOrderDishesContentCell cellIdentifier]];
    [self addSubview:self.dishesContentTableView];
    
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
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 400.0f);
    
    LKWeakSelf
    self.deliveryTypeView = [[LKOrderDeliveryTypeView alloc] init];
    [self.deliveryTypeView configDeliveyTypeWithData:self.restaurantData];
    self.deliveryTypeView.bOrderDeliveryTypeChooseTypeHandle = ^(BOOL typeOfSelfTake){
        LKStrongSelf
        [_self updatePrice];
     
    };
    self.deliveryTypeView.bOrderDeliveryTypeChooseAddressHandle = ^(){
        LKStrongSelf
        if ( self.deliveryTypeView.shadowView.hidden==NO) {
            
        }else{
            
            [_self navigationToSelectAddress];
        }
    };
    [headerView addSubview:self.deliveryTypeView];
    [self.deliveryTypeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(headerView.mas_right);
        make.height.mas_equalTo(200);
    }];
    
    self.remarkView = [[LKOrderRemarkView alloc] init];
    [headerView addSubview:self.remarkView];
    [self.remarkView receiveObject:^(id object) {
        self.orderNote=object;
    }];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.deliveryTypeView.mas_left);
        make.top.mas_equalTo(self.deliveryTypeView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.deliveryTypeView.mas_right);
        make.bottom.mas_equalTo(headerView.mas_bottom).mas_offset(-10);
    }];
    return headerView;
}
- (UIView *) footerView:(NSInteger)indx
{
    LKWeakSelf
    UIView * footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx + 50);
    _remarkView = [[LKOrderRemarkView alloc] init];
    _remarkView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 90);
    [footerView addSubview:_remarkView];
    _payTypeView = [[ReserveChoosePayTypeView alloc] initWithFrame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx)];
    [footerView addSubview:_payTypeView];
    _payTypeView.bChoosePayTypeHandle=^(PayType type)
    {
        LKStrongSelf
        [_self updatePrice];
    };
    return footerView;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.dishesContentTableView mas_makeConstraints:^(MASConstraintMaker *make){
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LKOrderDishesContentCell * cell = [tableView dequeueReusableCellWithIdentifier:[LKOrderDishesContentCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configCellWithData:self.goodsInfoArray[indexPath.row]];
    
    return cell;
}

#pragma mark -
#pragma mark Navigation M

- (void) navigationToPay{
    
    // 跳转至结算付款界面
    [self requestCommitTakeOutOrder];
}

- (void) navigationToSelectAddress{
    
    // 跳转至挑选地址界面
    AddressViewController * vc = [AddressViewController new];
    vc.bSelectAddressHandle = ^(id addressData){
        self.finishPickAddress = YES;
        [self.deliveryTypeView updateAddressInfoWithData:addressData];
    };

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Network M

- (void) requestDefaultAddress{
    
    if (self.finishPickAddress) {
        return;
    }
    [UserServices getDefaultAddressListWithuserId:[KeychainManager readUserId] restaurantId:self.restaurantData[@"id"] completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            id data = responseObject[@"data"];
            [self.deliveryTypeView updateAddressInfoWithData:data];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestCommitTakeOutOrder{
    
    NSString * takeOutType = @"";
    if (self.deliveryTypeView.typeOfSelfTake) {
        takeOutType = @"01";// 自提
    }else{
    
        takeOutType = @"02";// 送货上门
    }
    NSString * addressId = self.deliveryTypeView.addressId;
    NSString * note = self.remarkView.remarkTextView.text;
    
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

    
    [UserServices orderTakeOutWithUserId:[KeychainManager readUserId]
                                userName:[KeychainManager readUserName]
                            restaurantId:self.restaurantData[@"id"]
                          restaurantName:self.restaurantData[@"restaurantName"]
                             takeOutType:takeOutType
                               addressId:addressId
                               orderNote:self.orderNote
                                 payMent:payMent
                         completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            //[UnityLHClass showHUDWithStringAndTime:@"订单提交成功"];
            
            ReservePayViewController * pay = [[ReservePayViewController alloc] init];
            pay.priceInfo = self.bottomView.price;
            pay.orderData = responseObject[@"data"];
            pay.orderType = @"02";
            pay.payType = self.payTypeView.currentSelectPayType;
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
