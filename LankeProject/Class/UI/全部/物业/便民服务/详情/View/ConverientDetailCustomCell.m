//
//  ConverientDetailCustomCell.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ConverientDetailCustomCell.h"

@implementation ConverientDetailCustomCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createCell];
    }
    return self;
}

-(void)createCell
{
    self.backgroundColor = BM_WHITE;
    
    self.detailIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"serviceDetail_icon1"]];
    [self addSubview:self.detailIcon];
    [self.detailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    
    self.detailLab = [UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    self.detailLab.numberOfLines=0;
    [self addSubview:self.detailLab];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.detailIcon.mas_right).offset(15);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.detailIcon.mas_left);
        make.right.mas_equalTo(-15);
    }];
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.detailIcon.image = [UIImage imageNamed:dataSource[@"image"]];
    self.detailLab.text = dataSource[@"title"];
}

@end
