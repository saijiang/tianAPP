//
//  HRDailFitnessHeaderView.m
//  LankeProject
//
//  Created by admin on 2017/10/25.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRDailFitnessHeaderView.h"
#import "DailyFitnessPickDateView.h"
@implementation HRDailFitnessHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#67B0D9"];
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake((DEF_SCREEN_WIDTH-320)/2, 30, 320, 40)];
    contentView.layer.cornerRadius = 5.0f;
    contentView.layer.masksToBounds = YES;
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = BM_WHITE;
    [self addSubview:contentView];
    UILabel*lable=[UnityLHClass masonryLabel:@"至" font:15 color:BM_BLACK];
    [contentView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
    }];
    
    DailyFitnessPickDateView * pickerView1 = [DailyFitnessPickDateView view];
    pickerView1.tag = 101010;
   // pickerView1.iconImageView.hidden=YES;
    [pickerView1 receiveObject:^(id object) {
        self.statrTimeStr=object;
        [self compStartTimeWithEndTime];
    }];
   [contentView addSubview:pickerView1];
    
    //默认显示本月第一天
    NSString *str = pickerView1.dateLabel.text;
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    str = [NSString stringWithFormat:@"%@-%@-01",arr[0],arr[1]];
    pickerView1.dateLabel.text = str;
    
    [pickerView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(lable.mas_left);
        make.top.mas_equalTo(0);
    }];
 
    DailyFitnessPickDateView * pickerView2 = [DailyFitnessPickDateView view];
    pickerView2.tag = 101011;
    [pickerView2 receiveObject:^(id object) {
        self.endTimeStr=object;
        [self compStartTimeWithEndTime];
   
    }];
    [contentView addSubview:pickerView2];
    [pickerView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(lable.mas_right);
        make.top.mas_equalTo(0);
    }];
    
    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, 0.7)];
    lineView.backgroundColor=BM_WHITE;
    [self addSubview:lineView];
    
   
    NSArray*nameArray=@[@"姓名",@"工号",@"步数"];
    for (int i=0; i<nameArray.count; i++) {
        UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake((DEF_SCREEN_WIDTH)/3*i, 100, DEF_SCREEN_WIDTH/3, 50)];
        lable.text=nameArray[i];
        lable.font=[UIFont systemFontOfSize:16];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=BM_WHITE;
        [self addSubview:lable];
    }
    int time=[UnityLHClass compareNewDate:pickerView1.dateLabel.text seconedDate:pickerView2.dateLabel.text];
    
    
    if (time!=1) {
        self.statrTimeStr=pickerView1.dateLabel.text;
        self.endTimeStr=pickerView2.dateLabel.text;
        
    }
  
    
    [self compStartTimeWithEndTime];

  
    
}
-(void)compStartTimeWithEndTime
{
    
    int time=[UnityLHClass compareNewDate:self.statrTimeStr seconedDate:self.endTimeStr];
    
    
    if (time!=1) {
        NSArray*timeArray=@[self.statrTimeStr,self.endTimeStr];
        [self sendObject:timeArray];
        
    }else{
        
        [UnityLHClass showHUDWithStringAndTime:@"结束时间不能大于其实时间"];
        
    }
}


-(NSArray *)getFirstAndLastDayOfThisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit |NSDayCalendarUnit fromDate:firstDay];
//    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
//    NSInteger day = [lastDateComponents day];
//    [lastDateComponents setDay:day+dayNumberOfMonth-1];
//    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return [NSArray arrayWithObjects:firstDay, nil];
}


@end
