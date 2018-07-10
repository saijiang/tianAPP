//
//  RestaurantCell.h
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RestaurantCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *priceName;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *location;
@property(nonatomic,strong)UIButton *distance;

@end
