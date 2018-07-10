//
//  HLLEvent.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HLLEvent.h"

@implementation HLLEvent

+ (instancetype) emptyEvent{

    HLLEvent * event = [[HLLEvent alloc] init];
    event.empty = YES;
    return event;
}

+ (instancetype) event{

    HLLEvent * event = [[HLLEvent alloc] init];
    return event;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.empty = NO;
        
        self.title = @"xxx";
        self.dateString = @"9:00-12:20";
    }
    return self;
}

// test

+ (instancetype) normal{

    HLLEvent * event = [[HLLEvent alloc] init];
    event.title = @"动感单车";
    event.status = HLLEventStatusNormal;
    return event;
}
+ (instancetype) finish{
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusFinish;
    event.title = @"跑步机";
    return event;
}
+ (instancetype) living{
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusLiving;
    event.title = @"背阔肌";
    return event;
}
+ (instancetype) appotionment{
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusAppointment;
    event.title = @"普拉提";
    return event;
}

- (void)setStatus:(HLLEventStatus)status{
    _status=status;
    switch (status) {
        case HLLEventStatusAppointment:
            self.statusText = @"已预约";
            self.statusColor = [UIColor colorWithHexString:@"#B7B7B7"];
            break;
        
        case HLLEventStatusFinish:
            self.statusText = @"已结束";
            self.statusColor = [UIColor colorWithHexString:@"#B7B7B7"];
            break;
        
        case HLLEventStatusLiving:
            self.statusText = @"直播中";
            self.statusColor = [UIColor colorWithHexString:@"#53B1D9"];
            break;
        
        case HLLEventStatusNormal:
            self.statusText = @"可预约";
            self.statusColor = [UIColor colorWithHexString:@"FF6655"];
            break;
        default:
            self.statusText = @"";
            self.statusColor = [UIColor whiteColor];
            break;
    }
}

- (void) config:(id)data{

    if ([data[@"isAppoint"]  isEqual: @"02"])
    {
        self.status = HLLEventStatusAppointment;
        if ([data[@"isStart"]  isEqual: @"02"]) {
            self.status = HLLEventStatusLiving;
        }
        if ([data[@"isStart"]  isEqual: @"03"]) {
            self.status = HLLEventStatusFinish;
        }

    }
    else
    {
        if ([data[@"isStart"]  isEqual: @"01"]) {
            self.status = HLLEventStatusNormal;
        }
        
        if ([data[@"isStart"]  isEqual: @"02"]) {
            self.status = HLLEventStatusLiving;
        }
        
        if ([data[@"isStart"]  isEqual: @"03"]) {
            self.status = HLLEventStatusFinish;
        }
    }
   
    
    self.title = data[@"title"];
    self.dateString = [NSString stringWithFormat:@"%@-%@",data[@"startTime"],data[@"endTime"]];
    self.AM = [data[@"liveAmPmDiv"] isEqual:@"01"];
    self.livingId = data[@"id"];
    self.livingURL = data[@"liveAddress"];
    
}
@end

@implementation HLLWeekDay

+ (NSArray<HLLWeekDay *> *)weekDays{
    
    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    NSMutableArray * weekDays = [NSMutableArray array];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString * week = weeks[index];
        HLLWeekDay * weekDay = [[HLLWeekDay alloc] init];
        weekDay.week = week;
        weekDay.day = formatterDay;
        weekDay.fullDate = [dateFormatter stringFromDate:yesterday];
        [weekDays addObject:weekDay];
    }
    
    return weekDays;
}

+ (NSInteger) todayIndex{
    
    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        NSString * todayFromatterDay = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        if ([todayFromatterDay isEqualToString:formatterDay]) {
            
            return index;
        }
    }
    return NSNotFound;
}

+ (NSString *) todayWeek{
    
    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        NSString * todayFromatterDay = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        if ([todayFromatterDay isEqualToString:formatterDay]) {
            
            return weeks[index];
        }
    }
    return @"";
}
@end
