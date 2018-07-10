//
//  LDBraceletFitOperator.h
//  LDBraceletSDK
//
//  Created by houhm on 16/11/24.
//  Copyright © 2016年 houhm. All rights reserved.
//

#ifndef LDBraceletFitOperator_h
#define LDBraceletFitOperator_h
#import "CommonClass.h"

@protocol LDBraceletFitOperator

- (double)getCalorie:(bool)sex height:(u_long)height weight:(u_long)weight age:(u_long)age run:(u_long)run walk:(u_long)walk;

-(void)setPersonalParams:(LklPersonalParams *)params;

-(LklPersonalParams *)personalParams;

-(void)setCurSportTarget:(NSInteger)target;

-(NSInteger)curSportTarget;

- (void)setCurSleepTarget:(NSInteger)target;

- (NSInteger)curSleepTarget;

- (void)setStepLenght:(LklStepLenght *)stepLenght;

-(void)setAlarmClock:(int)tag data:(NSMutableDictionary *)data;

-(NSMutableDictionary *)alarmClock:(int)tag;
/**
 *设置提醒开关
 * byte数组，目前有8位
 * Byte1 手机来电提醒
 * Byte2 短信
 * Byte3 抬手亮屏
 * Byte4 手环来电
 * Byte5 久坐提醒
 * Byte6 手机防丢
 * Byte7 蓝牙速率切换
 * Byte8 微信运动开关
 * 每位值有三种：0x01 打开；0x00 关闭；0x03及其他 不设置
 *
 **/
-(void)setRemind:(NSData *)flags;


-(NSData *)remind;

/**
 * 设置久坐提醒
 * @param start 提醒起始时间
 * @param end   提醒中止时间
 * @param flag  1:打开；0：关闭
 * @param time 久坐提醒时间 单位：分钟
 *
 **/
-(void)setSittingRemind:(int)start end:(int)end open:(int)flag time:(int)time;

/*
 * 获取久坐提醒数据
 *
 * 返回数据包含以下：
 * @param start 提醒起始时间
 * @param end   提醒中止时间
 * @param flag  1:打开；0：关闭
 * @param 久坐提醒时间 单位：分钟
 *
 */
-(NSMutableDictionary *)sittingRemind;
/**
 *
 * 获取当前运动记录
 *
 *包含以下属性：
 * 日期：date
 * 小时：time
 * 行走的步数  walkCount;
 * 行走的距离，单位：米 walkDistance;
 * 行走的时间，单位：分钟* walkTime;
 * 跑步的步数  runCount;
 * 跑步的距离，单位：米 runDistance;
 * 跑步的时间，单位：分钟 runTime;
 * 总距离，  单位：米 distance
 * 卡路里，  单位：卡 calorie
 **/
-(NSArray *)currentSportRecord;

/**
 * 获取有效运动的tag，一天对应一个tag
 *
 **/
-(NSArray *)effectiveSprotTaglist;

/**
 *
 * 获取指定tag的运动记录
 * @param day 指定tag
 *
 * 返回数据包含以下属性：
 * 日期：date
 * 小时：time
 * 行走的步数* walkCount;
 * 行走的距离，单位：米 walkDistance;
 * 行走的时间，单位：分钟* walkTime;
 * 跑步的步数  runCount;
 * 跑步的距离，单位：米 runDistance;
 * 跑步的时间，单位：分钟 runTime;
 * 总距离，  单位：米 distance
 * 卡路里，  单位：卡 calorie
 **/
-(NSArray *)historySportRecord:(int)day;


/**
 * 清除指定tag的运动记录
 *
 * @param day 指定tag
 **/
-(void)clearHistorySportRecord:(int)day;

/**
 *
 * 获取当前睡眠记录
 * 包含以下属性：
 * [
 * {
 *  date:日期
 *  starTime:开始时间
 *  endTime:结束时间
 *  status:状态
 *  }
 * {
 *  date:日期
 *  starTime:开始时间
 *  endTime:结束时间
 *  status:状态（睡眠状态，0：深睡眠，1：浅睡眠，2：意识睡眠，3：活动状态）
 *  }
 * ]
 **/
-(NSArray *)currentSleepRecord;

/**
 * 获取有效睡眠的tag，一天对应一个tag
 *
 **/
-(NSArray *)effectiveSleepTaglist;

/**
 *
 * 获取指定tag的睡眠记录
 * 包含以下属性：
 * [
 * {
 *  date:日期
 *  starTime:开始时间
 *  endTime:结束时间
 *  status:状态
 *  }
 * {
 *  date:日期
 *  starTime:开始时间
 *  endTime:结束时间
 *  status:状态（睡眠状态，0：深睡眠，1：浅睡眠，2：意识睡眠，3：活动状态）
 *  }
 * ]
 **/
-(NSArray *)historySleepRecord:(int)day;


/**
 * 清除指定tag的睡眠记录
 *
 **/
-(void)clearHistorySleepRecord:(int)day;

/**
 *获取步长
 *
 **/
-(LklStepLenght *)stepLenth;

/**
 *获取心率
 *
 **/
- (int)heartRate;

/**
 开始进入心率实时监听模式
 
 @return 心率实时监听模式进入结果
 */
- (BOOL)startHeartRateRealTimeMonitor;
/**
 退出实时心率实时监听模式
 */
- (BOOL)stopHeartRateRealTimeMonitor;

- (NSArray *)historyHeartRateRecords;

- (BOOL)clearHeartRateRecords;

@end

#endif
