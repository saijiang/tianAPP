//
//  ReservationOrderInfoViewController.h
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"
#import "FoodOrderStatusViewModel.h"

@interface ReservationOrderInfoViewController : BaseViewController

@property (nonatomic ,strong) FoodOrderStatusViewModel * viewModel;

@property (nonatomic ,copy) void (^bDeleteOrderHandle)();
@end
