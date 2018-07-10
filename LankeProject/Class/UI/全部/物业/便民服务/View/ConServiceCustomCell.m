//
//  ConServiceCustomCell.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ConServiceCustomCell.h"

@implementation ConServiceCustomCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ConServiceCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConServiceCustomCell"];
    if (!cell)
    {
        cell = [[ConServiceCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ConServiceCustomCell"];
    }
    return cell;
}


-(void)createCell
{
    //图片
    self.serviceIcon = [[NetworkImageView alloc]init];
    self.serviceIcon.image = [UIImage imageNamed:@"serviceIconDefault"];
    self.serviceIcon.layer.cornerRadius=10;
    [self.contentView addSubview:self.serviceIcon];
    [self.serviceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.serviceIcon.mas_height);
    }];
    
    //电话
    self.serviceCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.serviceCallBtn setBackgroundImage:[UIImage imageNamed:@"serviceCall"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.serviceCallBtn];
    [self.serviceCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.and.height.mas_equalTo(40);
    }];
    
    //标题
    self.serviceTitle = [UnityLHClass masonryLabel:@"皮耶•加尼叶餐厅" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.serviceTitle];
    [self.serviceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.serviceCallBtn.mas_left).offset(-10);
        make.left.mas_equalTo(self.serviceIcon.mas_right).offset(10);
        make.top.mas_equalTo(self.serviceIcon.mas_top);
    }];
    
    //地址图标
    self.serviceAddressImg = [[LocalhostImageView alloc]initWithImage:[UIImage imageNamed:@"serviceLocation"]];
    [self.contentView addSubview:self.serviceAddressImg];
    [self.serviceAddressImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.serviceIcon.mas_bottom);
        make.left.mas_equalTo(self.serviceTitle.mas_left);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(15);
    }];
    
    //地址内容
    self.serviceAddressLab = [UnityLHClass masonryLabel:@"地址：北京市海淀区南大街39号" font:14.0 color:[UIColor colorWithHexString:@"666666"]];
    [self.contentView addSubview:self.serviceAddressLab];
    [self.serviceAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serviceAddressImg.mas_right).offset(5);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.serviceAddressImg.mas_bottom);
    }];
    
    
    //简介
    self.serviceContent = [UnityLHClass masonryLabel:@"美食是爱情，是艺术，是技术 美食是爱情，是艺术，是技术美食是爱情，是艺术，是技术美食是爱情，是艺术，是技术" font:14.0 color:[UIColor colorWithHexString:@"666666"]];
    self.serviceContent.numberOfLines = 0;
    [self.contentView addSubview:self.serviceContent];
    [self.serviceContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.serviceCallBtn.mas_left).offset(-10);
        make.left.mas_equalTo(self.serviceTitle.mas_left);
        make.top.mas_equalTo(self.serviceTitle.mas_bottom).offset(5);
        make.bottom.mas_lessThanOrEqualTo(self.serviceAddressImg.mas_top).offset(-5);
        
    }];
    
    
}

//cell赋值
-(void)loadCellWithDataSource:(id)dataSource
{
    [self.serviceIcon sd_setImageWithURL:dataSource[@"merchantImageList"]];
    self.serviceTitle.text=dataSource[@"merchantName"];
    self.serviceContent.text=dataSource[@"merchantSimpleInfo"];
    self.serviceAddressLab.text=dataSource[@"merchantAddress"];


}


@end
