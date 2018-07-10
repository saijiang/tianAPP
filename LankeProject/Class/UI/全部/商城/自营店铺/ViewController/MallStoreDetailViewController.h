//
//  MallStoreDetailViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface MallStoreDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *merchantId;

/** 来源商品的id
    有这样一种情况:商品1 - 店铺 - 商品2(跳转)
                            - 商品1(返回)
    为了减少内存可以`商品2`也做成返回，不跳转
 */
@property (nonatomic ,copy) NSString * sourceGoodsId;

//2017.08.10
@property (nonatomic,strong)NSDictionary *webData;//

@end
