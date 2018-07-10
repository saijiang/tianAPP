//
//  ReserveChoosePayTypeView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kTopHeight
#define kTopHeight  45
#endif

#ifndef kMargin
#define kMargin 15
#endif

#ifndef kCommentHeight
#define kCommentHeight 60
#endif

typedef NS_OPTIONS(NSInteger, PayType)
{
    PayTypeWallet           =1,//钱包支付
    PayTypeWX               =2,//微信支付
    PayTypeZFB              =3,//支付宝支付
};

#import "ModyPasswordViewController.h"

@interface ReserveChoosePayTypeItemView : UIView

@property (nonatomic ,strong) LocalhostImageView * iconImageView;
@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UILabel * couponLabel;
@property (nonatomic ,strong) UILabel * detailLabel;
@property (nonatomic ,strong) LocalhostImageView * chooseImageView;
@property (nonatomic ,assign) PayType payType;
@property (nonatomic ,assign) float price;//商品的优惠之后的价格
@property (nonatomic ,assign) float couponOrderAmount;//商品优惠的价格

@end

@interface ReserveChoosePayTypeView : UIView

@property (nonatomic ,copy) void (^bChoosePayTypeHandle)(PayType type);
@property (nonatomic ,assign) PayType currentSelectPayType;// 1钱包支付  2微信支付  3支付宝支付
@property (nonatomic ,assign) float currentPrice;//商品的优惠之后的价格
@property (nonatomic ,assign) float couponOrderAmount;//商品优惠的价格

@property (nonatomic ,strong) UILabel * noteLabel;


- (void) configChoosePayTypeViewWithData:(id)data;

- (void) configPay:(PayType)payType;

- (void) configShopOnePay;
- (void) configJDShopPay;



@end

@interface ReservePayAmountView : UIView

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) UILabel * amountLabel;

- (void) configPayAmountWithData:(CGFloat)data;

@end
