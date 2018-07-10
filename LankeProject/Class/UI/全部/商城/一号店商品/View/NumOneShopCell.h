//
//  NumOneShopCell.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface NumOneShopCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *goodIcon;
@property(nonatomic,strong)UIButton *isBuy;
@property(nonatomic,strong)UILabel *goodName;
@property(nonatomic,strong)LocalhostImageView *goodlog;
@property(nonatomic,strong)UILabel *goodNum;
@property(nonatomic,strong)UILabel *goodPrice;
@property(nonatomic,strong)UIButton *goodBuy;

@end
