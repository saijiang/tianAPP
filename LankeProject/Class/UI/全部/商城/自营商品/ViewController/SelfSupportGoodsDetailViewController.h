//
//  SelfSupportGoodsDetailViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface SelfSupportGoodsDetailViewController : BaseViewController

@property(nonatomic,strong)NSString *goodsId;

/** 来源控制器：
    因为有这种情况：店铺列表-店铺-商品详情--店铺
    为了防止过多的内存
 */
//@property (nonatomic ,assign) UIViewController * sourceViewController;

/** 来源控制器：
 因为有这种情况：店铺列表-店铺-商品详情--店铺
 为了防止过多的内存
 */
@property (nonatomic,assign)BOOL isSorce;//替换sourceViewController，防止cpu过高

@end
