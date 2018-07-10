//
//  BBSCommentsCell.m
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BBSCommentsCell.h"

@interface BBSCommentsCell ()

@property(nonatomic,strong)UILabel *bbsUserName;
@property(nonatomic,strong)NetworkImageView *bbsUserIcon;

@property(nonatomic,strong)UILabel *bbsTime;
@property(nonatomic,strong)UILabel *bbsInfo;

@property(nonatomic,strong)UIButton *bbsDelete;
@property(nonatomic,strong)UIButton *bbsLahei;

@end
@implementation BBSCommentsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    BBSCommentsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BBSCommentsCell"];
    if (!cell)
    {
        cell=[[BBSCommentsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BBSCommentsCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

+(CGFloat)getCellHightWithDataSource:(id)dataSource
{
    CGFloat hight=0;
    hight+=10;
    hight+=50;
    hight+=15;
    hight+=[UnityLHClass getHeight:dataSource[@"evalContent"] wid:DEF_SCREEN_WIDTH-30 font:14.0];
    hight+=15;
    return hight;
}
-(void)createCell
{
    self.bbsUserIcon =[[NetworkImageView alloc]init];
    self.bbsUserIcon.image=[UIImage imageNamed:@"Community_pic"];
    [self.contentView addSubview:self.bbsUserIcon];
    
    self.bbsUserName=[UnityLHClass masonryLabel:@"西门吹雪" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.bbsUserName];
    
    self.bbsDelete=[UnityLHClass masonryButton:@"" imageStr:@"Community_shanchu" font:13.0 color:BM_Color_Blue];
    [self.contentView addSubview:self.bbsDelete];
    
    self.bbsLahei=[UnityLHClass masonryButton:@"" imageStr:@"Community_lahei" font:13.0 color:BM_Color_Blue];
    [self.contentView addSubview:self.bbsLahei];
    
    
    self.bbsTime=[UnityLHClass masonryLabel:@"2017-03-14 17:00" font:13.0 color:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.bbsTime];
    
    self.bbsInfo=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.bbsInfo];
    self.bbsInfo.numberOfLines=0;
    
    self.contentView.bottomlineWithColor=[UIColor groupTableViewBackgroundColor];
    
    //删除评论
    [self.bbsDelete handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定删除该评论？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                [self sendObject:@"0"];
            }
        }];
    }];
    
    //拉黑
    [self.bbsLahei handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定拉黑该用户？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                [self sendObject:@"1"];
            }
        }];
        
    }];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bbsUserIcon.layer.masksToBounds=YES;
    self.bbsUserIcon.layer.cornerRadius=50/2.0;
    [self.bbsUserIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.and.height.mas_equalTo(50);
    }];
    
    
    [self.bbsLahei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.bbsUserIcon.mas_centerY);
        
    }];
    
    [self.bbsDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bbsLahei.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.bbsUserIcon.mas_centerY);
        
    }];
    
    [self.bbsUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bbsUserIcon.mas_right).offset(5);
        make.bottom.mas_equalTo(self.bbsUserIcon.mas_centerY).offset(-5);
    }];
    
    [self.bbsTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bbsUserName.mas_left);
        make.top.mas_equalTo(self.bbsUserIcon.mas_centerY).offset(5);
    }];
    
    [self.bbsInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.bbsUserIcon.mas_left);
        make.top.mas_equalTo(self.bbsTime.mas_bottom).offset(15);
    }];
    

    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.bbsUserIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"headImage"]]];
    self.bbsUserName.text=dataSource[@"nickName"];
    self.bbsTime.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd HH:mm" andTimeString:dataSource[@"evalAddtime"]];
    self.bbsInfo.text=dataSource[@"evalContent"];
    self.bbsDelete.hidden=NO;
    self.bbsLahei.hidden=NO;
    
}

-(void)hideCaoZuoView
{
    //隐藏删除拉黑按钮
    self.bbsDelete.hidden=YES;
    self.bbsLahei.hidden=YES;
}


-(void)hideLaheiView
{
    //隐藏拉黑按钮
    self.bbsLahei.hidden=YES;
}

@end
