//
//  MallOrderConfirmViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "NumberOneShopOrderConfirmViewController.h"
#import "HLLValuationBottomView.h"
#import "MallOrderConfirmGoodsCell.h"
#import "MallOrderConfirmSectionView.h"
#import "DQAlertSheetController.h"
#import "MallOrderPayViewController.h"
#import "MallOrderConfirmAddressView.h"
#import "AddressViewController.h"
#import "ReserveChoosePayTypeView.h"
#import "GroupBuyPayTypeView.h"

@interface NumberOneShopOrderConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) MallOrderConfirmAddressView * headerView;

@property (nonatomic ,strong) UITableView * orderConfirmTableView;
@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) NSArray * orderInfo;

@property (nonatomic ,strong) NSArray * assistDatas;

@end

@implementation NumberOneShopOrderConfirmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    
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
                [_self requestCommiteOneShopOrderInfo];
               
            }
        }];
        
    };
    
    [self addSubview:self.bottomView];
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
            [_self requestDefaultPriceAddress];
            
        };
        [_self.navigationController pushViewController:address animated:YES];
    };
    self.headerView.bFinishLoadAddressHandle = ^(){
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
    
    [cell configOneShopCellWithData:goodsList[indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MallOrderConfirmGoodsCell cellHeight];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    MallAssist * assist = self.assistDatas[section];
    
    MallOrderConfirmFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MallOrderConfirmFooterView cellIdentifier]];
    [footerView configCellWithOneShopData:assist];
    footerView.bChooseTypeHandle = ^(){
        
        NSArray * buttons = [assist.type deliverySegmentDatas];
        
        DQAlertSheetController * actionSheet = [[DQAlertSheetController alloc] initWithTitle:nil message:nil buttons:buttons cancelButton:@"取消" afterDismiss:^(DQAlertSheetController * alertSheet ,NSInteger buttonIndex) {
            
            [assist modifyDelieveryAtIndex:buttonIndex];
            
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
            pay.orderType = @"04";
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
            assist.type.deliveryContent = [NSString stringWithFormat:@"快递费：%.2f元",[price floatValue]];
            [self.orderConfirmTableView reloadData];
            [self updateBottomViewPrice];
            
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
                                   @"goodsName": goods[@"goodsName"],
                                   @"marketPrice": goods[@"marketPrice"],
                                   @"goodsNum": NSStringWithData(goods[@"goodsNum"])}];
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
