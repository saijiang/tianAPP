//
//  MyNewCell.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyNewCell.h"
#import "MyNewsModel.h"
@implementation MyNewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MyNewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityHeadCell"];
    if (!cell)
    {
        cell=[[MyNewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommunityHeadCell"];
    }
    return cell;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.title.mas_bottom).offset(10);
    }];
    
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.time.mas_bottom).offset(10);
    }];

    [self.redImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right).offset(3);
        make.top.mas_equalTo(self.title.mas_top).offset(3);
        make.width.and.height.mas_equalTo(6);
    }];

}

-(void)createCell
{
    self.title=[UnityLHClass masonryLabel:@"" font:16.0 color:BM_BLACK];
    [self.contentView addSubview:self.title];
    
    self.time=[UnityLHClass masonryLabel:@"" font:13.0 color:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00]];
    [self.contentView addSubview:self.time];
    
    self.info=[UnityLHClass masonryLabel:@"" font:15.0 color:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.00]];
    self.info.numberOfLines=0;
    [self.contentView addSubview:self.info];
    
    self.redImage = [[UIImageView alloc] init];
    self.redImage.image = [UIImage imageWithColor:BM_RED];
    self.redImage.layer.masksToBounds=YES;
    self.redImage.layer.cornerRadius=6/2;
    [self addSubview:self.redImage];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.info.mas_left);
        make.right.mas_equalTo(self.info.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1.0);
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    MyNewsModel *model=(MyNewsModel *)dataSource;
    self.title.text=model.title;
    self.time.text=model.sendTime;
    self.info.text=model.content;
    self.redImage.hidden=model.readingFlg;
}

@end
