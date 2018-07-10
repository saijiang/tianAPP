//
//  JDShopOrderConfirmViewController.h
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface JDShopOrderConfirmViewController : BaseViewController
@property (nonatomic ,copy) void (^bOrderDidCommitFinishHandle)();
// 从购物车中选中的数据，结构和购物车中的一样
@property (nonatomic ,strong) NSArray * cartGoodsInfo;
@end
