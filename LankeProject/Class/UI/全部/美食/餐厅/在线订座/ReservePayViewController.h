//
//  ReservePayViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"
#import "ReserveChoosePayTypeView.h"

/** 周边餐厅->餐厅列表->餐厅详情->订座->点餐->确定预定->`支付`*/
@interface ReservePayViewController : BaseViewController

/** 01 订座
    02 点餐
    03、自营店（提交订单）
    04、一号店
    05、我的订单
 */
@property (nonatomic ,strong) NSString * orderType;
/** 订单价格 */
@property (nonatomic ,assign) CGFloat priceInfo;

/** 订单信息，需要用到：订单号+钱包余额 */
@property (nonatomic ,strong) id orderData;

@property (nonatomic ,assign) PayType payType;


@end
