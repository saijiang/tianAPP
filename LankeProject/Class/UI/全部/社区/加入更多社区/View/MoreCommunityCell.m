//
//  MoreCommunityCell.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MoreCommunityCell.h"

@interface MoreCommunityCell()

@property(nonatomic,strong)NetworkImageView *communityIcon;

@property(nonatomic,strong)UILabel  *communityTitle;
@property(nonatomic,strong)UILabel  *communityClassification;
@property(nonatomic,strong)UILabel  *communityNum;

@property(nonatomic,strong)UILabel  *communityIntroduction;

@property(nonatomic,strong)UIButton *communityAdd;

@property(nonatomic,strong)UIButton *communityTerms;//条款
@property(nonatomic,strong)UIButton *communityApplyList;//申请列表
@property(nonatomic,strong)UIButton *seeMemberBtn;//查看成员

@property(nonatomic,strong)UIImageView *biaoqianView;

@end

@implementation MoreCommunityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MoreCommunityCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MoreCommunityCell"];
    if (!cell)
    {
        cell=[[MoreCommunityCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MoreCommunityCell"];
        
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
    [self.communityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.communityIcon.mas_height);
    }];

    self.communityTitle=[UnityLHClass  masonryLabel:@"全民炫跑活动召集令" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.communityTitle];
    [self.communityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        make.top.mas_equalTo(self.communityIcon.mas_top);
        make.left.mas_equalTo(self.communityIcon.mas_right).offset(5);
    }];
    
    self.communityAdd=[UnityLHClass masonryButton:@"加入" font:14.0 color:BM_WHITE];
    self.communityAdd.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 5, 0);
    self.communityAdd.userInteractionEnabled=NO;
    self.communityAdd.hidden=YES;
    [self.contentView addSubview:self.communityAdd];
    [self.communityAdd setBackgroundImage:[UIImage imageNamed:@"Community_btn"] forState:UIControlStateNormal];
    [self.communityAdd mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.communityIcon.mas_top);
        make.width.mas_equalTo(70);
    }];
    [self.communityAdd handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self addAssociation];
    }];
    
    UIImageView *biaoqianView=[[UIImageView alloc]init];
    biaoqianView.image=[UIImage imageNamed:@"Community_biaoqian-1"];
    [self.contentView addSubview:biaoqianView];
    self.biaoqianView=biaoqianView;
    [biaoqianView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(self.communityTitle.mas_left);
      make.top.mas_equalTo(self.communityTitle.mas_bottom).offset(10);
       make.width.mas_equalTo(130);

    }];
    
    self.communityClassification=[UnityLHClass  masonryLabel:@"亲子" font:13.0 color:BM_WHITE];
    self.communityClassification.textAlignment=NSTextAlignmentCenter;
    [biaoqianView addSubview:self.communityClassification];
    [self.communityClassification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(biaoqianView.mas_centerY);
        make.left.mas_equalTo(biaoqianView.mas_left).offset(-2);
        make.width.mas_equalTo(biaoqianView.mas_width).multipliedBy(0.5);
    }];

    self.communityNum=[UnityLHClass  masonryLabel:@"188人" font:13.0 color:[UIColor colorWithRed:0.98 green:0.41 blue:0.32 alpha:1.00]];
    self.communityNum.textAlignment=NSTextAlignmentCenter;
    [biaoqianView addSubview:self.communityNum];
    [self.communityNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(biaoqianView.mas_centerY);
        make.right.mas_equalTo(biaoqianView.mas_right);
        make.width.mas_equalTo(biaoqianView.mas_width).multipliedBy(0.5);
    }];
    
    self.communityIntroduction=[UnityLHClass  masonryLabel:@"通过此次活动希望大家能泰语到运动健身中，从而懂得健康养生" font:13.0 color:BM_Color_GrayColor];
    self.communityIntroduction.numberOfLines=2;
    self.communityIntroduction.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.communityIntroduction];
    [self.communityIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.communityTitle.mas_left);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(biaoqianView.mas_bottom).offset(10);
    }];
    
    
    self.communityTerms=[UnityLHClass masonryButton:@"" font:14.0 color:BM_Color_Blue];
    self.communityTerms.layer.masksToBounds=YES;
    self.communityTerms.layer.cornerRadius=5;
    self.communityTerms.layer.borderWidth=1;
    self.communityTerms.layer.borderColor=BM_Color_Blue.CGColor;
    [self.contentView addSubview:self.communityTerms];
    [self.communityTerms mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
         make.top.mas_equalTo(self.communityIcon.mas_top);
         make.width.mas_equalTo(110);
         make.height.mas_equalTo(30);

     }];
    
   
    
    
    self.communityApplyList=[UnityLHClass masonryButton:@"申请列表" font:14.0 color:BM_WHITE];
    self.communityApplyList.layer.masksToBounds=YES;
    self.communityApplyList.layer.cornerRadius=5;
    [self.contentView addSubview:self.communityApplyList];
    [self.communityApplyList setBackgroundImage:[UIImage imageWithColor:BM_Color_Blue] forState:UIControlStateNormal];
    
    [self.communityApplyList mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
         make.top.mas_equalTo(self.communityTerms.mas_bottom).offset(5);
         make.width.mas_equalTo(110);
         make.height.mas_equalTo(30);

     }];
    
    self.seeMemberBtn=[UnityLHClass masonryButton:@"查看成员" font:14.0 color:BM_WHITE];
    self.seeMemberBtn.layer.masksToBounds=YES;

    self.seeMemberBtn.layer.cornerRadius=5;
    [self.contentView addSubview:self.seeMemberBtn];
    [self.seeMemberBtn setBackgroundImage:[UIImage imageWithColor:BM_Color_Blue] forState:UIControlStateNormal];
    
    [self.seeMemberBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
         make.top.mas_equalTo(self.communityApplyList.mas_bottom).offset(5);
         make.width.mas_equalTo(110);
         make.height.mas_equalTo(30);
         
     }];
    
    [self.communityTerms handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //社群条款
        [self sendObject:@"0"];
    }];
    [self.communityApplyList handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //申请列表
        [self sendObject:@"1"];

    }];
    [self.seeMemberBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //申请列表
        [self sendObject:@"2"];
        
    }];

   

}

