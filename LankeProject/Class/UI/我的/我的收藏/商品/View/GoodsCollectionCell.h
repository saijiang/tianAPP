//
//  GoodsCollectionCell.h
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GoodsCollectionCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *goodOriginalPrice;

@end
