//
//  ShoppingCarListFootView.h
//  LankeProject
//
//  Created by Justin on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideChooseManager.h"
#import "LKCellProtocol.h"

@interface ShoppingCarListFootView : UITableViewHeaderFooterView<LKCellProtocol>

@property (nonatomic, strong) UIView *labelView;

@property (nonatomic, strong) UILabel *priceLB;

@property (nonatomic, strong) UIView *lineView;

@end
