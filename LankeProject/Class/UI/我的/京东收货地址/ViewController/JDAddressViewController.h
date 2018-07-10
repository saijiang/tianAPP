//
//  JDAddressViewController.h
//  LankeProject
//
//  Created by zhounan on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface JDAddressViewController : BaseViewController
@property (nonatomic ,copy) void (^bSelectAddressHandle)(id addressData);
@end
