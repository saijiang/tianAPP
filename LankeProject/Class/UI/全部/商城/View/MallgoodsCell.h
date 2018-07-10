//
//  MallgoodsCell.h
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "LKCellProtocol.h"

@interface MallgoodsCell : BaseCollectionCell<LKCellProtocol>

@property(nonatomic,strong)NetworkImageView *mallIcon;
@property(nonatomic,strong)UILabel *mallName;
@property(nonatomic,strong)UILabel *mallEvaluation;
@property(nonatomic,strong)UILabel *mallPrice;
@property(nonatomic,strong)UIButton *mallBuy;

@property (nonatomic ,strong) UILabel * couponPriceLabel;
@property (nonatomic ,strong) UIView  * couponPricelineView;

+(CGSize)getCGSizeWithDataSource:(id)dataSource;

@end
