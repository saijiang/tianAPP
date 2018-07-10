//
//  DiningRoomCell.h
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface DiningRoomCell : BaseCollectionCell

@property(nonatomic,strong)UIImageView *iconImageView;//图片
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *addressLab;//地址
@property(nonatomic,strong)UILabel *distanceLab;//距离
@property(nonatomic,strong)LocalhostImageView *locationIcon;//定位图标

-(void)loadDiningRoomCellWithDataSource:(id)dataSource;

@end
