//
//  HLLEvent.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HLLEventStatus) {
    
    HLLEventStatusNormal,
    HLLEventStatusAppointment,
    HLLEventStatusFinish,
    HLLEventStatusLiving
};

@interface HLLEvent : NSObject

@property (nonatomic ,assign ,getter=isEmpty) BOOL empty;

@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,strong) NSString * dateString;
@property (nonatomic ,assign) HLLEventStatus status;

@property (nonatomic ,strong) NSString * statusText;
@property (nonatomic ,strong) UIColor * statusColor;

@property (nonatomic ,strong) NSString * livingId;
@property (nonatomic ,strong) NSString * livingURL;

@property (nonatomic ,assign ,getter=isAM) BOOL AM;// 上午

+ (instancetype) emptyEvent;
+ (instancetype) event;

/// test
+ (instancetype) normal;
+ (instancetype) finish;
+ (instancetype) living;
+ (instancetype) appotionment;

- (void) config:(id)data;
@end

@interface HLLWeekDay : NSObject

@property (nonatomic ,strong) NSString * week;
@property (nonatomic ,strong) NSString * day;
@property (nonatomic ,strong) NSString * fullDate;


+ (NSArray<HLLWeekDay *> *)weekDays;
+ (NSInteger) todayIndex;
+ (NSString *) todayWeek;
@end
