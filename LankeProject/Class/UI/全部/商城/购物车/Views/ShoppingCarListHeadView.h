//
//  ShoppingCarListHeadView.h
//  LankeProject
//
//  Created by Justin on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideChooseManager.h"
#import "LKCellProtocol.h"

@interface ShoppingCarListHeadView : UITableViewHeaderFooterView<LKCellProtocol>

//商家名称
@property (nonatomic, strong) UILabel *merchantName;
//商家名称
@property (nonatomic, strong) UILabel *startSendMoney;
@property (nonatomic, strong) NSString *isTypeShop;

//选择按钮
@property (nonatomic, strong) UIButton *chooseBtn;
//右按钮
@property (nonatomic, strong) LocalhostImageView *rightImage;

@property (nonatomic ,strong) UIView * lineView;

//block
@property (nonatomic,copy) void (^HShoppingCarHeadChooseHandle)();
@end
