//
//  ChooseCityCell.m
//  LankeProject
//
//  Created by itman on 17/2/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ChooseCityCell.h"

@implementation ChooseCityCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        self.contentView.backgroundColor=BM_WHITE;
        self.cityLb = [UnityLHClass masonryLabel:@"" font:15.0 color:BM_Color_GrayColor];
        [self.contentView addSubview:self.cityLb];
        [self.cityLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(0.5);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(self.mas_width);
        }];
        
        
        
    }
    return self;
}

//所有城市
- (void)loadCityWithData:(id)dataSource
{
    self.cityLb.text = dataSource[@"cityName"];
}



@end
