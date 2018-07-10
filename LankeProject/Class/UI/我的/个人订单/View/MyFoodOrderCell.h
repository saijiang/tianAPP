//
//  MyFoodOrderCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"
#import "FoodOrderStatusViewModel.h"

@interface MyFoodOrderCell : UITableViewCell<LKCellProtocol>

@property (nonatomic ,strong) FoodOrderStatusViewModel * viewModel;

+ (CGFloat) cellHeightWithOrderType:(NSString *)orderType;


@end
