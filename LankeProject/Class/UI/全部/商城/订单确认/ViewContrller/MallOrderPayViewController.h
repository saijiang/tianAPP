//
//  MallOrderPayViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

#import "ReserveChoosePayTypeView.h"


@interface MallOrderPayViewController : BaseViewController

#pragma mark -
#pragma mark 展示使用

@property (nonatomic ,assign) CGFloat sumPrice;

#pragma mark -
#pragma mark 提交使用

//订单类型：03、自营店（提交订单），04、一号店 ， 05、我的订单、06：团购订单 07：京东

@property (nonatomic ,strong) NSString * orderType;
@property (nonatomic ,strong) NSString * skuId;


/** 订单号 */
@property (nonatomic ,strong) NSString * orderCode;
@property (nonatomic ,strong) NSString * timeStr;
@property (nonatomic ,strong) NSString * typeStr;


@property (nonatomic ,assign) PayType payType;

@end
