//
//  FitnessPlanHistoryCell.m
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitReportCell.h"

@interface FitReportCell()

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *status;

@property(nonatomic,strong)UILabel *completeDays;
@property(nonatomic,strong)UILabel *noCompleteDays;
@property(nonatomic,strong)UILabel *completeProportion;

@property(nonatomic,strong)UILabel *sumConsumption;
@property(nonatomic,strong)UILabel *completeConsumption;
@property(nonatomic,strong)UILabel *consumptionProportion;

@end

@implementation FitReportCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FitReportCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FitReportCell"];
    if (!cell)
    {
        cell=[[FitReportCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FitReportCell"];
    }
    return cell;
    
}

-(void)createCell
{
    NetworkImageView *headerBaseImage=[[NetworkImageView alloc]init];
    [self addSubview:headerBaseImage];
    headerBaseImage.layer.masksToBounds=YES;
    headerBaseImage.layer.cornerRadius=5.0;
    headerBaseImage.image=[UIImage imageNamed:@"health_header_fitness_jihuabg"];
    [headerBaseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(130);
    }];
    
    self.name=[UnityLHClass masonryLabel:@"张华" font:28.0 color:BM_WHITE];
    [headerBaseImage addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(40);
        
    }];
    self.time=[UnityLHClass masonryLabel:@"健身计划周期：2016.10.1-11.30" font:19.0 color:BM_WHITE];
    self.time.adjustsFontSizeToFitWidth=YES;
    [headerBaseImage addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerBaseImage.mas_centerX);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.name.mas_bottom).offset(20);

    }];
    
    self.status=[UnityLHClass masonryLabel:@"员工号：ws7661" font:14.0 color:BM_WHITE];
    [headerBaseImage addSubview:self.status];
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        
    }];
   
    
    UILabel *sumConsumption=[UnityLHClass masonryLabel:@"目标消耗量（千卡）" font:14.0 color:BM_BLACK];
    sumConsumption.numberOfLines=0;
    sumConsumption.textAlignment=NSTextAlignmentCenter;
    [self addSubview:sumConsumption];
    self.sumConsumption=[UnityLHClass masonryLabel:@"18" font:24.0 color:BM_Color_Blue];
    self.sumConsumption.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.sumConsumption];
    [self.sumConsumption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerBaseImage.mas_left);
        make.width.mas_equalTo(headerBaseImage.mas_width).multipliedBy(1/3.0);
        make.bottom.mas_equalTo(-10);
    }];
    [sumConsumption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sumConsumption.mas_centerX);
        make.width.mas_equalTo(self.sumConsumption.mas_width);
        make.bottom.mas_equalTo(self.sumConsumption.mas_top).offset(-7);
    }];
    
    UILabel *completeConsumption=[UnityLHClass masonryLabel:@"实际消耗量（千卡）" font:14.0 color:BM_BLACK];
    completeConsumption.numberOfLines=0;
    completeConsumption.textAlignment=NSTextAlignmentCenter;
    [self addSubview:completeConsumption];
    self.completeConsumption=[UnityLHClass masonryLabel:@"10" font:24.0 color:BM_Color_Blue];
    self.completeConsumption.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.completeConsumption];
    [self.completeConsumption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sumConsumption.mas_right);
        make.width.mas_equalTo(self.sumConsumption.mas_width);
        make.centerY.mas_equalTo(self.sumConsumption.mas_centerY);
    }];
    [completeConsumption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.completeConsumption.mas_centerX);
        make.width.mas_equalTo(self.completeConsumption.mas_width);
        make.centerY.mas_equalTo(sumConsumption.mas_centerY);
    }];
    
    UILabel *consumptionProportion=[UnityLHClass masonryLabel:@"目标达成比例（％）" font:14.0 color:BM_BLACK];
    consumptionProportion.numberOfLines=0;
    consumptionProportion.textAlignment=NSTextAlignmentCenter;
    [self addSubview:consumptionProportion];
    self.consumptionProportion=[UnityLHClass masonryLabel:@"55" font:24.0 color:[UIColor colorWithRed:1.00 green:0.70 blue:0.09 alpha:1.00]];
    self.consumptionProportion.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.consumptionProportion];
    [self.consumptionProportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.completeConsumption.mas_right);
        make.width.mas_equalTo(self.completeConsumption.mas_width);
        make.centerY.mas_equalTo(self.sumConsumption.mas_centerY);
    }];
    [consumptionProportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.consumptionProportion.mas_centerX);
        make.width.mas_equalTo(self.completeConsumption.mas_width);
        make.centerY.mas_equalTo(sumConsumption.mas_centerY);
    }];
    
    UILabel *completeDays=[UnityLHClass masonryLabel:@"目标达成（天）" font:14.0 color:BM_BLACK];
    completeDays.numberOfLines=0;
    completeDays.textAlignment=NSTextAlignmentCenter;
    [self addSubview:completeDays];
    self.completeDays=[UnityLHClass masonryLabel:@"30" font:24.0 color:BM_Color_Blue];
    self.completeDays.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.completeDays];
    [self.completeDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sumConsumption.mas_left);
        make.width.mas_equalTo(sumConsumption.mas_width);
        make.bottom.mas_equalTo(sumConsumption.mas_top).offset(-10);
    }];
    [completeDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sumConsumption.mas_left);
        make.width.mas_equalTo(self.sumConsumption.mas_width);
        make.bottom.mas_equalTo(self.completeDays.mas_top).offset(-7);
    }];
    
    UILabel *noCompleteDays=[UnityLHClass masonryLabel:@"目标未达成（天）" font:14.0 color:BM_BLACK];
    noCompleteDays.numberOfLines=0;
    noCompleteDays.textAlignment=NSTextAlignmentCenter;
    [self addSubview:noCompleteDays];
    self.noCompleteDays=[UnityLHClass masonryLabel:@"30" font:24.0 color:BM_Color_Blue];
    self.noCompleteDays.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.noCompleteDays];
    [self.noCompleteDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.completeDays.mas_right);
        make.width.mas_equalTo(self.completeDays.mas_width);
        make.centerY.mas_equalTo(self.completeDays.mas_centerY);
    }];
    [noCompleteDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.noCompleteDays.mas_centerX);
        make.width.mas_equalTo(self.noCompleteDays.mas_width);
        make.centerY.mas_equalTo(completeDays.mas_centerY);
    }];
    
    UILabel *completeProportion=[UnityLHClass masonryLabel:@"目标达成比例（％）" font:14.0 color:BM_BLACK];
    completeProportion.numberOfLines=0;
    completeProportion.textAlignment=NSTextAlignmentCenter;
    [self addSubview:completeProportion];
    self.completeProportion=[UnityLHClass masonryLabel:@"50" font:24.0 color:[UIColor colorWithRed:1.00 green:0.70 blue:0.09 alpha:1.00]];
    self.completeProportion.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.completeProportion];
    [self.completeProportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.noCompleteDays.mas_right);
        make.width.mas_equalTo(self.noCompleteDays.mas_width);
        make.centerY.mas_equalTo(self.completeDays.mas_centerY);
    }];
    [completeProportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.completeProportion.mas_centerX);
        make.width.mas_equalTo(self.completeProportion.mas_width);
        make.centerY.mas_equalTo(completeDays.mas_centerY);
    }];
    
    
    
}
-(void)loadCellWithDataSource:(id)dataSource
{
    self.name.text=[KeychainManager readNickName];
    self.time.text=[NSString stringWithFormat:@"健身计划周期：%@-%@",dataSource[@"cycleStartDate"],dataSource[@"cycleEndDate"]];
    self.completeDays.text=[NSString stringWithFormat:@"%@",dataSource[@"completeDayCount"]];
    self.noCompleteDays.text=[NSString stringWithFormat:@"%@",dataSource[@"otherDayCount"]];
    self.completeProportion.text=[NSString stringWithFormat:@"%@",dataSource[@"completeDayPer"]];
    
    self.sumConsumption.text=[NSString stringWithFormat:@"%@",dataSource[@"targetCalorie"]];
    self.completeConsumption.text=[NSString stringWithFormat:@"%@",dataSource[@"consumeCalories"]];
    self.consumptionProportion.text=[NSString stringWithFormat:@"%@",dataSource[@"targetCaloriePer"]];
    self.status.text=[NSString stringWithFormat:@"员工号：%@",[KeychainManager readEmployeeNum]];
            
    
}
@end
