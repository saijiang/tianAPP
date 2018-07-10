//
//  JDShopOrderConfirmViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDShopOrderConfirmViewController.h"
#import "HLLValuationBottomView.h"
#import "MallOrderConfirmGoodsCell.h"
#import "MallOrderConfirmSectionView.h"
#import "DQAlertSheetController.h"
#import "MallOrderPayViewController.h"
#import "MallOrderConfirmAddressView.h"
#import "AddressViewController.h"
#import "JDAddressViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "GroupBuyPayTypeView.h"
//发票
#import "JDInvoiceViewController.h"

@interface JDShopOrderConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary * fapiaoData;//发票选中的信息
}

@property (nonatomic ,strong) MallOrderConfirmAddressView * headerView;

@property (nonatomic ,strong) UITableView * orderConfirmTableView;
@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) NSArray * orderInfo;

@property (nonatomic ,strong) NSArray * assistDatas;
@property (nonatomic ,strong) ReserveChoosePayTypeView * payTypeView;
/*
 selectedInvoiceTitle     是     string     发票类型：4个人，5单位
 companyName     是     string     发票抬头 (如果selectedInvoiceTitle=5则此字段必须)
 invoiceContent     是     string     1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细
 */
@property (nonatomic,strong)NSString *selectedInvoiceTitle;
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *companyNum;

@property (nonatomic,strong)NSString *invoiceContent;


@end

@implementation JDShopOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    
    _selectedInvoiceTitle = @"4";
    _companyName = nil;
    _companyNum = nil;

    _invoiceContent = @"1";
