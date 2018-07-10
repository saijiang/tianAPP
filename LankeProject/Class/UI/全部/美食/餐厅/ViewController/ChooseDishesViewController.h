//
//  ChooseDishesViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"

/** 周边餐厅->餐厅列表->餐厅详情->订座(带过去订单号)->`点餐`->确定预定->支付*/
@interface ChooseDishesViewController : BaseViewController

/** 
 YES：订座 
 */
@property (nonatomic ,assign ,getter=isReservation) BOOL reservation;

// 预定信息
@property (nonatomic ,strong) id reservationInfo;

// 餐厅信息
@property (nonatomic ,strong) id restaurantData;

@property (nonatomic, assign) int flag;// 100 - 在线订座



@end
