//
//  GroupBuyDetailViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupBuyDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *goodsId;

/** 来源控制器：
 因为有这种情况：店铺列表-店铺-商品详情--店铺
 为了防止过多的内存
 */
@property (nonatomic ,assign) UIViewController * sourceViewController;
@end
