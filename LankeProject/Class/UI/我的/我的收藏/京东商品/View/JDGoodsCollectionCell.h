//
//  JDGoodsCollectionCell.h
//  LankeProject
//
//  Created by zhounan on 2017/12/20.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDGoodsCollectionCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *goodOriginalPrice;
@end
