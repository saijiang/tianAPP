//
//  RepastCustomCell.h
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface RepastCustomCell : BaseCollectionCell

@property(nonatomic,strong)UIImageView *iconImageView;//图片
@property(nonatomic,strong)UILabel *titleLab;//标题

-(void)loadRepastCustomCellWithDataSource:(id)dataSource;

@end
