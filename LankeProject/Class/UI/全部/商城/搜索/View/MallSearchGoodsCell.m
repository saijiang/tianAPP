//
//  MallGoodsCell.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSearchGoodsCell.h"

@implementation MallSearchGoodsCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.goodIcon =[[NetworkImageView alloc]init];
        self.goodIcon.image=[UIImage imageNamed:@"temp_food_photo"];
        [self.contentView addSubview:self.goodIcon];
        
        self.goodName=[UnityLHClass masonryLabel:@"零食" font:13.0 color:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1.00]];
        self.goodName.textAlignment=NSTextAlignmentCenter;
        self.goodName.numberOfLines=0;
        [self.contentView addSubview:self.goodName];
        
        [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        [self.goodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.goodName.mas_top);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.width.mas_equalTo(self.goodIcon.mas_height);
            
        }];
    }
    return self;
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.goodName.text=dataSource[@"classNameThird"];
    [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"classImage"]] placeholderImage:[UIImage imageNamed:@"temp_food_photo"]];
}

+(NSString*)cellIdentifier
{
    return @"MallGoodsCell";
}

@end
