//
//  GoodsOrderStatusViewModel.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsOrderHandleItem;
@interface GoodsOrderStatusViewModel : NSObject

@property (nonatomic ,strong) id orderData;

// display for orderStatus
@property (nonatomic ,strong) NSString * orderStatus;
@property (nonatomic ,strong) UIColor * orderStatusColor;

@property (nonatomic ,assign) CGFloat cellHeight;
@property (nonatomic ,assign) BOOL hasOrderHandle;
@property (nonatomic ,assign) BOOL isOneNumberShop;//是否为一号店商品
@property (nonatomic ,assign) BOOL isGroupGoods;//是否为团购商品
@property (nonatomic ,assign) BOOL isJDShop;//是否为京东商品
@property (nonatomic ,strong) NSString * createDate;//订单创建时间

@property (nonatomic ,strong) NSArray <GoodsOrderHandleItem *>* orderHandles;

+ (instancetype) viewModelWithData:(id)data;

+ (instancetype) oneNumberShopviewModelWithData:(id)data;

+ (instancetype) groupGoodsOrderListviewModelWithData:(id)data;
+ (instancetype) JDShopviewModelWithData:(id)data;
@end


@interface GoodsOrderHandleItem : NSObject

@property (nonatomic ,assign) BOOL hide;

@property (nonatomic ,strong) NSString * handleTitle;
@property (nonatomic ,strong) UIColor * handleTitleTextColor;

@property (nonatomic ,strong) UIColor * handleBackgroundColor;
@property (nonatomic ,strong) UIColor * handleBorderColor;
@end
