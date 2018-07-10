//
//  GroupBuyPayViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupBuyPayViewController : BaseViewController
@property (nonatomic ,copy) void (^bOrderDidCommitFinishHandle)();

/** 从团购详情界面传递商品信息 */
@property (nonatomic ,strong) id payData;
// 从购物车中选中的数据，结构和购物车中的一样
@property (nonatomic ,strong) NSArray * cartGoodsInfo;
/** 订单入口 */
@property (nonatomic ,strong) NSString * orderType;// 03、自营店（提交订单），04、一号店 ， 05、我的订单
@property (nonatomic ,strong) NSString * timeStr;// 03、自营店（提交订单），04、一号店 ， 05、我的订单


@end
