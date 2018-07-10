//
//  FullTimeView.m
//  ios2688webshop
//
//  Created by wangchan on 16/2/23.
//  Copyright © 2016年 zhangzl. All rights reserved.
//

#import "FullTimeView.h"
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface FullTimeView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView*fullPickView;
    
    NSInteger yearRange;
    NSInteger startYear;
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    
    NSDate *_curDate;
    
    NSInteger currentYear;
    NSInteger currentMonth;
}
@end

@implementation FullTimeView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
-(void)config
{
    CGFloat perWidth=self.frame.size.width;
    CGFloat height=self.frame.size.height;
    //0
    fullPickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, perWidth, height)];
    fullPickView.dataSource=self;
    fullPickView.delegate=self;
    [self addSubview:fullPickView];
    
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    
    startYear=year-100;
    yearRange=120;
    selectedYear=2000;
    selectedMonth=1;
}

- (NSDate *)curDate
{
    return _curDate;
}

//默认时间的处理
-(void)setCurDate:(NSDate *)curDate
{
    if (_curDate != curDate) {
       _curDate = curDate;
    }
    
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:curDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    
    currentYear = year;//当前年
    currentMonth = month;//当前月
    selectedYear=year; //选择年
    selectedMonth=month; //选择月
    
    [fullPickView selectRow:year-startYear inComponent:0 animated:true];
    [fullPickView selectRow:month-1 inComponent:1 animated:true];
    [fullPickView reloadAllComponents];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    label.font=[UIFont systemFontOfSize:18];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            if (row > currentYear-startYear){//以后年
                label.textColor = [UIColor lightGrayColor];
            }else {
                label.textColor = [UIColor blackColor];
            }
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            if (selectedYear > currentYear) {//以后年
               label.textColor = [UIColor lightGrayColor];
            }else if (selectedYear == currentYear){// 现在年
                if (row > currentMonth-1) {//以后月
                    label.textColor = [UIColor lightGrayColor];
                }else {
                    label.textColor = [UIColor blackColor];
                }
            }else {//以前年
                   label.textColor = [UIColor blackColor];
            }
            
        }
            break;

        default:
            break;
    }
    return label;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            selectedYear=startYear + row;
            [fullPickView reloadComponent:1];
            if (selectedYear >currentYear){//选择的是以后年份和当前年份时
                selectedYear = currentYear;
                selectedMonth = currentMonth;
                [fullPickView selectRow:currentYear-startYear inComponent:0 animated:true];
                [fullPickView selectRow:currentMonth-1 inComponent:1 animated:true];
            }
             [fullPickView reloadComponent:1];
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            if (selectedYear == currentYear){
                if (selectedMonth > currentMonth){
                    selectedMonth = currentMonth;
                    [fullPickView selectRow:currentMonth-1 inComponent:1 animated:true];
                }
            }
            [fullPickView reloadComponent:1];
        }
            break;
        
        default:
            break;
    }
    NSString*string =[NSString stringWithFormat:@"%ld-%.2ld",(long)selectedYear,(long)selectedMonth];
   // NSLog(@"%ld-%ld",(long)selectedYear,(long)selectedMonth);
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
   // NSLog(@"date= %@", inputDate);
    
    //获取的GMT时间，要想获得某个时区的时间，以下代码可以解决这个问题
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
//    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
//    NSLog(@"%@", localeDate);
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
        [self.delegate didFinishPickView:inputDate];
    }
}
@end
