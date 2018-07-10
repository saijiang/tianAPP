//
//  CommunityApplyListCell.m
//  LankeProject
//
//  Created by itman on 17/4/24.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityApplyListCell.h"


@interface CommunityApplyListCell()

@property(nonatomic,strong)NetworkImageView *userIcon;
@property(nonatomic,strong)UILabel *userName;

@property(nonatomic,strong)UIButton *applyButton;
@property(nonatomic,strong)UIButton *noApplyButton;


@end

@implementation CommunityApplyListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CommunityApplyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityApplyListCell"];
    if (!cell)
    {
        cell=[[CommunityApplyListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommunityApplyListCell"];
    }
    return cell;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.userIcon.mas_height);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.userIcon.mas_right).offset(15);
    }];
    
    [self.noApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
    }];

    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.noApplyButton.mas_left).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);

    }];
}

-(void)createCell
{
    self.userIcon=[[NetworkImageView alloc]init];
    self.userIcon.layer.masksToBounds=YES;
    self.userIcon.layer.cornerRadius=(70-30)/2.0;
    [self.contentView addSubview:self.userIcon];
    
    self.userName=[UnityLHClass masonryLabel:@"Queenie" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.userName];
    
    self.applyButton=[UnityLHClass masonryButton:@"同意" font:14.0 color:BM_WHITE];
    self.applyButton.layer.masksToBounds=YES;
    self.applyButton.layer.cornerRadius=5;
    self.applyButton.backgroundColor=BM_Color_Blue;
    [self.contentView addSubview:self.applyButton];
    
    self.noApplyButton=[UnityLHClass masonryButton:@"拒绝" font:14.0 color:BM_WHITE];
    self.noApplyButton.layer.masksToBounds=YES;
    self.noApplyButton.layer.cornerRadius=5;
    self.noApplyButton.backgroundColor=BM_RED;
    [self.contentView addSubview:self.noApplyButton];
    
    UIView *line=[[UIView alloc]init];
    [self.contentView addSubview:line];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIcon.mas_left);
        make.right.mas_equalTo(self.noApplyButton.mas_right);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.applyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //同意
        [self sendObject:@"03"];
    }];
    [self.noApplyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //不同意
        [self sendObject:@"02"];
    }];
}

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"headImage"]]];
    self.userName.text=dataSource[@"nickName"];
    
}

@end
