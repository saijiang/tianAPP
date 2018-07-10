//
//  ShopCollectCell.m
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ShopCollectCell.h"

@implementation ShopCollectCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ShopCollectCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ShopCollectCell"];
    if (!cell)
    {
        cell=[[ShopCollectCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ShopCollectCell"];
    }
    return cell;
    
}

-(void)createCell
{
    self.icon=[[NetworkImageView alloc]init];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    self.name=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
        make.top.mas_equalTo(self.icon.mas_top).offset(5);
    }];
    
    self.info=[UnityLHClass masonryLabel:@"" font:13.0 color:BM_Color_GrayColor];
    self.info.numberOfLines=2;
    [self.contentView addSubview:self.info];
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
        make.top.mas_equalTo(self.name.mas_bottom).offset(10);
    }];
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.icon.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"merchantLogo"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dataSource[@"merchantName"];
    self.info.text=dataSource[@"merchantIntroduction"];
    
}


@end
