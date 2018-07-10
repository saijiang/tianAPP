//
//  TakeOutListViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface TakeOutListViewController : BaseViewController

/** 
 （01、点餐，02、外卖）
 */
@property (nonatomic ,strong) NSString * takeOutType;
@property (nonatomic ,strong) id restaurantData;
@end
