//
//  NumberOneShopOrderConfirmViewController.h
//  LankeProject
//
//  Created by itman on 17/4/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface NumberOneShopOrderConfirmViewController : BaseViewController

@property (nonatomic ,copy) void (^bOrderDidCommitFinishHandle)();
// 从购物车中选中的数据，结构和购物车中的一样
@property (nonatomic ,strong) NSArray * cartGoodsInfo;
@end
