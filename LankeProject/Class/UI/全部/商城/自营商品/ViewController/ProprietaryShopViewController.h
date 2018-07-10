//
//  ProprietaryShopViewController.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodSearchItem.h"

@interface ProprietaryShopViewController : BaseViewController

@property(nonatomic,copy)NSString *merchantId; //店铺ID 用于搜索店铺中的商品
@property(nonatomic,copy)NSString *goodsName;  //  商品名称
@property(nonatomic,strong)GoodSearchItem* searchItem;


@end
