//
//  TakeOutDetailViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface TakeOutDetailViewController : BaseViewController

@property (nonatomic ,strong) id dishesData;

/** 默认都是显示 */
@property (nonatomic ,assign) BOOL hasBottomView;


@property (nonatomic ,assign) BOOL hasShoppingCar;

@property (nonatomic ,strong) id shoppingData;
@property (nonatomic ,strong) id orderInfo;// 订座-点菜-订单
@property (nonatomic ,strong) id restaurantData;
@property (nonatomic ,strong) id takeOutOrderInfo;
@property (nonatomic ,strong) id reservationInfo;// 预定信息
@end
