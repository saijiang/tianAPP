//
//  SeeMemberCell.m
//  LankeProject
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SeeMemberCell.h"


@interface SeeMemberCell()

@property(nonatomic,strong)NetworkImageView *headImage;

@property(nonatomic,strong)UILabel  *nickName;
@property(nonatomic,strong)UILabel  *mobileNum;
@property(nonatomic,strong)UILabel  *joinAssociationTime;




@end

@implementation SeeMemberCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    SeeMemberCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SeeMemberCell"];
    if (!cell)
    {
        cell=[[SeeMemberCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SeeMemberCell"];
        
    }
    return cell;
    
}

-(void)createCell
{
    self.headImage=[[NetworkImageView alloc]init];
    [self.contentView addSubview:self.headImage];
    self.headImage.image=[UIImage imageNamed:@"Community_pic"];
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=30;
  
    
    self.nickName=[UnityLHClass  masonryLabel:@"张小二" font:16.0 color:BM_BLACK];
    [self.contentView addSubview:self.nickName];
  
    

    self.mobileNum=[UnityLHClass  masonryLabel:@"17721011700" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.mobileNum];
    
    
    self.joinAssociationTime=[UnityLHClass  masonryLabel:@"2017年-3月" font:14.0 color:BM_GRAY];
    [self.contentView addSubview:self.joinAssociationTime];
    
    self.pullBtn=[UnityLHClass masonryButton:@"拉黑" font:15 color:BM_WHITE];
    [self.pullBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF505D"]] forState:UIControlStateNormal];
    self.pullBtn.layer.masksToBounds=YES;
    
    self.pullBtn.layer.cornerRadius=5;
    [self.contentView addSubview:self.pullBtn];
    
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_top).offset(-10);
        make.left.mas_equalTo(self.headImage.mas_right).offset(20);
    }];
    [self.mobileNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickName.mas_bottom).offset(10);
        make.left.mas_equalTo(self.headImage.mas_right).offset(20);
    }];
    
    [self.joinAssociationTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mobileNum.mas_bottom).offset(10);
        make.left.mas_equalTo(self.headImage.mas_right).offset(20);
    }];
    
    [self.pullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}
-(void)loadCellWithDataSource:(id)dataSource
{
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dataSource[@"headImage"]]];
    self.nickName.text=dataSource[@"nickName"];
    self.mobileNum.text=[NSString stringWithFormat:@"手机号:%@",dataSource[@"mobileNum"]];
    
   NSString*timeStr =[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd HH:mm" andTimeString:dataSource[@"joinAssociationTime"]];
     self.joinAssociationTime.text=[NSString stringWithFormat:@"进群时间:%@",timeStr];

}
@end
