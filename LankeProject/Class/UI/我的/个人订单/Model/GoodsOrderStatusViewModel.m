//
//  GoodsOrderStatusViewModel.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GoodsOrderStatusViewModel.h"

@implementation GoodsOrderStatusViewModel

+ (instancetype) oneNumberShopviewModelWithData:(id)data
{
    GoodsOrderStatusViewModel * viewModel = [[self alloc] init];
    viewModel.isOneNumberShop=YES;
    viewModel.orderData = data;
    [viewModel oneNumberShopformatOrderStatus];
    [viewModel oneNumberShopformatOrderHandle];
    
    return viewModel;
}
- (void) oneNumberShopformatOrderStatus
{
    NSString * status;
    UIColor * color;
    CGFloat cellHeight = 0;
    
    CGFloat width = DEF_SCREEN_WIDTH - 15 - 30;
    CGFloat x = (width - 3 * 10) / 4;
    
    cellHeight = 15 + 20 + 5 + 20 + 1/[UIScreen mainScreen].scale + 10 + x + 10 + 1/[UIScreen mainScreen].scale + 10 + 30 + 10;
    self.hasOrderHandle = YES;

    if ([self.orderData[@"orderStatus"] integerValue] == 34) {// 已取消
        status = @"已取消";
        color = [UIColor colorWithHexString:@"cdcdcd"];
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 3||[self.orderData[@"orderStatus"] integerValue] == 0) {// 待付款
        status = @"待付款";
        color = [UIColor colorWithHexString:@"#FF696E"];
    }
 if ([self.orderData[@"orderStatus"] integerValue] == 38||[self.orderData[@"orderStatus"] integerValue] == 4){// 待发货
        color = [UIColor colorWithHexString:@"FFB478"];
        status = @"待发货";
        self.hasOrderHandle = NO;
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 20) {// 待收货
        status = @"待收货";
        color = BM_Color_Blue;
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 37) {// 待收货
        status = @"送货失败";
        color = BM_Color_Blue;
        self.hasOrderHandle = NO;
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 24) {// 已收货
        status = @"待评价";
        color = [UIColor colorWithHexString:@"FFB478"];
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 35) {// 已完成
        status = @"已完成";
        color =BM_Color_Blue;
        self.hasOrderHandle = NO;
    }
    
    self.orderStatusColor = color;
    self.orderStatus = status;
    self.cellHeight = cellHeight;

}
- (void) oneNumberShopformatOrderHandle
{
    //订单状态（3-未支付 4-已支付 20-已出库 24-已收货 34-已取消 35-已完成 37-送货失败 38-待发货）

    if ([self.orderData[@"orderStatus"] integerValue] == 34) {// 已取消
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        self.orderHandles = @[hideItem,deleteItem];
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 3||[self.orderData[@"orderStatus"] integerValue] == 0) {// 待付款
        
        GoodsOrderHandleItem * cancelItem = [[GoodsOrderHandleItem alloc] init];
        cancelItem.handleTitle = @"取消订单";
        cancelItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        cancelItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        cancelItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * payItem = [[GoodsOrderHandleItem alloc] init];
        payItem.handleTitle = @"去付款";
        payItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        payItem.handleBackgroundColor = BM_Color_Blue;
        payItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[cancelItem,payItem];
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 38||[self.orderData[@"orderStatus"] integerValue] == 4) {// 待发货
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        self.orderHandles = @[hideItem,hideItem];
        //self.orderHandles = nil;
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 20) {// 待收货
        
        GoodsOrderHandleItem * confirmItem = [[GoodsOrderHandleItem alloc] init];
        confirmItem.handleTitle = @"确认收货";
        confirmItem.hide = YES;
        confirmItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        confirmItem.handleBackgroundColor = BM_Color_Blue;
        confirmItem.handleBorderColor = BM_Color_Blue;
        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[confirmItem,logisticsItem];
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 37) {// 送货失败
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];

        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.hide = YES;
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[logisticsItem,deleteItem,];

    }

    if ([self.orderData[@"orderStatus"] integerValue] == 24) {// 待评价
        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        GoodsOrderHandleItem * commentItem = [[GoodsOrderHandleItem alloc] init];
        commentItem.handleTitle = @"评价";
        commentItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        commentItem.handleBackgroundColor = [UIColor colorWithHexString:@"#F2BB5A"];
        commentItem.handleBorderColor = [UIColor colorWithHexString:@"#F2BB5A"];
        
        self.orderHandles = @[logisticsItem,commentItem];
    }
    if ([self.orderData[@"orderStatus"] integerValue] == 35) {// 已完成
        
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        self.orderHandles = @[hideItem,deleteItem];
    }

}
+ (instancetype) JDShopviewModelWithData:(id)data
{
    GoodsOrderStatusViewModel * viewModel = [[self alloc] init];
    viewModel.isJDShop=YES;
    viewModel.orderData = data;
    [viewModel JDShopformatOrderStatus];
    [viewModel JDShopformatOrderHandle];
    
    return viewModel;
}
- (void) JDShopformatOrderStatus
{
    NSString * status;
    UIColor * color;
    CGFloat cellHeight = 0;
    
    CGFloat width = DEF_SCREEN_WIDTH - 15 - 30;
    CGFloat x = (width - 3 * 10) / 4;
    //01 待付款 02 已付款，待收货 03 妥投 04拒收 05 已取消
    cellHeight = 15 + 20 + 5 + 20 + 1/[UIScreen mainScreen].scale + 10 + x + 10 + 1/[UIScreen mainScreen].scale + 10 + 30 + 10;
    self.hasOrderHandle = YES;
    switch ([self.orderData[@"state"] integerValue]) {
        case 1:
        {
            status = @"待付款";
            color = [UIColor colorWithHexString:@"#FF696E"];
        }
            break;
        case 2:
        {
            status = @"待收货";
            color = BM_Color_Blue;
            self.hasOrderHandle = NO;

        }
            
            break;
        case 3:
        {
            status = @"已完成";
            color =BM_Color_Blue;
            //self.hasOrderHandle = NO;
        }
            
            break;
        case 4:
        {
            status = @"拒收";
            color = BM_Color_Blue;
            self.hasOrderHandle = NO;
        }
            
            break;
        case 5:
        {
            status = @"已取消";
            color = [UIColor colorWithHexString:@"cdcdcd"];
            self.hasOrderHandle = NO;

        }
            
            break;
            
        default:
            break;
    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 34) {// 已取消
//        status = @"已取消";
//        color = [UIColor colorWithHexString:@"cdcdcd"];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 3||[self.orderData[@"orderStatus"] integerValue] == 0) {// 待付款
//        status = @"待付款";
//        color = [UIColor colorWithHexString:@"#FF696E"];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 38||[self.orderData[@"orderStatus"] integerValue] == 4){// 待发货
//        color = [UIColor colorWithHexString:@"FFB478"];
//        status = @"待发货";
//        self.hasOrderHandle = NO;
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 20) {// 待收货
//        status = @"待收货";
//        color = BM_Color_Blue;
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 37) {// 待收货
//        status = @"送货失败";
//        color = BM_Color_Blue;
//        self.hasOrderHandle = NO;
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 24) {// 已收货
//        status = @"待评价";
//        color = [UIColor colorWithHexString:@"FFB478"];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 35) {// 已完成
//        status = @"已完成";
//        color =BM_Color_Blue;
//        self.hasOrderHandle = NO;
//    }
//    
    self.orderStatusColor = color;
    self.orderStatus = status;
    self.cellHeight = cellHeight;
    
}
- (void) JDShopformatOrderHandle
{
    //订单状态01 待付款 02 已付款，待收货 03 妥投 04拒收 05 已取消

    switch ([self.orderData[@"state"] integerValue]) {
        case 1:
        {
            GoodsOrderHandleItem * cancelItem = [[GoodsOrderHandleItem alloc] init];
            cancelItem.handleTitle = @"取消订单";
            cancelItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
            cancelItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
            cancelItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
            
            GoodsOrderHandleItem * payItem = [[GoodsOrderHandleItem alloc] init];
            payItem.handleTitle = @"去付款";
            payItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
            payItem.handleBackgroundColor = BM_Color_Blue;
            payItem.handleBorderColor = BM_Color_Blue;
            
            self.orderHandles = @[cancelItem,payItem];
        }
            break;
        case 2:
        {
            GoodsOrderHandleItem * confirmItem = [[GoodsOrderHandleItem alloc] init];
            confirmItem.handleTitle = @"确认收货";
            confirmItem.hide = NO;
            confirmItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
            confirmItem.handleBackgroundColor = BM_Color_Blue;
            confirmItem.handleBorderColor = BM_Color_Blue;
            
            GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
            logisticsItem.handleTitle = @"查看物流";
            logisticsItem.handleTitleTextColor = BM_Color_Blue;
            logisticsItem.handleBackgroundColor = BM_WHITE;
            logisticsItem.handleBorderColor = BM_Color_Blue;
            
            self.orderHandles = @[logisticsItem,confirmItem];

            
//            GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
//            logisticsItem.handleTitle = @"查看物流";
//            logisticsItem.handleTitleTextColor = BM_Color_Blue;
//            logisticsItem.handleBackgroundColor = BM_WHITE;
//            logisticsItem.handleBorderColor = BM_Color_Blue;
//            
//            self.orderHandles = @[logisticsItem];
        }
            
            break;
        case 3:
        {
           
            
            GoodsOrderHandleItem * commentItem = [[GoodsOrderHandleItem alloc] init];
            commentItem.handleTitle = @"去评价";
            commentItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
            commentItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
            commentItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
            
            GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
            deleteItem.handleTitle = @"删除订单";
            deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
            deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
            deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
            
           
            
            
            if ([self.orderData[@"isEvaluate"] integerValue] == 1)
            {
                commentItem.hide = YES;
//                commentItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//                commentItem.handleBackgroundColor = [UIColor colorWithHexString:@"#F2BB5A"];
//                commentItem.handleBorderColor = [UIColor colorWithHexString:@"#F2BB5A"];
            }
            else
            {
                commentItem.handleTitle = @"评价";
                commentItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
                commentItem.handleBackgroundColor = [UIColor colorWithHexString:@"#F2BB5A"];
                commentItem.handleBorderColor = [UIColor colorWithHexString:@"#F2BB5A"];
            }
            
           self.orderHandles = @[commentItem,deleteItem];
            
        }
            
            break;
        case 4:
        {
        
        }
            
            break;
        case 5:
        {
            GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
            deleteItem.handleTitle = @"删除订单";
            deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
            deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
            deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
            
//            GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
//            hideItem.hide = YES;
            
            //self.orderHandles = @[hideItem,deleteItem];
            self.orderHandles = @[deleteItem];


        }
            
            break;
            
        default:
            break;
    }
    
    
//    if ([self.orderData[@"orderStatus"] integerValue] == 34) {// 已取消
//        
//        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
//        deleteItem.handleTitle = @"删除订单";
//        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
//        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
//        
//        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
//        hideItem.hide = YES;
//        
//        self.orderHandles = @[hideItem,deleteItem];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 3||[self.orderData[@"orderStatus"] integerValue] == 0) {// 待付款
//        
//        GoodsOrderHandleItem * cancelItem = [[GoodsOrderHandleItem alloc] init];
//        cancelItem.handleTitle = @"取消订单";
//        cancelItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        cancelItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
//        cancelItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
//        
//        GoodsOrderHandleItem * payItem = [[GoodsOrderHandleItem alloc] init];
//        payItem.handleTitle = @"去付款";
//        payItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        payItem.handleBackgroundColor = BM_Color_Blue;
//        payItem.handleBorderColor = BM_Color_Blue;
//        
//        self.orderHandles = @[cancelItem,payItem];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 38||[self.orderData[@"orderStatus"] integerValue] == 4) {// 待发货
//        
//        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
//        hideItem.hide = YES;
//        
//        self.orderHandles = @[hideItem,hideItem];
//        //self.orderHandles = nil;
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 20) {// 待收货
//        
//        GoodsOrderHandleItem * confirmItem = [[GoodsOrderHandleItem alloc] init];
//        confirmItem.handleTitle = @"确认收货";
//        confirmItem.hide = YES;
//        confirmItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        confirmItem.handleBackgroundColor = BM_Color_Blue;
//        confirmItem.handleBorderColor = BM_Color_Blue;
//        
//        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
//        logisticsItem.handleTitle = @"查看物流";
//        logisticsItem.handleTitleTextColor = BM_Color_Blue;
//        logisticsItem.handleBackgroundColor = BM_WHITE;
//        logisticsItem.handleBorderColor = BM_Color_Blue;
//        
//        self.orderHandles = @[confirmItem,logisticsItem];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 37) {// 送货失败
//        
//        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
//        deleteItem.handleTitle = @"删除订单";
//        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
//        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
//        
//        
//        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
//        logisticsItem.handleTitle = @"查看物流";
//        logisticsItem.hide = YES;
//        logisticsItem.handleTitleTextColor = BM_Color_Blue;
//        logisticsItem.handleBackgroundColor = BM_WHITE;
//        logisticsItem.handleBorderColor = BM_Color_Blue;
//        
//        self.orderHandles = @[logisticsItem,deleteItem,];
//        
//    }
//    
//    if ([self.orderData[@"orderStatus"] integerValue] == 24) {// 待评价
//        
//        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
//        logisticsItem.handleTitle = @"查看物流";
//        logisticsItem.handleTitleTextColor = BM_Color_Blue;
//        logisticsItem.handleBackgroundColor = BM_WHITE;
//        logisticsItem.handleBorderColor = BM_Color_Blue;
//        
//        GoodsOrderHandleItem * commentItem = [[GoodsOrderHandleItem alloc] init];
//        commentItem.handleTitle = @"评价";
//        commentItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        commentItem.handleBackgroundColor = [UIColor colorWithHexString:@"#F2BB5A"];
//        commentItem.handleBorderColor = [UIColor colorWithHexString:@"#F2BB5A"];
//        
//        self.orderHandles = @[logisticsItem,commentItem];
//    }
//    if ([self.orderData[@"orderStatus"] integerValue] == 35) {// 已完成
//        
//        
//        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
//        deleteItem.handleTitle = @"删除订单";
//        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
//        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
//        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
//        
//        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
//        hideItem.hide = YES;
//        
//        self.orderHandles = @[hideItem,deleteItem];
//    }
    
}


+ (instancetype)viewModelWithData:(id)data{

    GoodsOrderStatusViewModel * viewModel = [[self alloc] init];
    
    viewModel.orderData = data;

    [viewModel formatOrderStatus];
    [viewModel formatOrderHandle];
    
    return viewModel;
}

- (void) formatOrderStatus{
    
    NSString * status;
    UIColor * color;
    CGFloat cellHeight = 0;
    
    CGFloat width = DEF_SCREEN_WIDTH - 15 - 30;
    CGFloat x = (width - 3 * 10) / 4;
    
    cellHeight = 15 + 20 + 5 + 20 + 1/[UIScreen mainScreen].scale + 10 + x + 10 + 1/[UIScreen mainScreen].scale + 10 + 30 + 10;
    self.hasOrderHandle = YES;
    if ([self.orderData[@"orderState"] integerValue] == 1) {// 已取消
        status = @"已取消";
        color = [UIColor colorWithHexString:@"cdcdcd"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 2) {// 待付款
        status = @"待付款";
        color = [UIColor colorWithHexString:@"#FF696E"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 3) {// 待发货
        status = @"待发货";
        color = [UIColor colorWithHexString:@"FFB478"];
        self.hasOrderHandle = NO;
    }
    if ([self.orderData[@"orderState"] integerValue] == 4) {// 待收货
        status = @"待收货";
        color = BM_Color_Blue;
    }
    if ([self.orderData[@"orderState"] integerValue] == 5) {// 待评价
        status = @"待评价";
        color = [UIColor colorWithHexString:@"FFB478"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 6) {// 已完成
        status = @"已完成";
        color = BM_Color_Blue;
    }
    
    self.orderStatusColor = color;
    self.orderStatus = status;
    self.cellHeight = cellHeight;
}

- (void) formatOrderHandle{
    
    if ([self.orderData[@"orderState"] integerValue] == 1) {// 已取消
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        self.orderHandles = @[hideItem,deleteItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 2) {// 待付款
        
        GoodsOrderHandleItem * cancelItem = [[GoodsOrderHandleItem alloc] init];
        cancelItem.handleTitle = @"取消订单";
        cancelItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        cancelItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        cancelItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * payItem = [[GoodsOrderHandleItem alloc] init];
        payItem.handleTitle = @"去付款";
        payItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        payItem.handleBackgroundColor = BM_Color_Blue;
        payItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[cancelItem,payItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 3) {// 待发货
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        self.orderHandles = @[hideItem,hideItem];
        //self.orderHandles = nil;
    }
    if ([self.orderData[@"orderState"] integerValue] == 4) {// 待收货
        
        // 配送方式（01：客户自提， 02：自家配送， 03：快递配送）
        NSInteger shippingName = [self.orderData[@"shippingName"] integerValue];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        GoodsOrderHandleItem * confirmItem = [[GoodsOrderHandleItem alloc] init];
        confirmItem.handleTitle = @"确认收货";
        confirmItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        confirmItem.handleBackgroundColor = BM_Color_Blue;
        confirmItem.handleBorderColor = BM_Color_Blue;
        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[shippingName == 3 ? logisticsItem : hideItem,confirmItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 5) {// 待评价
        
        // 配送方式（01：客户自提， 02：自家配送， 03：快递配送）
        NSInteger shippingName = [self.orderData[@"shippingName"] integerValue];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        GoodsOrderHandleItem * commentItem = [[GoodsOrderHandleItem alloc] init];
        commentItem.handleTitle = @"评价";
        commentItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        commentItem.handleBackgroundColor = [UIColor colorWithHexString:@"#F2BB5A"];
        commentItem.handleBorderColor = [UIColor colorWithHexString:@"#F2BB5A"];
        
        self.orderHandles = @[shippingName == 3 ? logisticsItem : hideItem,commentItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 6) {// 已完成
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[hideItem,deleteItem];
    }
}

+ (instancetype) groupGoodsOrderListviewModelWithData:(id)data
{
    
    GoodsOrderStatusViewModel * viewModel = [[self alloc] init];
    viewModel.isGroupGoods=YES;
    viewModel.orderData = data;
    [viewModel groupformatOrderStatus];
    [viewModel groupformatOrderHandle];
    return viewModel;
}

-(void)groupformatOrderStatus
{
    //订单状态（01：未成团 ，02：待商家确认， 03：商家确认-未成团， 04：待发货，05：待收货 ， 06：已完成 ）
    NSString * status;
    UIColor * color;
    CGFloat cellHeight = 0;
    
    CGFloat width = DEF_SCREEN_WIDTH - 15 - 30;
    CGFloat x = (width - 3 * 10) / 4;
    
    cellHeight = 15 + 20 + 5 + 20 + 1/[UIScreen mainScreen].scale + 10 + x + 10 + 1/[UIScreen mainScreen].scale + 10 + 30 + 10;
    self.hasOrderHandle = YES;
    if ([self.orderData[@"orderState"] integerValue] == 1)
    {// 未成团
        status = @"未成团";
        color = [UIColor colorWithHexString:@"cdcdcd"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 2)
    {// 待商家确认款
        status = @"待商家确认";
        color = [UIColor colorWithHexString:@"#FF696E"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 3)
    {// 商家确认-未成团
        status = @"未成团";
        color = [UIColor colorWithHexString:@"FFB478"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 4)
    {// 待发货
        status = @"待发货";
        color = BM_Color_Blue;
    }
    if ([self.orderData[@"orderState"] integerValue] == 5)
    {// 待收货
        status = @"待收货";
        color = [UIColor colorWithHexString:@"FFB478"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 6)
    {// 已完成
        status = @"已完成";
        color = BM_Color_Blue;
    }
    if ([self.orderData[@"orderState"] integerValue] == 7) {// 已取消
        
        status = @"已取消";
        color = [UIColor colorWithHexString:@"cdcdcd"];
    }
    if ([self.orderData[@"orderState"] integerValue] == 8) {// 待付款
        status = @"待付款";
        color = [UIColor colorWithHexString:@"#FF696E"];
    }
    
    self.orderStatusColor = color;
    self.orderStatus = status;
    self.cellHeight = cellHeight;

}
-(void)groupformatOrderHandle
{
    //订单状态（01：未成团 ，02：待商家确认， 03：未成团 ， 04：待发货，05：待收货 ， 06：已完成 ，07：已取消 ，08：待支付） ）
    if ([self.orderData[@"orderState"] integerValue] == 1)
    {// 未成团
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
//        if ([self.orderData[@"isEndStatus"] integerValue] == 1) {// 是否截止（01：截止时间已到 ，02：截止时间未到）
//            self.orderHandles = @[hideItem,deleteItem];
//        }else{
//        }
        self.orderHandles = @[hideItem,hideItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 2)
    {// 待商家确认
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        self.orderHandles = @[hideItem,hideItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 3)
    {// 商家确认-未成团
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];

        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
//        if ([self.orderData[@"isEndStatus"] integerValue] == 1) {// 是否截止（01：截止时间已到 ，02：截止时间未到）
//        }else{
//            self.orderHandles = @[hideItem,hideItem];
//        }
        self.orderHandles = @[hideItem,deleteItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 4)
    {// 待发货
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        self.orderHandles = @[hideItem,hideItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 5)
    {// 待收货
        
        // 配送方式（01：客户自提， 02：自家配送， 03：快递配送）
        NSInteger shippingName = [self.orderData[@"shippingName"] integerValue];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        
        GoodsOrderHandleItem * confirmItem = [[GoodsOrderHandleItem alloc] init];
        confirmItem.handleTitle = @"确认收货";
        confirmItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        confirmItem.handleBackgroundColor = BM_Color_Blue;
        confirmItem.handleBorderColor = BM_Color_Blue;
        
        GoodsOrderHandleItem * logisticsItem = [[GoodsOrderHandleItem alloc] init];
        logisticsItem.handleTitle = @"查看物流";
        logisticsItem.handleTitleTextColor = BM_Color_Blue;
        logisticsItem.handleBackgroundColor = BM_WHITE;
        logisticsItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[shippingName == 3 ? logisticsItem : hideItem,confirmItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 6||[self.orderData[@"orderState"] integerValue] == 7)
    {// 已完成
        
        GoodsOrderHandleItem * deleteItem = [[GoodsOrderHandleItem alloc] init];
        deleteItem.handleTitle = @"删除订单";
        deleteItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        deleteItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        deleteItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        GoodsOrderHandleItem * hideItem = [[GoodsOrderHandleItem alloc] init];
        hideItem.hide = YES;
        self.orderHandles = @[hideItem,deleteItem];
    }
    if ([self.orderData[@"orderState"] integerValue] == 8) {// 待付款
        
        GoodsOrderHandleItem * cancelItem = [[GoodsOrderHandleItem alloc] init];
        cancelItem.handleTitle = @"取消订单";
        cancelItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        cancelItem.handleBackgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        cancelItem.handleBorderColor = [UIColor colorWithHexString:@"cdcdcd"];
        cancelItem.hide=YES;
        GoodsOrderHandleItem * payItem = [[GoodsOrderHandleItem alloc] init];
        payItem.handleTitle = @"去付款";
        payItem.handleTitleTextColor = [UIColor colorWithHexString:@"ffffff"];
        payItem.handleBackgroundColor = BM_Color_Blue;
        payItem.handleBorderColor = BM_Color_Blue;
        
        self.orderHandles = @[cancelItem,payItem];
    }

}
@end

@implementation GoodsOrderHandleItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hide = NO;
    }
    return self;
}
@end


/*
 orderState	String	
 订单状态
 01：已取消 (999999)， 取消订单(999999/ffffff)
 02：待付款 (red)， 取消订单(999999/ffffff) 和 去付款(blue/ffffff)
 03：待发货 (yellow)， none
 04：待收货 (blue)， 查看物流(ffffff/blue) 和 确认收货(blue/ffffff)
 05：待评价 (yellow)， 查看物流(ffffff/blue) 和 评价(yellow/ffffff)
 06：已完成 ， ui上不显示这个状态
 
 */
