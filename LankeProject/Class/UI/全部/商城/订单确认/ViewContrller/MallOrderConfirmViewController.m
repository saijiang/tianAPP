//
//  MallOrderConfirmViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderConfirmViewController.h"
#import "HLLValuationBottomView.h"
#import "MallOrderConfirmGoodsCell.h"
#import "MallOrderConfirmSectionView.h"
#import "DQAlertSheetController.h"
#import "MallOrderPayViewController.h"
#import "MallOrderConfirmAddressView.h"
#import "AddressViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "GroupBuyPayTypeView.h"

@interface MallOrderConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) MallOrderConfirmAddressView * headerView;

@property (nonatomic ,strong) UITableView * orderConfirmTableView;
@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) NSArray * orderInfo;

@property (nonatomic ,strong) NSArray * assistDatas;
@property (nonatomic ,strong) NSArray * buttonArray;
@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;

@property (nonatomic ,strong) NSArray * couponPaymentArray;
@property (nonatomic ,strong) NSString * buttonStr;

@end

@implementation MallOrderConfirmViewController
//计算价格
-(void)getCouponPriceInfo
{
    //    couponPaymentType 	String 	支付类型（01：支付宝, 02：微信 , 03：钱包支付）
    //    payOrderAmount 	String 	实付金额
    //    couponOrderAmount 	String 	优惠金额
    
    NSArray *goosArr = self.cartGoodsInfo;
    NSString *strJson=[JsonManager jsonWithDict:goosArr];
    [UserServices
     getCouponPriceInfoWithstrJson:strJson
     flag:@"02"
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

    NSString *merchantId=[self requestOrderMerchantId];
    NSString *goodsPrice=[self goodsPrice];
    [UserServices
     getOrderPayTypeWithMerchantId:merchantId
     goodAmount:goodsPrice
     flag:@"02"
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
               NSArray*data=responseObject[@"data"];
            if (data.count==0) {
                
                self.bottomView.settleAccountsButton.enabled=NO;
            }else{
                self.bottomView.settleAccountsButton.enabled=YES;

            }
            self.orderConfirmTableView.tableFooterView = [self footerView:data.count];
     

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
    self.title = @"订单确认";
    
    [self requestOrderInfo];
    [self getOrderPayType];
    [self getCouponPriceInfo];
    [self updateSentButton];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //self.orderConfirmTableView.tableHeaderView = [self addressHeaderView];

}

- (void)createUI{

    self.orderConfirmTableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    self.orderConfirmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderConfirmTableView.delegate = self;
    self.orderConfirmTableView.dataSource = self;
    self.orderConfirmTableView.backgroundColor = [UIColor clearColor];
    self.orderConfirmTableView.tableHeaderView = [self addressHeaderView];

    [self.orderConfirmTableView registerClass:[MallOrderConfirmHeaderView class]
           forHeaderFooterViewReuseIdentifier:[MallOrderConfirmHeaderView cellIdentifier]];
    
    [self.orderConfirmTableView registerClass:[MallOrderConfirmGoodsCell class]
                       forCellReuseIdentifier:[MallOrderConfirmGoodsCell cellIdentifier]];
    
    [self.orderConfirmTableView registerClass:[MallOrderConfirmFooterView class]
           forHeaderFooterViewReuseIdentifier:[MallOrderConfirmFooterView cellIdentifier]];
    
    [self addSubview:self.orderConfirmTableView];
    
    LKWeakSelf
    //
    self.bottomView = [[HLLValuationBottomView alloc] init];
    [self.bottomView.settleAccountsButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.bottomView updateBottomViewForHideShopingView];
    self.bottomView.bSettleAccountsHandle = ^(){
        LKStrongSelf
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否确认下单？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
              
                if ([_self.orderType  isEqual: @"04"]) {// 一号店
                    [_self requestCommiteOneShopOrderInfo];
                }else{
                    [_self requestCommiteOrderInfo];
                }
            }
            
        }];
       
    };

    [self addSubview:self.bottomView];
}

- (UIView *) footerView:(NSInteger)indx
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx + 50)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx + 50);
    _payTypeView = [[ReserveChoosePayTypeView alloc] initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy * indx)];
    [footerView addSubview:_payTypeView];
    
    [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footerView.mas_top).offset(10);
        make.left.mas_equalTo(footerView.mas_left);
        make.right.mas_equalTo(footerView.mas_right);
    }];
    footerView.toplineWithColor=[UIColor colorWithHexString:@"DFDFDF"];
    LKWeakSelf
    _payTypeView.bChoosePayTypeHandle=^(PayType type)
    {
        LKStrongSelf
        [_self updateBottomViewPrice];

    };
    return footerView;
}

