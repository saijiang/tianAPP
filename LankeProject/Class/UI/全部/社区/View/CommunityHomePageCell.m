//
//  CommunityHomePageCell.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHomePageCell.h"

@interface CommunityHomePageCell()

@property(nonatomic,strong)NetworkImageView *communityIcon;
@property(nonatomic,strong)UIButton *communityStatus;

@property(nonatomic,strong)UILabel *communityTitle;
@property(nonatomic,strong)UIButton *communityClassification;
@property(nonatomic,strong)UILabel *communityTime;
@property(nonatomic,strong)UILabel *communityAddress;
@property(nonatomic,strong)UILabel *communityContact;
@property(nonatomic,strong)UILabel *communityIntroduction;

@end

@implementation CommunityHomePageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CommunityHomePageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityHomePageCell"];
    if (!cell)
    {
        cell=[[CommunityHomePageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommunityHomePageCell"];
        
    }
    return cell;
    
}

-(void)createCell
{
    self.communityIcon=[[NetworkImageView alloc]init];
    [self.contentView addSubview:self.communityIcon];
    self.communityIcon.image=[UIImage imageNamed:@"Community_pic"];
    self.communityIcon.layer.masksToBounds=YES;
    self.communityIcon.layer.cornerRadius=5;
    
    self.communityStatus=[UnityLHClass masonryButton:@"报名中" font:13.0 color:BM_WHITE];
    [self.contentView addSubview:self.communityStatus];
    self.communityStatus.userInteractionEnabled=NO;
    [self.communityStatus setBackgroundImage:[UIImage imageNamed:@"Community_baoming"] forState:UIControlStateNormal];
    [self.communityStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.communityIcon.mas_right);
        make.left.mas_equalTo(self.communityIcon.mas_left);
        make.bottom.mas_equalTo(self.communityIcon.mas_bottom);
    }];

    self.communityTitle=[UnityLHClass  masonryLabel:@"全民炫跑活动召集令" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.communityTitle];
    [self.communityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.communityIcon.mas_top);
        make.left.mas_equalTo(self.communityIcon.mas_right).offset(5);
    }];
    
    self.communityClassification=[UnityLHClass masonryButton:@"热门活动" font:12.0 color:BM_WHITE];
    [self.contentView addSubview:self.communityClassification];
    self.communityClassification.userInteractionEnabled=NO;
    [self.communityClassification setBackgroundImage:[UIImage imageNamed:@"Community_biaoqian"] forState:UIControlStateNormal];
    [self.communityClassification mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-10);
//         make.right.mas_lessThanOrEqualTo(-15);
//        make.left.mas_equalTo(self.communityTitle.mas_right).offset(5);
        make.centerY.mas_equalTo(self.communityTitle.mas_centerY);
        make.width.mas_equalTo(70);
    }];

    UIImageView *communityTime=[[UIImageView alloc]init];
    [self.contentView addSubview:communityTime];
    communityTime.image=[UIImage imageNamed:@"Community_shijian"];
    [communityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.communityTitle.mas_bottom).offset(5);
        make.left.mas_equalTo(self.communityTitle.mas_left);
    }];
    self.communityTime=[UnityLHClass  masonryLabel:@"2016-08-29 09:00-11:00" font:13.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.communityTime];
    [self.communityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(communityTime.mas_centerY);
        make.left.mas_equalTo(communityTime.mas_right).offset(5);
    }];
    
    
    UIImageView *communityAddress=[[UIImageView alloc]init];
    [self.contentView addSubview:communityAddress];
    communityAddress.image=[UIImage imageNamed:@"Community_dingwei"];
    [communityAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(communityTime.mas_bottom).offset(5);
        make.left.mas_equalTo(communityTime.mas_left);
    }];
    self.communityAddress=[UnityLHClass  masonryLabel:@"北京市海淀区南大街39号" font:13.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.communityAddress];
    [self.communityAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(communityAddress.mas_centerY);
        make.left.mas_equalTo(self.communityTime.mas_left);
    }];
    
    UIImageView *communityContact=[[UIImageView alloc]init];
    [self.contentView addSubview:communityContact];
    communityContact.image=[UIImage imageNamed:@"Community_user"];
    [communityContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(communityAddress.mas_bottom).offset(5);
        make.left.mas_equalTo(communityAddress.mas_left);
    }];
    self.communityContact=[UnityLHClass  masonryLabel:@"联系人：赵晓燕" font:13.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.communityContact];
    [self.communityContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(communityContact.mas_centerY);
        make.left.mas_equalTo(self.communityTime.mas_left);
    }];
    
    UIView *line=[[UIView alloc]init];
    [self.contentView addSubview:line];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.left.mas_equalTo(self.communityIcon.mas_right).offset(5);
        make.top.mas_equalTo(communityContact.mas_bottom).offset(5);
        make.height.mas_equalTo(1);
    }];
    
    self.communityIntroduction=[UnityLHClass  masonryLabel:@"活动简介：通过此次活动希望大家能泰语到运动健身中，从而懂得健康养生" font:13.0 color:BM_Color_GrayColor];
    self.communityIntroduction.numberOfLines=2;
    self.communityIntroduction.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.communityIntroduction];
    [self.communityIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.communityTitle.mas_left);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(line.mas_bottom).offset(5);
    }];
    
    
    UIView *lineTwo=[[UIView alloc]init];
    [self.contentView addSubview:lineTwo];
    lineTwo.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(5);

    }];
    
    [self.communityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(lineTwo.mas_top).offset(-15);
        make.width.mas_equalTo(self.communityIcon.mas_height);
    }];

    
}
-(void)loadCellWithDataSource:(id)dataSource
{
    [self.communityIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"activityImage"]]];
    //applyStatus 	String 	报名状态（01：报名未开始,02：报名中,03：报名截止,04：活动中,05：活动结束）
    NSString *applyStatus=@"报名未开始";
    switch ([dataSource[@"applyStatus"] integerValue])
    {
        case 1:
        {
            applyStatus=@"报名未开始";
        }
            break;
        case 2:
        {
            applyStatus=@"报名中";
        }
            break;
        case 3:
        {
            applyStatus=@"报名截止";

        }
            break;
        case 4:
        {
            applyStatus=@"活动中";

        }
            break;
        case 5:
        {
            applyStatus=@"活动结束";

        }
            break;
            
        default:
            break;
    }
    [self.communityStatus  setTitle:applyStatus forState:UIControlStateNormal];
    
    
    self.communityTitle.text=dataSource[@"activityTitle"];
    [self.communityClassification setTitle:dataSource[@"className"] forState:UIControlStateNormal];
    NSString *activityBeginTime=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd HH:mm" andTimeString:dataSource[@"activityBeginTime"]];
    NSString *activityEndTime=[UnityLHClass getCurrentTimeWithType:@"MM-dd HH:mm" andTimeString:dataSource[@"activityEndTime"]];
    self.communityTime.text=[NSString stringWithFormat:@"%@-%@",activityBeginTime,activityEndTime];
    self.communityAddress.text=dataSource[@"activityAddress"];
    self.communityContact.text=[NSString stringWithFormat:@"联系人:%@",dataSource[@"activityContact"]];
    self.communityIntroduction.text=dataSource[@"activityDescription"];
}

@end
