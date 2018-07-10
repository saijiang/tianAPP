//
//  ShoppingCarCell.h
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "lkstepview.h"
#import "LKCellProtocol.h"
#import "SideChooseManager.h"

@interface ShoppingCarListCell : BaseTableViewCell<LKCellProtocol>

//选中按钮
@property (nonatomic, strong) UIButton *leftBtn;
//商品图片
@property (nonatomic, strong) NetworkImageView *goodsImage;
//商品标题
@property (nonatomic, strong) UILabel *goodsTitle;
//价格
@property (nonatomic, strong) UILabel *priceLB;
//原始价格
@property (nonatomic, strong) UILabel *goodOriginalPrice;
//数量块
@property (nonatomic, strong) LKStepView *stepView;

//分割线
@property (nonatomic, strong) UIView *line;

@property (nonatomic ,copy) void (^bChooseHandle)(BOOL isSelected);


- (void) configOneShopCellWithData:(ChooseItem *)item;
- (void) configJDShopCellWithData:(ChooseItem *)item;

@end

