//
//  ProprietaryCell.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProprietaryCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *goodIcon;
@property(nonatomic,strong)UILabel *goodName;
@property(nonatomic,strong)UIButton *goodlog;
@property(nonatomic,strong)UILabel *goodPrice;
@property(nonatomic,strong)UILabel *goodOriginalPrice;
@property(nonatomic,strong)UIButton *goodBuy;

@end
