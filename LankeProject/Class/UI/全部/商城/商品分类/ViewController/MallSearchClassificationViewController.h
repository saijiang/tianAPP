//
//  MallSearchInfoViewController.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodSearchItem.h"

@interface MallSearchClassificationViewController : BaseViewController

@property(nonatomic,strong)GoodSearchItem *item;
@property(nonatomic,assign)NSInteger seletedNum;

@end
