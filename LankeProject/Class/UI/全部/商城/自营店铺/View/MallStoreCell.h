//
//  MallStoreCell.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MallStoreCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *shopIcon;
@property(nonatomic,strong)UILabel *shopName;
@property(nonatomic,strong)UILabel *shopInfo;
@property(nonatomic,strong)UIButton *shopGo;

@end
