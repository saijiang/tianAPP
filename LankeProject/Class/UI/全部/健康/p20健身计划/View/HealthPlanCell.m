//
//  HealthPlanCell.m
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthPlanCell.h"

@interface HealthPlanCell ()

@property(nonatomic,strong)UILabel *projectName;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *consumption;
@end

@implementation HealthPlanCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    HealthPlanCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HealthPlanCell"];
    if (!cell)
    {
        cell=[[HealthPlanCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HealthPlanCell"];
    }
    return cell;
    
}
-(void)createCell
{
    self.projectName=[UnityLHClass masonryLabel:@"打羽毛球" font:14.0 color:BM_BLACK];
    [self addSubview:self.projectName];
    
    self.time=[UnityLHClass masonryLabel:@"58分钟" font:14.0 color:BM_BLACK];
    [self addSubview:self.time];
    
    self.consumption=[UnityLHClass masonryLabel:@"可消耗卡路里150千卡" font:14.0 color:BM_BLACK];
    [self addSubview:self.consumption];
    
    
    UIButton *delete=[UnityLHClass masonryButton:@"" imageStr:@"health_lajitong" font:13.0 color:BM_WHITE];
    [self addSubview:delete];
    self.deleteButton=delete;
    
    [delete setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    [delete handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self deleteSportsPlan];
    }];
    
    [self.projectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(65);
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.projectName.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);

    }];
    [self.consumption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.time.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.data=dataSource;
    self.projectName.text=[self sportsNameWithKey:dataSource[@"sportsName"]];
    self.time.text=[NSString stringWithFormat:@"%@分钟",dataSource[@"sportsTime"]];
    
    if ([self.flag integerValue]==1) {
        self.consumption.text=[NSString stringWithFormat:@"可消耗卡路里%@千卡",dataSource[@"sportsCalorie"]];
    }else{
        self.consumption.text=[NSString stringWithFormat:@"已消耗卡路里%@千卡",dataSource[@"sportsCalorie"]];
    }


}

-(NSString*)sportsNameWithKey:(NSString *)key
{
   // sportsName 	String 	运动项目 01：散步 02：慢跑 03：游泳 04：田径:05：篮球 06：自行车 07：骑马 08：羽毛球 09：高尔夫 10：足球 11：跳绳 12：壁球 13：网球 14：乒乓球 15：排球
    NSDictionary *sportsNameDic=@{
                                  @"01":@"散步",
                                  @"02":@"慢跑",
                                  @"03":@"游泳",
                                  @"04":@"田径",
                                  @"05":@"篮球",
                                  @"06":@"自行车",
                                  @"07":@"骑马",
                                  @"08":@"羽毛球",
                                  @"09":@"高尔夫",
                                  @"10":@"足球",
                                  @"11":@"跳绳",
                                  @"12":@"壁球",
                                  @"13":@"网球",
                                  @"14":@"乒乓球",
                                  @"15":@"排球",
                                  };
    
    return sportsNameDic[key];
    
}

-(void)deleteSportsPlan
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"确定删除选择的运动？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1)
        {
            [UserServices  deleteSportsPlanWithId:self.data[@"id"]
                                    fitnessPlanId:self.data[@"fitnessPlanId"]
                                             flag:self.flag
                                  completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
                 {
                     [self sendObject:@"delete"];
                     
                 }
                 else
                 {
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 }
             }];

        }
    }];
   
}
@end