//    fapiaoData = [[NSMutableDictionary alloc]init];
    [self requestOrderInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)createUI{
    
    self.orderConfirmTableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    self.orderConfirmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderConfirmTableView.delegate = self;
    self.orderConfirmTableView.dataSource = self;
    self.orderConfirmTableView.tableHeaderView = [self addressHeaderView];
    self.orderConfirmTableView.tableFooterView = [self footerView];

    self.orderConfirmTableView.backgroundColor = [UIColor clearColor];
    
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
                [_self requestCommiteJDShopOrderInfo];
                
            }
        }];
        
    };
    
    [self addSubview:self.bottomView];
}
- (UIView *) footerView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy  + 50)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy  + 50);
    _payTypeView = [[ReserveChoosePayTypeView alloc] initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, kTopHeightGroupBuy + kCommentHeightGroupBuy )];
    [footerView addSubview:_payTypeView];
    
    [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footerView.mas_top).offset(10);
        make.left.mas_equalTo(footerView.mas_left);
        make.right.mas_equalTo(footerView.mas_right);
    }];
    
    [_payTypeView configJDShopPay];
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
    [self.headerView requestJDDefaultAddress];
    self.headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 80);
    self.headerView.bTapAddressHandle = ^(){
        LKStrongSelf
        JDAddressViewController * address = [[JDAddressViewController alloc] init];
        address.bSelectAddressHandle = ^(id addressData){
            [_self.headerView updateJDAddressInfoWithData:addressData];
            [_self requestDefaultPriceAddress];
            
        };
        [_self.navigationController pushViewController:address animated:YES];
    };
    self.headerView.bFinishLoadJDAddressHandle = ^(){
        LKStrongSelf
        [_self requestDefaultPriceAddress];
        
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
    
    CGFloat goodsSum = 0.0f;
    
    for (MallAssist * assist in self.assistDatas) {
        
        goodsSum += assist.price;
    }
    self.bottomView.price = goodsSum;
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsSum];
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
    
    [cell configJDShopCellWithData:goodsList[indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MallOrderConfirmGoodsCell cellHeight];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    MallAssist * assist = self.assistDatas[section];
    MallOrderConfirmFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MallOrderConfirmFooterView cellIdentifier]];
    __weak MallOrderConfirmFooterView * view = footerView;
    [footerView configCellWithJDShopData:assist];
    footerView.bChooseTypeHandle = ^(){
        
        //发票信息
        JDInvoiceViewController *vc = [[JDInvoiceViewController alloc]init];
        vc.data = fapiaoData;
        [vc receiveObject:^(id object) {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                _selectedInvoiceTitle = object[@"selectedInvoiceTitle"];
                _companyName = object[@"companyName"];
                _companyNum = object[@"regcode"];

                _invoiceContent = object[@"invoiceContent"];
                NSString *titleStr = [NSString stringWithFormat:@"电子发票(%@)",object[@"title"]];
                fapiaoData = [[NSMutableDictionary alloc]initWithDictionary:object];
                [view.jDInvoiceBtn setTitle:titleStr forState:UIControlStateNormal];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
//        NSArray * buttons = [assist.type deliverySegmentDatas];
//
//        DQAlertSheetController * actionSheet = [[DQAlertSheetController alloc] initWithTitle:nil message:nil buttons:buttons cancelButton:@"取消" afterDismiss:^(DQAlertSheetController * alertSheet ,NSInteger buttonIndex) {
//
//            [assist modifyDelieveryAtIndex:buttonIndex];
//
//            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//
//            [self updateBottomViewPrice];
//        } cancel:nil];
//
//        [actionSheet showSheet:self];
    };
    footerView.bMessageChangeHandle = ^(NSString * message){
        //        MallAssist * assist = self.assistDatas[section];
        assist.message = message;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
   // MallAssist * assist = self.assistDatas[section];
    return [MallOrderConfirmFooterView cellHeight];
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

- (void) requestOrderInfo{
    
    NSArray * datas = self.cartGoodsInfo;
    
    NSMutableArray * temp = [NSMutableArray array];
    for (NSInteger index = 0; index < datas.count; index ++) {
        
        MallAssist * assist = [MallAssist assistWith:datas[index]];
        [temp addObject:assist];
    }
    self.assistDatas = temp;
    
    self.orderInfo = datas;
    [self.orderConfirmTableView reloadData];
    
    [self updateBottomViewPrice];
}

/** 提交京东店订单 */
- (void) requestCommiteJDShopOrderInfo{
    
    NSArray*bgArray= [self formatterJDShopOrderList];
    NSMutableArray*goodListArray=[NSMutableArray array];
    
    
    for (NSDictionary*dic in bgArray) {

        for (int i = 0; i < [dic[@"listGoods"] count]; i++)
        {
            [goodListArray addObject:dic[@"listGoods"][i]];
        }
        
    }
    NSString * jsonOrderList =  [JsonManager jsonWithDict:goodListArray];
    
    NSString * addressId = NSStringWithData(self.headerView.addressData[@"id"]);
   // NSString * addressId = self.headerView.addressData[@"id"];

    [UserServices addJDGoodsOrderWithUserId:[KeychainManager readUserId]
                                  addressId:addressId
                                     remark:nil
                                  orderList:jsonOrderList
                       selectedInvoiceTitle:_selectedInvoiceTitle
                                companyName:_companyName
                                    regcode:_companyNum
                             invoiceContent:_invoiceContent
                            completionBlock:^(int result, id responseObject)
     {
        if (result == 0) {
            NSDictionary*resultDic=responseObject[@"data"];
            
            if ([resultDic[@"success"] isEqualToString:@"1"]) {
                if (self.bOrderDidCommitFinishHandle) {
                    self.bOrderDidCommitFinishHandle();
                }
                id yhdOrderCode = resultDic[@"result"][@"jdOrderId"];// 返回订单号
                //                CGFloat sumPrice = [resultDic[@"result"][@"orderPrice"] floatValue];// 总价格
                // 去支付界面
                MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
                pay.orderCode = yhdOrderCode;// 订单号
                pay.orderType = @"07";
                //                pay.skuId=resultDic[@"result"][@"sku"][0][@"skuId"];
               // pay.sumPrice = self.bottomView.price;
                [self.navigationController pushViewController:pay animated:YES];
                
                [self removeSelfFromNavigationStack];
                
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:resultDic[@"resultMessage"]];
                
            }
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    

//    [UserServices addYhdGoodsOrderWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] addressId:addressId orderList:orderList completionBlock:^(int result, id responseObject) {
//        
//        if (result == 0) {
//            
//            if (self.bOrderDidCommitFinishHandle) {
//                self.bOrderDidCommitFinishHandle();
//            }
//            id yhdOrderCode = responseObject[@"data"][@"yhdOrderCode"];// 返回订单号
//            CGFloat sumPrice = [responseObject[@"data"][@"orderAmount"] floatValue];// 总价格
//            // 去支付界面
//            MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
//            pay.orderCode = yhdOrderCode;// 订单号
//            pay.orderType = @"04";
//            pay.sumPrice = sumPrice;
//            [self.navigationController pushViewController:pay animated:YES];
//            
//            [self removeSelfFromNavigationStack];
//        }else{
//            // error handle here
//            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//        }
//    }];
}

// 根据收货地址获取运费
- (void) requestDefaultPriceAddress{
    
    NSArray*bgArray= [self formatterJDShopOrderList];
    NSMutableArray*goodListArray=[NSMutableArray array];
    for (NSDictionary*dic in bgArray) {
        [goodListArray addObjectsFromArray:dic[@"listGoods"]];
    }
    NSString * jsonOrderList =  [JsonManager jsonWithDict:goodListArray];
    
    [UserServices getJDPostFeeWithsku:jsonOrderList province:self.headerView.addressData[@"province"] city:self.headerView.addressData[@"city"]  county: self.headerView.addressData[@"county"]  completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            NSString * price = responseObject[@"data"];
            MallAssist * assist = self.assistDatas[0];
            [assist modifyExpressPriceForJDShop:[price floatValue]];
            assist.type.deliveryContent = [NSString stringWithFormat:@"快递费：%.2f元",[price floatValue]];
            [self.orderConfirmTableView reloadData];
            [self updateBottomViewPrice];

            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    
    
//    NSString * addressID = self.headerView.addressId;
//    
//    [UserServices getPostFeeWithaddressId:addressID orderList:[self formatterOneShopOrderList] completionBlock:^(int result, id responseObject) {
//        
//        if (result == 0) {
//            
//            NSString * price = responseObject[@"data"];
//            MallAssist * assist = self.assistDatas[0];
//            [assist modifyExpressPriceForOneShop:[price floatValue]];
//            assist.type.deliveryContent = [NSString stringWithFormat:@"快递费：%.2f元",[price floatValue]];
//            [self.orderConfirmTableView reloadData];
//            [self updateBottomViewPrice];
//
//        }else{
//            // error handle here
//            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//        }
//    }];
}

- (NSArray*) formatterJDShopOrderList{
    
    NSMutableArray * orderList = [NSMutableArray array];
    NSInteger index = 0;
    
    for (NSDictionary * data in self.orderInfo) {
        
        MallAssist * assist = self.assistDatas[index];
        NSMutableArray * listGoods = [NSMutableArray array];
        for (NSDictionary * goods in data[@"listGoods"])
        {
            
            [listGoods addObject:@{@"cartId": NSStringWithData(goods[@"cartId"]),
                                   @"goodsId": NSStringWithData(goods[@"goodsId"]),
                                   @"goodsName": goods[@"goodsName"],
                                   @"marketPrice": goods[@"marketPrice"],
                                   @"goodsNum": NSStringWithData(goods[@"goodsNum"]),
                                   @"skuId":NSStringWithData(goods[@"goodsId"]),
                                   @"num":NSStringWithData(goods[@"goodsNum"])
                                   
                                   }];
        }
        NSDictionary * order = @{@"merchantId":data[@"merchantId"],// 商家id
                                 @"merchantName":data[@"merchantName"],// 商家名称
                                 @"shippingFee":NSStringWithData(@(assist.expressPrice)),// 运费价格，自提:0,配送对应配送费
                                 @"shippingName":NSStringWithData(assist.type.shippingName),// 配送方式
                                 @"leaveMessage":NSStringWithData(assist.message),// 留言
                                 @"listGoods":listGoods};
        [orderList addObject:order];
        index ++;
    }
    
//    NSString * jsonOrderList =  [JsonManager jsonWithDict:orderList];
    
    return orderList;
}

//- (NSString *) formatterJDShopOrderList{
//    
//    NSMutableArray * orderList = [NSMutableArray array];
//    NSInteger index = 0;
//    
//    for (NSDictionary * data in self.orderInfo) {
//        
//        NSMutableArray * listGoods = [NSMutableArray array];
//        NSString*sku=@"";
//         NSString*num=@"";
//        for (NSDictionary * goods in data[@"listGoods"]) {
//            
//            [listGoods addObject:@{@"cartId": NSStringWithData(goods[@"cartId"]),
//                                   @"goodsId": NSStringWithData(goods[@"goodsId"]),
//                                   @"goodsName": goods[@"goodsName"],
//                                   @"marketPrice": goods[@"marketPrice"],
//                                   @"goodsNum": NSStringWithData(goods[@"goodsNum"]),
//                                   @"productType":NSStringWithData(goods[@"productType"])}];
//            sku=NSStringWithData(goods[@"goodsId"]);
//            num=NSStringWithData(goods[@"goodsNum"]);
//        }
//        NSDictionary * order = @{@"shippingName":@"03",
//                                 @"listGoods":listGoods,
//                                 @"goodsId": sku,
//                                 @"goodsNum": num,
//                                 @"cartId": @""
//                                 };
//        [orderList addObject:order];
//        index ++;
//    }
//    
//    NSString * jsonOrderList =  [JsonManager jsonWithDict:orderList];
//    
//    return jsonOrderList;
//}

@end

