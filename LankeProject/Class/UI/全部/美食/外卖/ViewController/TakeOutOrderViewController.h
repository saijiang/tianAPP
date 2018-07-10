//
//  TakeOutOrderViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface TakeOutOrderViewController : BaseViewController

/** 餐厅信息 */
@property (nonatomic ,strong) id restaurantData;

/** 购物车信息 */
@property (nonatomic ,strong) id takeOutOrderInfo;

/** 订单信息 */
@property (nonatomic ,strong) id orderData;
@end
