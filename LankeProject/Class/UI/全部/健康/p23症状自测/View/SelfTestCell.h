//
//  SelfTestCell.h
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface SelfTestCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic ,strong) UILabel * sectionNameLabel;
@property (nonatomic ,strong) LocalhostImageView * sectionImageView;

@end