-(void)loadCellWithDataSource:(id)dataSource
{
    MoreCommunityModel * model=(MoreCommunityModel *)dataSource;
    self.data=model;
    [self.communityIcon sd_setImageWithURL:[NSURL URLWithString:model.associationImage]];
    self.communityTitle.text=model.associationTitle;
    self.communityClassification.text=model.className;
    self.communityNum.text=[NSString stringWithFormat:@"%@人",model.userCount];
    self.communityIntroduction.text=model.associationDescription;

    self.seeMemberBtn.hidden=YES;

    self.communityApplyList.hidden=YES;
    self.communityTerms.hidden=YES;
    self.communityAdd.hidden=YES;
    if ([model.isAdd integerValue]==1) {
        self.communityAdd.hidden=YES;
    }
}
-(void)loadMineCellWithDataSource:(id)dataSource
{
    MoreCommunityModel * model=(MoreCommunityModel *)dataSource;
    self.data=model;
    [self.communityIcon sd_setImageWithURL:[NSURL URLWithString:model.associationImage]];
    self.communityTitle.text=model.associationTitle;
    self.communityClassification.text=model.className;
    self.communityNum.text=[NSString stringWithFormat:@"%@人",model.userCount];
    self.communityIntroduction.text=model.associationDescription;

    
    self.communityApplyList.hidden=YES;
    self.communityTerms.hidden=YES;
    self.communityAdd.hidden=YES;
    self.seeMemberBtn.hidden=YES;

}
-(void)loadMangerCellWithDataSource:(id)dataSource
{
    MoreCommunityModel * model=(MoreCommunityModel *)dataSource;
    self.data=model;
    [self.communityIcon sd_setImageWithURL:[NSURL URLWithString:model.associationImage]];
    self.communityTitle.text=model.associationTitle;
    self.communityClassification.text=model.className;
    self.communityNum.text=[NSString stringWithFormat:@"%@人",model.userCount];
    self.communityIntroduction.text=model.associationDescription;
    
    self.communityAdd.hidden=YES;
    self.communityIntroduction.hidden=YES;

    [self.communityTerms setTitle:@"编辑社群条款" forState:UIControlStateNormal];
    if ([model.displayFlg integerValue]==0)
    {
        [self.communityTerms setTitle:@"添加社群条款" forState:UIControlStateNormal];
    }
    self.communityApplyList.hidden=YES;
    if ([model.isApply integerValue]==1) {
        self.communityApplyList.hidden=NO;
    }
    [self.biaoqianView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

}

-(void)addAssociation
{
    [UserServices
     addAssociationWithuserId:[KeychainManager readUserId]
     userName:[KeychainManager readNickName]
     associationId:[self.data associationId]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self sendObject:@"addAssociation"];
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}


@end

@implementation MoreCommunityModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
