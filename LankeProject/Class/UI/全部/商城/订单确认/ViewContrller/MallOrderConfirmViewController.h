//
//  MallOrderConfirmViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface MallOrderConfirmViewController : BaseViewController

@property (nonatomic ,copy) void (^bOrderDidCommitFinishHandle)();

// 从购物车中选中的数据，结构和购物车中的一样
@property (nonatomic ,strong) NSArray * cartGoodsInfo;
/** 订单入口 */
@property (nonatomic ,strong) NSString * orderType;// 03、自营店（提交订单），04、一号店 ， 05、我的订单
@end
