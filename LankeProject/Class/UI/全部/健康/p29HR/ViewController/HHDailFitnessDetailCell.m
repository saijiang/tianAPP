//
//  HHDailFitnessDetailCell.m
//  LankeProject
//
//  Created by admin on 2017/10/25.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HHDailFitnessDetailCell.h"

@implementation HHDailFitnessDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    HHDailFitnessDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HHDailFitnessDetailCell"];
    if (!cell)
    {
        cell=[[HHDailFitnessDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHDailFitnessDetailCell"];
    }
    return cell;
    
}
-(void)createCell
{
    self.lable1=[UnityLHClass masonryLabel:@"" font:16 color:BM_GRAY ];
    self.lable1.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.lable1];
    self.lable2=[UnityLHClass masonryLabel:@"" font:16 color:BM_GRAY];
    self.lable2.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.lable2];
    self.lable3=[UnityLHClass masonryLabel:@"" font:16 color:BM_GRAY];
    self.lable3.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.lable3];
    self.lable4=[UnityLHClass masonryLabel:@"" font:16 color: [UIColor colorWithRed:1.00 green:0.69 blue:0.08 alpha:1.00]];
    self.lable4.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.lable4];
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, DEF_SCREEN_WIDTH, 1)];
    lineView.backgroundColor=BM_Color_LineColor;
    lineView.alpha=0.6;
    [self.contentView addSubview:lineView];
    
    
    CGFloat gwith=DEF_SCREEN_WIDTH/4;
    [self.lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(gwith);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    [self.lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lable1.mas_right);
        make.width.mas_equalTo(gwith);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    [self.lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lable2.mas_right);
        make.width.mas_equalTo(gwith);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    [self.lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lable3.mas_right);
        make.width.mas_equalTo(gwith);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    
}
-(void)loadCellWithDataSource:(id)dataSource
{
    self.lable1.text=[NSString stringWithFormat:@"%@",[UnityLHClass getCurrentTimeWithType:@"YYYY-MM-dd" andTimeString:dataSource[@"fitnessDate"] ]];
    self.lable2.text=[NSString stringWithFormat:@"%@",dataSource[@"consumeCalories"]];
    self.lable3.text=[NSString stringWithFormat:@"%@",dataSource[@"targetCalories"]];
     self.lable4.text=[NSString stringWithFormat:@"%@",dataSource[@"todayCompletePer"]];
}

+ (CGFloat)getCellHeight
{
    return 50.0f;
}



@end
