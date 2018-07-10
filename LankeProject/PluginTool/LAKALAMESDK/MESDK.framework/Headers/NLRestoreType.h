//
//  NLRestoreType.h
//  MTypeSDK
//
//  Created by wanglx on 15/4/20.
//  Copyright (c) 2015年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    /**
     * 系统休眠时间
     */
    NLRestoreType_DORMANCY = 0x01,
    /**
     * 身高
     */
    NLRestoreType_HEIGHT = 0x02,
    
    /**
     * 体重
     */
    NLRestoreType_WEIGHT = 0x04,
    /**
     * 性别
     */
    NLRestoreType_SEX = 0x08,
    /**
     * 健步步长
     */
    NLRestoreType_WALK_STEPLENGTH = 0x10,
    /**
     * 跑步步长
     */
    NLRestoreType_RUN_STEPLENGTH = 0x20,
    /**
     * 运动目标
     */
    NLRestoreType_SPORT_TARGET = 0x40,
    /**
     * 运动记录
     */
    NLRestoreType_SPROT_RECORD = 0x80,
    /**
     *  睡眠目标
     */
    NLRestoreType_SLEEP_TARGET = 0x100,
    /**
     *  睡眠记录
     */
    NLRestoreType_SLEEP_RECODR = 0x200,
    /**
     *  闹钟0
     */
    NLRestoreType_ALARM0 = 0x400,
    /**
     *  闹钟1
     */
    NLRestoreType_ALARM1 = 0x800,
    /**
     *  闹钟2
     */
    NLRestoreType_ALARM2 = 0x1000,
    /**
     *  闹钟3
     */
    NLRestoreType_ALARM3 = 0x2000,
    /**
     *  闹钟4
     */
    NLRestoreType_ALARM4 = 0x4000,
    /**
     *  防丢失提醒
     */
    NLRestoreType_LOST_REMIND = 0x8000,
    /**
     *  设置提醒
     */
    NLRestoreType_REMIND = 0x10000,
    /**
     *  卡包列表
     */
    NLRestoreType_CARDPACKAGE_LIST = 0x20000,
    /**
     *   消费记录
     */
    NLRestoreType_CONSUMRECORDS_LIST = 0x40000,
    /**
     *   余额提醒
     */
    NLRestoreType_BALANCE_REMIND = 0x80000,
}NLRestoreType;
