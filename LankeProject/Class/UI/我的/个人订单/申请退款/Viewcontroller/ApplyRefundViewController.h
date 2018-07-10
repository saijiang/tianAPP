//
//  ApplyRefundViewController.h
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@class ApplyRefundModel;

@interface ApplyRefundViewController : BaseViewController

@property(nonatomic,strong)ApplyRefundModel *model;

@end

@interface ApplyRefundModel : NSObject
//orderCode 	是 	string 	订单号
//goodsId 	是 	string 	商品id
//goodsName 	是 	string 	商品名称
//goodsPrice 	是 	string 	商品价格
//goodsNum 	是 	string 	商品数量
//merchantId 	是 	string 	商家id
//merchantName 	是 	string 	商家名称
//orderType 	是 	string 	订单类型：01、自营商城订单，02、一号店订单
@property(nonatomic,strong)NSString *orderCode;
@property(nonatomic,strong)NSString *merchantId;
@property(nonatomic,strong)NSString *merchantName;

@property(nonatomic,strong)NSString *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *goodsPrice;
@property(nonatomic,strong)NSString *goodsNum;
@property(nonatomic,strong)NSString *orderType;



+ (instancetype)ApplyRefundModelModelWithData:(id)data withIndex:(NSInteger)index;

+ (instancetype)ApplyOneShopRefundModelModelWithData:(id)data withIndex:(NSInteger)index;

+ (instancetype)ApplyRefundModelModelWithData:(id)data;
@end
