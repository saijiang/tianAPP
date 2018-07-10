//
//  ChooseCityCell.h
//  LankeProject
//
//  Created by itman on 17/2/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface ChooseCityCell : BaseCollectionCell

@property (nonatomic,strong)UILabel *cityLb;//城市
@property (nonatomic,strong)UIView *lineView;


//所有城市
- (void)loadCityWithData:(id)dataSource;

@end

