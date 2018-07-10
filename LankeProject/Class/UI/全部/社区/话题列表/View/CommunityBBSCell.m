//
//  CommunityBBSCell.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityBBSCell.h"

@interface CommunityBBSCell ()

@property(nonatomic,strong)UILabel *bbsTitle;
@property(nonatomic,strong)UILabel *bbsTime;
@property(nonatomic,strong)UILabel *bbsInfo;

@property(nonatomic,strong)UIButton *bbsComments;

@property(nonatomic,strong)UIButton *bbsHot;
@property(nonatomic,strong)UIButton *bbsOfficial;

@end

@implementation CommunityBBSCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CommunityBBSCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityBBSCell"];
    if (!cell)
    {
        cell=[[CommunityBBSCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommunityBBSCell"];
        
    }
    return cell;
    
}

-(void)createCell
{
    self.bbsTitle=[UnityLHClass masonryLabel:@"《华东的雪》寒冬枝头百丈雪" font:16.0 color:BM_BLACK];
    [self.contentView addSubview:self.bbsTitle];
    
    self.bbsTime=[UnityLHClass masonryLabel:@"2017-03-14 17:00" font:13.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.bbsTime];
    
    self.bbsInfo=[UnityLHClass masonryLabel:@"西门吹雪" font:14.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.bbsInfo];
    
    self.bbsHot=[UnityLHClass masonryButton:@"  热门  " font:13.0 color:[UIColor colorWithRed:0.97 green:0.44 blue:0.36 alpha:1.00]];
    [self.contentView addSubview:self.bbsHot];
    self.bbsHot.userInteractionEnabled=NO;
    [self.bbsHot setBackgroundImage:[UIImage imageNamed:@"BBS_red-biaoqian"] forState:UIControlStateNormal];

    self.bbsOfficial=[UnityLHClass masonryButton:@" 官方  " font:13.0 color:BM_Color_Blue];
    [self.contentView addSubview:self.bbsOfficial];
    self.bbsOfficial.userInteractionEnabled=NO;
    [self.bbsOfficial setBackgroundImage:[UIImage imageNamed:@"BBS_blue-biaoqian"] forState:UIControlStateNormal];
    [self.bbsOfficial setBackgroundImage:[UIImage imageNamed:@"BBS_red-biaoqian"] forState:UIControlStateSelected];
    
    self.bbsComments=[UnityLHClass masonryButton:@"100" imageStr:@"BBS_huifu" font:13.0 color:BM_Color_Blue];
    self.bbsComments.userInteractionEnabled=NO;
    [self.bbsComments layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.contentView addSubview:self.bbsComments];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bbsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.bbsOfficial mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.bbsTitle.mas_centerY);
    }];
    
    [self.bbsHot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bbsOfficial.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.bbsTitle.mas_centerY);
    }];
    
    [self.bbsTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bbsTitle.mas_left);
        make.top.mas_equalTo(self.bbsTitle.mas_bottom).offset(10);
    }];
    [self.bbsInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.left.mas_equalTo(self.bbsTitle.mas_left);
        make.top.mas_equalTo(self.bbsTime.mas_bottom).offset(10);
    }];
    [self.bbsComments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.bbsTitle.mas_bottom).offset(15);
    }];
    
}
-(void)loadCellWithDataSource:(id)dataSource
{
    self.bbsTitle.text=dataSource[@"topicTitle"];
    self.bbsTime.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd hh:mm" andTimeString:dataSource[@"publishTime"]];
    self.bbsInfo.text=dataSource[@"topicContent"];
    [self.bbsComments setTitle:[NSString stringWithFormat:@"%d",[dataSource[@"commentCount"] intValue]] forState:UIControlStateNormal];
    
//    isTop 	String 	是否热门（0否，1是）
//    topicFoundType 	String 	话题创建类型（01：官方 02：非官方）
    if ([dataSource[@"topicFoundType"] integerValue]==1)
    {
        self.bbsOfficial.hidden=NO;
    }
    else
    {
        self.bbsOfficial.hidden=YES;

    }
    
    if ([dataSource[@"isTop"] integerValue]==1)
    {
        self.bbsHot.hidden=NO;
    }
    else
    {
        self.bbsHot.hidden=YES;
        
    }
}

@end
