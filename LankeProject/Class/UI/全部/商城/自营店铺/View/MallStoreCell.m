
//
//  MallStoreCell.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallStoreCell.h"

@implementation MallStoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MallStoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MallStoreCell"];
    if (!cell)
    {
        cell=[[MallStoreCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MallStoreCell"];
    }
    return cell;
    
}
-(void)createCell
{
    self.shopIcon=[[NetworkImageView alloc]init];
    self.shopIcon.image=[UIImage imageNamed:@"temp_food_photo"];
    [self.contentView addSubview:self.shopIcon];
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-20);
        make.width.mas_equalTo(self.shopIcon.mas_height);
    }];
    
    self.shopName=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.shopName];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(self.shopIcon.mas_right).offset(10);
        make.top.mas_equalTo(self.shopIcon.mas_top);
    }];
    
    self.shopInfo=[UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1.00]];
    self.shopInfo.numberOfLines=2;
    [self.contentView addSubview:self.shopInfo];
    [self.shopInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-60);
        make.left.mas_equalTo(self.shopIcon.mas_right).offset(10);
        make.top.mas_equalTo(self.shopName.mas_bottom).offset(10);
    }];
    
    self.shopGo=[UnityLHClass masonryButton:@"  进店  " imageStr:@"" font:15.0 color:BM_WHITE];
    self.shopGo.userInteractionEnabled=NO;
    [self.contentView addSubview:self.shopGo];
    [self.shopGo setBackgroundImage:[UIImage imageNamed:@"Mall_shopbtn"] forState:UIControlStateNormal];
    [self.shopGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];

    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor colorWithHexString:@"#F5F5F5"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
        
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.shopIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"merchantLogo"]] placeholderImage:[UIImage imageNamed:@"temp_food_photo"]];
    self.shopName.text=dataSource[@"merchantName"];
    self.shopInfo.text=dataSource[@"merchantIntroduction"];
    
}

@end