- (UIView *) addressHeaderView{
    
    LKWeakSelf
    self.headerView = [MallOrderConfirmAddressView view];
    [self.headerView requestDefaultAddress];
    self.headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 80);
    self.headerView.bTapAddressHandle = ^(){
        LKStrongSelf
        AddressViewController * address = [[AddressViewController alloc] init];
        address.bSelectAddressHandle = ^(id addressData){
            
            [_self.headerView updateAddressInfoWithData:addressData];
            if ([_self.orderType  isEqual: @"04"]) {
                
                [_self requestDefaultPriceAddress];
            }
        };
        [_self.navigationController pushViewController:address animated:YES];
    };
    self.headerView.bFinishLoadAddressHandle = ^(){
        LKStrongSelf
        if ([_self.orderType  isEqual: @"04"]) {
            
            [_self requestDefaultPriceAddress];
        }
    };
    return self.headerView;
}
     
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.orderConfirmTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.bottomView.mas_left);
        make.right.mas_equalTo(self.bottomView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-50);
    }];
}

- (void) updateBottomViewPrice{

    //    PayTypeWallet           =1,//钱包支付
    //    PayTypeWX               =2,//微信支付
    //    PayTypeZFB              =3,//支付宝支付
    
    //    couponPaymentType 	String 	支付类型（01：支付宝, 02：微信 , 03：钱包支付）
    //    payOrderAmount 	String 	实付金额
    //    couponOrderAmount 	String 	优惠金额
    
    PayType type= self.payTypeView.currentSelectPayType;
    CGFloat payOrderAmount=0.00;//商品总价
    CGFloat couponOrderAmount=0.00;//商品总价已优惠
    
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
    
    CGFloat expressPrice = 0.0f;//运费
    for (MallAssist * assist in self.assistDatas) {
   
        expressPrice += assist.expressPrice;
    }
    
//    for (int i=0; i<self.cartGoodsInfo.count; i++) {
//        MallAssist*assist=self.assistDatas[i];
//
//        if ([self.cartGoodsInfo[i][@"freeSendFlg"] integerValue]>0&&assist.price>[self.cartGoodsInfo[i][@"freeSendMoney"] floatValue]){
//
//
//
//        }else{
//
//             expressPrice += assist.expressPrice;
//
//
//        }
//
//    }
    

    
  
    
    CGFloat goodsSum=payOrderAmount+expressPrice;//商品总价包括运费
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",goodsSum];
    self.bottomView.price = goodsSum;
    self.bottomView.couponLabel.text=nil;
    if (couponOrderAmount>0) {
        self.bottomView.couponLabel.text=[NSString stringWithFormat:@"(已优惠￥ %.2f)",couponOrderAmount];
    }


    
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * goodsList = self.orderInfo[section][@"listGoods"];
    
    return goodsList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MallOrderConfirmGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:[MallOrderConfirmGoodsCell cellIdentifier] forIndexPath:indexPath];
    
    NSArray * goodsList = self.orderInfo[indexPath.section][@"listGoods"];

    [cell configCellWithData:goodsList[indexPath.row]];

    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [MallOrderConfirmGoodsCell cellHeight];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

   
    MallAssist * assist = self.assistDatas[section];
    
    
    MallOrderConfirmFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MallOrderConfirmFooterView cellIdentifier]];
    if ([self.orderType  isEqual: @"04"])
    {
        [footerView configCellWithOneShopData:assist];

    }
    else
    {
        
        [footerView configCellWithData:assist];
    }
    
    footerView.bChooseTypeHandle = ^(){
        
        
        if ([self.cartGoodsInfo[section][@"freeSendFlg"] integerValue]==0) {
            self.buttonArray = [assist.type deliverySegmentDatas];

        }else{
            
            if (assist.price-assist.expressPrice>=[self.cartGoodsInfo[section][@"freeSendMoney"] floatValue]){
                
                self.buttonArray = [assist.type deliveryFreeSegmentDatas];
                
            }else{
                
                self.buttonArray = [assist.type deliverySegmentDatas];
                
            }
        }
        
   
       
    
    
        DQAlertSheetController * actionSheet = [[DQAlertSheetController alloc] initWithTitle:nil message:nil buttons:self.buttonArray cancelButton:@"取消" afterDismiss:^(DQAlertSheetController * alertSheet ,NSInteger buttonIndex) {
            
            if ([self.cartGoodsInfo[section][@"freeSendFlg"] integerValue]==0)
             {
                 [assist modifyDelieveryAtIndex:buttonIndex];

             }else{
                 
                 if (assist.price-assist.expressPrice>=[self.cartGoodsInfo[section][@"freeSendMoney"] floatValue]){
                     
                     [assist modifyDelieveryFreeAtIndex:buttonIndex];
                     
                 }else{
                     
                     [assist modifyDelieveryAtIndex:buttonIndex];
                 }
                 
             };
        
            
            [self updateSentButton];
            
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            
            [self updateBottomViewPrice];
            
    } cancel:nil];
        
        [actionSheet showSheet:self];
    };
    footerView.bMessageChangeHandle = ^(NSString * message){
        
//        MallAssist * assist = self.assistDatas[section];
        assist.message = message;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };

    return footerView;
}
-(void)updateSentButton
{
   
    
    for (int i=0; i<self.cartGoodsInfo.count; i++) {
        MallAssist*assist=self.assistDatas[i];
      
        if ([self.cartGoodsInfo[i][@"startSendFlg"] integerValue]==0) {
            self.bottomView.settleAccountsButton.enabled=YES;
        }else{
            
            
            if (assist.price-assist.expressPrice<[self.cartGoodsInfo[i][@"startSendMoney"] floatValue]){
                
                
                if([assist.type.shippingName isEqualToString:@"01"]){
                    
                    
                    self.bottomView.settleAccountsButton.enabled=YES;
                    
                }else{
                    
                    
                    self.bottomView.settleAccountsButton.enabled=NO;
                    return;
                }
                
            }else{
                
                self.bottomView.settleAccountsButton.enabled=YES;
                
            }
            
        }
        
        
       
    }
    
    
  
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    MallAssist * assist = self.assistDatas[section];
    return [MallOrderConfirmFooterView cellHeightWithData:assist];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MallOrderConfirmHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MallOrderConfirmHeaderView cellIdentifier]];
    
    [headerView configCellWithData:self.orderInfo[section]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [MallOrderConfirmHeaderView cellHeightWithData:self.orderInfo[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -
#pragma mark Network M

-(NSString *)requestOrderMerchantId
{
    NSMutableArray *merchantIdArr=[[NSMutableArray alloc]init];
    for (MallAssist * assist in self.assistDatas)
    {
        [merchantIdArr addObject:assist.merchantId];
    }
    NSString *merchantId=[merchantIdArr componentsJoinedByString:@","];
    return merchantId;
}
-(NSString *)goodsPrice
{
    CGFloat goodsSum = 0.0f;
    CGFloat expressPrice = 0.0f;
    for (MallAssist * assist in self.assistDatas)
    {
        expressPrice += assist.expressPrice;
        goodsSum += assist.price;
    }
    
    NSString *goodsPrice=[NSString stringWithFormat:@"%.2f",goodsSum-expressPrice];
    return goodsPrice;
}

- (void) requestOrderInfo{
    
    NSArray * datas = self.cartGoodsInfo;
    
    NSMutableArray * temp = [NSMutableArray array];
    for (NSInteger index = 0; index < datas.count; index ++) {
        
        MallAssist * assist = [MallAssist assistCouponWith:datas[index]];
        
        [temp addObject:assist];
    }
    self.assistDatas = temp;
    
    self.orderInfo = datas;
    [self.orderConfirmTableView reloadData];
    [self updateBottomViewPrice];
}

/** 提交一号店订单 */
- (void) requestCommiteOneShopOrderInfo{
    
    NSString * orderList = [self formatterOneShopOrderList];
    
    NSString * addressId = NSStringWithData(self.headerView.addressData[@"id"]);

    [UserServices addYhdGoodsOrderWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] addressId:addressId orderList:orderList completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            
            if (self.bOrderDidCommitFinishHandle) {
                self.bOrderDidCommitFinishHandle();
            }
            id yhdOrderCode = responseObject[@"data"][@"yhdOrderCode"];// 返回订单号
            CGFloat sumPrice = [responseObject[@"data"][@"orderAmount"] floatValue];// 总价格
            
            
            // 去支付界面
            MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
            pay.orderCode = yhdOrderCode;// 订单号
            pay.orderType = self.orderType;
            pay.sumPrice = sumPrice;
            [self.navigationController pushViewController:pay animated:YES];

            [self removeSelfFromNavigationStack];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

// 根据收货地址获取运费
- (void) requestDefaultPriceAddress{
    
    NSString * addressID = self.headerView.addressId;
    
    [UserServices getPostFeeWithaddressId:addressID orderList:[self formatterOneShopOrderList] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            NSString * price = responseObject[@"data"];
            
            MallAssist * assist = self.assistDatas[0];
            [assist modifyExpressPriceForOneShop:[price floatValue]];
            if ([self.orderType  isEqual: @"04"])
            {
                assist.type.deliveryContent = [NSString stringWithFormat:@"快递费：%.2f元",[price floatValue]];
            }
        
            [self.orderConfirmTableView reloadData];
            
            [self updateBottomViewPrice];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

/** 提交自营商品订单 */
- (void) requestCommiteOrderInfo{
    
    if (!self.headerView.isValidAddress) {
        //[UnityLHClass showHUDWithStringAndTime:@"请选择收货地址"];
    }
    
    NSString * orderList = [self formatterOrderList];
    
    NSString * name = NSStringWithData(self.headerView.addressData[@"receiveName"]);
    NSString * phone = NSStringWithData(self.headerView.addressData[@"receivePhone"]);
    NSString * detailAddress = [NSString stringWithFormat:@"%@%@%@%@%@",self.headerView.addressData[@"province"],self.headerView.addressData[@"city"],self.headerView.addressData[@"county"],self.headerView.addressData[@"areaInfo"],self.headerView.addressData[@"detailedAddress"]];
    
    
    NSString * lon = NSStringWithData(self.headerView.addressData[@"addressLongitude"]);
    NSString * lat = NSStringWithData(self.headerView.addressData[@"addressLatitude"]);
    
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
    
    
    [UserServices
     addGoodsOrderWithUserId:[KeychainManager readUserId]
     userName:[KeychainManager readUserName]
     contactName:name
     contactMobile:phone
     deliveryAddress:detailAddress
     addressLongitude:lon
     addressLatitude:lat
     orderList:orderList
     payMent:payMent
     completionBlock:^(int result, id responseObject)
    {
       
        if (result == 0) {
            
            
            if (self.bOrderDidCommitFinishHandle) {
                self.bOrderDidCommitFinishHandle();
            }
            id orderNumber = responseObject[@"data"];// 返回订单号
            // 去支付界面
            MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
            pay.orderCode = orderNumber;
            pay.orderType = self.orderType;
            pay.sumPrice = self.bottomView.price;
            pay.payType = self.payTypeView.currentSelectPayType;// 1钱包支付  2微信支付  3支付宝支付
            [self.navigationController pushViewController:pay animated:YES];
            
            [self removeSelfFromNavigationStack];
            
        }else{
            
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (NSString *) formatterOrderList{
    
    NSMutableArray * orderList = [NSMutableArray array];
    NSInteger index = 0;
    
    for (NSDictionary * data in self.orderInfo) {
        
        MallAssist * assist = self.assistDatas[index];
        NSMutableArray * listGoods = [NSMutableArray array];
        for (NSDictionary * goods in data[@"listGoods"]) {
            
            [listGoods addObject:@{@"cartId": NSStringWithData(goods[@"cartId"]),
                                   @"goodsId": NSStringWithData(goods[@"goodsId"]),
                                  // @"goodsName": goods[@""],
                                   @"marketPrice": goods[@"marketPrice"],
                                   @"salePrice": goods[@"salePrice"],
                                   @"couponPrice": goods[@"couponPrice"],
                                   @"goodsNum": NSStringWithData(goods[@"goodsNum"])}];
        }
        
        NSString*shippingStr=@"";
  
        if ([self.cartGoodsInfo[index][@"freeSendFlg"] integerValue]==0) {
            shippingStr=NSStringWithData(@(assist.expressPrice));

        }else{
            if (assist.price-assist.expressPrice>[self.cartGoodsInfo[index][@"freeSendMoney"] floatValue]){
                
                shippingStr=@"0";
            }else{
                
                shippingStr=NSStringWithData(@(assist.expressPrice));
            }
        };
        
   
        
       
        
        NSDictionary * order = @{@"merchantId":data[@"merchantId"],// 商家id
                                 @"merchantName":data[@"merchantName"],// 商家名称
                                 @"shippingFee":shippingStr,// 运费价格，自提:0,配送对应配送费
                                @"shippingName":NSStringWithData(assist.type.shippingName),// 配送方式
                                 @"leaveMessage":NSStringWithData(assist.message),// 留言
                                 @"listGoods":listGoods};
        [orderList addObject:order];
        index ++;
    }
    
    NSString * jsonOrderList =  [JsonManager jsonWithDict:orderList];
    
    return jsonOrderList;
}

- (NSString *) formatterOneShopOrderList{
    
    NSMutableArray * orderList = [NSMutableArray array];
    NSInteger index = 0;
    
    for (NSDictionary * data in self.orderInfo) {
        
        NSMutableArray * listGoods = [NSMutableArray array];
        for (NSDictionary * goods in data[@"listGoods"]) {
            
            [listGoods addObject:@{@"cartId": NSStringWithData(goods[@"cartId"]),
                                   @"goodsId": NSStringWithData(goods[@"goodsId"]),
                                   @"goodsName": goods[@"goodsName"],
                                   @"marketPrice": goods[@"marketPrice"],
                                   @"goodsNum": NSStringWithData(goods[@"goodsNum"]),
                                   @"productType":NSStringWithData(goods[@"productType"])}];
        }
        NSDictionary * order = @{@"shippingName":@"03",
                                 @"listGoods":listGoods};
        [orderList addObject:order];
        index ++;
    }
    
    NSString * jsonOrderList =  [JsonManager jsonWithDict:orderList];
    
    return jsonOrderList;
}

@end
