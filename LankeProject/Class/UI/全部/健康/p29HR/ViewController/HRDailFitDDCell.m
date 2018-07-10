//
//  HRDailFitDDCell.m
//  LankeProject
//
//  Created by admin on 2017/10/25.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRDailFitDDCell.h"

@implementation HRDailFitDDCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    HRDailFitDDCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HRDailFitnessCell"];
    if (!cell)
    {
        cell=[[HRDailFitDDCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HRDailFitnessCell"];
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
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, DEF_SCREEN_WIDTH, 1)];
    lineView.backgroundColor=BM_Color_LineColor;
    lineView.alpha=0.6;
    [self.contentView addSubview:lineView];
 
    CGFloat gwith=DEF_SCREEN_WIDTH/2;
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
   
    
}
-(void)loadCellWithDataSource:(id)dataSource
{
     self.lable1.text=[NSString stringWithFormat:@"%@",[UnityLHClass getCurrentTimeWithType:@"HH:mm:ss" andTimeString:dataSource[@"createDate"] ]];
    self.lable2.text=[NSString stringWithFormat:@"%@",dataSource[@"heartRate"]];
}

+ (CGFloat)getCellHeight
{
    return 50.0f;
}


@end
