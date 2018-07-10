//
//  RestaurantCell.m
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    RestaurantCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    if (!cell)
    {
        cell=[[RestaurantCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RestaurantCell"];
    }
    return cell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_top).offset(5);
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        
    }];

    [self.priceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_left);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceName.mas_right).offset(1);
        make.centerY.mas_equalTo(self.priceName.mas_centerY);

    }];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.icon.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.priceName.mas_left);
        make.right.mas_lessThanOrEqualTo(self.distance.mas_left).mas_offset(-10);
    }];
    
    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.location.mas_centerY);
    }];

}

-(void)createCell
{
    self.icon=[[NetworkImageView alloc]init];
    [self.contentView addSubview:self.icon];
    
    self.name=[UnityLHClass masonryLabel:@"" font:16.0 color:BM_BLACK];
    [self.contentView addSubview:self.name];
    
    self.priceName=[UnityLHClass masonryLabel:@"人均：" font:13.0 color:BM_BLACK];
    [self.contentView addSubview:self.priceName];
    
    self.price=[UnityLHClass masonryLabel:@"" font:13.0 color:[UIColor colorWithRed:1.00 green:0.54 blue:0.19 alpha:1.00]];
    [self.contentView addSubview:self.price];
    
    self.location=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.location];
    
    self.distance=[UnityLHClass masonryButton:@"" imageStr:@"ding_dingwei" font:14.0 color:[UIColor colorWithRed:0.29 green:0.68 blue:0.84 alpha:1.00]];
    [self.contentView addSubview:self.distance];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"restaurantImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text = dataSource[@"restaurantName"];
    self.price.text = [NSString stringWithFormat:@"￥%.2f",[dataSource[@"perConsume"] floatValue]];
    self.location.text = dataSource[@"restaurantAddress"];
    
    NSString *distanceStr = [NSString stringWithFormat:@"%@",dataSource[@"distance"]];
    [self.distance setTitle:distanceStr forState:UIControlStateNormal];
}



@end
