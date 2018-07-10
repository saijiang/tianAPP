//
//  ConfirmReserveViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"

/** 周边餐厅->餐厅列表->餐厅详情->订座->点餐->`确定预定`*/
@interface ConfirmReserveViewController : BaseViewController

// 餐厅信息
@property (nonatomic ,strong) id restaurantData;

// 预定信息
@property (nonatomic ,strong) id reservationInfo;

// 点菜信息
@property (nonatomic ,strong) id orderInfo;


@end
