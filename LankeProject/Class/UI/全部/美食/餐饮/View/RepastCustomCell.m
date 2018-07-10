//
//  RepastCustomCell.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RepastCustomCell.h"


@implementation RepastCustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.selectionStyle=UICollectionViewCellSelectionStyleNone;
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        self.iconImageView.userInteractionEnabled = YES;
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.clipsToBounds = YES;
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        
        self.titleLab = [UnityLHClass masonryLabel:@"周边餐厅" font:20.0 color:BM_WHITE];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self.iconImageView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
            make.width.mas_equalTo(self.iconImageView.mas_width);
            make.top.mas_equalTo(self.iconImageView.mas_top).offset(30);
        }];
        
    }
    return self;
}

-(void)loadRepastCustomCellWithDataSource:(id)dataSource
{
    self.iconImageView.image = [UIImage imageNamed:dataSource[@"image"]];
    self.titleLab.text = dataSource[@"title"];
}

@end
