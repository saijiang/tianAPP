//
//  SettingCell.m
//  LankeProject
//
//  Created by itman on 17/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell()

@property(nonatomic,strong)UILabel *leftTitle;
@property(nonatomic,strong)UILabel *centerTitle;
@property(nonatomic,strong)UIImageView *rightImage;
@property(nonatomic,strong)UISwitch *messageSwitch;

@end

@implementation SettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    SettingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (!cell)
    {
        cell=[[SettingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SettingCell"];
    }
    return cell;
    
}


-(void)createCell
{
    
    self.leftTitle = [[UILabel alloc] init];
    self.leftTitle.font = BM_FONTSIZE(15.0);
    self.leftTitle.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [self addSubview:self.leftTitle];
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(15);
    }];
    
    self.centerTitle = [[UILabel alloc] init];
    self.centerTitle.font = BM_FONTSIZE(15.0);
    self.centerTitle.textColor = BM_GRAY;
    self.centerTitle.text=@"点击拨通客服专线";
    [self addSubview:self.centerTitle];
    [self.centerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    
    self.rightImage = [[UIImageView alloc] init];
    self.rightImage.image=[UIImage imageNamed:@"right_arrow"];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    self.messageSwitch=[[UISwitch alloc]init];
    [self addSubview:self.messageSwitch];
    [self.messageSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightImage.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
 

    
    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self addSubview:lineImage];
    
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTitle.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.rightImage.mas_right);
        make.height.offset(0.5);
    }];

}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.centerTitle.hidden=YES;
    self.rightImage.hidden=NO;
    self.messageSwitch.hidden=YES;
    NSIndexPath *indexPath=(NSIndexPath *)dataSource;
    switch (indexPath.row)
    {
        case 0:
        {
            self.leftTitle.text=@"消息通知";
            self.rightImage.hidden=YES;
            self.messageSwitch.hidden=NO;
            
        }
            break;
        case 1:
        {
            self.leftTitle.text=@"一键客服";
            self.centerTitle.hidden=NO;
        }
            break;
        case 2:
        {
            self.leftTitle.text=@"意见反馈";
           
        }
            break;
        case 3:
        {
            self.leftTitle.text=@"帮助说明";
           
        }
            break;
        case 4:
        {
            self.leftTitle.text=@"软件版本";
            
        }
            break;
        case 5:
        {
            self.leftTitle.text=@"切换服务器";
            
        }
            break;
        case 6:
        {
            self.leftTitle.text=@"更换APPICON";
            
        }
            break;
        default:
            break;
    }
}


@end
