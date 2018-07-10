//
//  FitCustomCell.h
//  LankeProject
//
//  Created by 符丹 on 17/7/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface FitCustomCell : BaseTableViewCell

@property (nonatomic,strong) UILabel *monthLab;//月份
@property (nonatomic,strong) UILabel *dateLab;//日期
@property (nonatomic,strong) UIImageView *lineView;//线条
@property (nonatomic,strong) NetworkImageView *imgView;//直播的图片
@property (nonatomic,strong) UILabel *titleLab;//直播标题
@property (nonatomic,strong) UILabel *timeLab;//直播时间
@property (nonatomic,strong) UILabel *contentLab;//直播简介
@property (nonatomic,strong) UIButton *stateBtn;//直播状态

+(CGFloat)getCellHeightWithDataSource:(id)dataSource;

@end
