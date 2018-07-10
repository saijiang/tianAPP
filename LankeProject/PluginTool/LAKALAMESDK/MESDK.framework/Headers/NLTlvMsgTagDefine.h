//
//  NLTlvMsgTagDefine.h
//  MTypeSDK
//
//  Created by wanglx on 15/6/8.
//  Copyright (c) 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NLTlvMsgTagDefineHeightTag                  = 0xDF01,//个人身高
    NLTlvMsgTagDefineWeightTag                  = 0xDF02,//个人体重
    NLTlvMsgTagDefineSexTag                     = 0xDF03,//个人性别
    NLTlvMsgTagDefineWalkStepLengthTag          = 0xDF04,//步行歩长
    NLTlvMsgTagDefineRunStepLengthTag           = 0xDF05,//跑步步长
    NLTlvMsgTagDefineCurrentSportTargetTag      = 0xDF06,//当前运动目标
    NLTlvMsgTagDefineCurrentSleepTargetTag      = 0xDF08,//当前睡眠目标
    NLTlvMsgTagDefineSittingRemindTag           = 0xDF0A,//久坐提醒
    
    NLTlvMsgTagDefineCurrentSportRecordTag      = 0xDF20,//当前运动记录
    NLTlvMsgTagDefineHistorySportrecordTagDay01 = 0xDF21,//历史运动记录 1天前
    NLTlvMsgTagDefineHistorySportrecordTagDay02 = 0xDF22,
    NLTlvMsgTagDefineHistorySportrecordTagDay03 = 0xDF23,
    NLTlvMsgTagDefineHistorySportrecordTagDay04 = 0xDF24,
    NLTlvMsgTagDefineHistorySportrecordTagDay05 = 0xDF25,
    NLTlvMsgTagDefineHistorySportrecordTagDay06 = 0xDF26,
    NLTlvMsgTagDefineHistorySportrecordTagDay07 = 0xDF27,
    NLTlvMsgTagDefineHistorySportrecordTagDay08 = 0xDF28,
    NLTlvMsgTagDefineHistorySportrecordTagDay09 = 0xDF29,
    NLTlvMsgTagDefineHistorySportrecordTagDay10 = 0xDF2A,
    NLTlvMsgTagDefineHistorySportrecordTagDay11 = 0xDF2B,
    NLTlvMsgTagDefineHistorySportrecordTagDay12 = 0xDF2C,
    NLTlvMsgTagDefineHistorySportrecordTagDay13 = 0xDF2D,
    NLTlvMsgTagDefineHistorySportrecordTagDay14 = 0xDF2E,
    NLTlvMsgTagDefineHistorySportrecordTagDay15 = 0xDF2F,
    NLTlvMsgTagDefineHistorySportrecordTagDay16 = 0xDF30,
    NLTlvMsgTagDefineHistorySportrecordTagDay17 = 0xDF31,
    NLTlvMsgTagDefineHistorySportrecordTagDay18 = 0xDF32,
    NLTlvMsgTagDefineHistorySportrecordTagDay19 = 0xDF33,
    NLTlvMsgTagDefineHistorySportrecordTagDay20 = 0xDF34,
    NLTlvMsgTagDefineHistorySportrecordTagDay21 = 0xDF35,
    NLTlvMsgTagDefineHistorySportrecordTagDay22 = 0xDF36,
    NLTlvMsgTagDefineHistorySportrecordTagDay23 = 0xDF37,
    NLTlvMsgTagDefineHistorySportrecordTagDay24 = 0xDF38,
    NLTlvMsgTagDefineHistorySportrecordTagDay25 = 0xDF39,
    NLTlvMsgTagDefineHistorySportrecordTagDay26 = 0xDF3A,
    NLTlvMsgTagDefineHistorySportrecordTagDay27 = 0xDF3B,
    NLTlvMsgTagDefineHistorySportrecordTagDay28 = 0xDF3C,
    NLTlvMsgTagDefineHistorySportrecordTagDay29 = 0xDF3D,
    NLTlvMsgTagDefineHistorySportrecordTagDay30 = 0xDF3E,
    NLTlvMsgTagDefineEffectiveSportRecordTag    = 0xDF3F,//历史运动有效记录

    NLTlvMsgTagDefineCurrentSleepRecordTag      = 0xDF40,//当前睡眠记录
    NLTlvMsgTagDefineHistorySleepRecordTagDay01 = 0xDF41,//历史睡眠记录 1天前
    NLTlvMsgTagDefineHistorySleepRecordTagDay02 = 0xDF42,
    NLTlvMsgTagDefineHistorySleepRecordTagDay03 = 0xDF43,
    NLTlvMsgTagDefineHistorySleepRecordTagDay04 = 0xDF44,
    NLTlvMsgTagDefineHistorySleepRecordTagDay05 = 0xDF45,
    NLTlvMsgTagDefineHistorySleepRecordTagDay06 = 0xDF46,
    NLTlvMsgTagDefineHistorySleepRecordTagDay07 = 0xDF47,
    NLTlvMsgTagDefineHistorySleepRecordTagDay08 = 0xDF48,
    NLTlvMsgTagDefineHistorySleepRecordTagDay09 = 0xDF49,
    NLTlvMsgTagDefineHistorySleepRecordTagDay10 = 0xDF4A,
    NLTlvMsgTagDefineHistorySleepRecordTagDay11 = 0xDF4B,
    NLTlvMsgTagDefineHistorySleepRecordTagDay12 = 0xDF4C,
    NLTlvMsgTagDefineHistorySleepRecordTagDay13 = 0xDF4D,
    NLTlvMsgTagDefineHistorySleepRecordTagDay14 = 0xDF4E,
    NLTlvMsgTagDefineHistorySleepRecordTagDay15 = 0xDF4F,
    NLTlvMsgTagDefineHistorySleepRecordTagDay16 = 0xDF50,
    NLTlvMsgTagDefineHistorySleepRecordTagDay17 = 0xDF51,
    NLTlvMsgTagDefineHistorySleepRecordTagDay18 = 0xDF52,
    NLTlvMsgTagDefineHistorySleepRecordTagDay19 = 0xDF53,
    NLTlvMsgTagDefineHistorySleepRecordTagDay20 = 0xDF54,
    NLTlvMsgTagDefineHistorySleepRecordTagDay21 = 0xDF55,
    NLTlvMsgTagDefineHistorySleepRecordTagDay22 = 0xDF56,
    NLTlvMsgTagDefineHistorySleepRecordTagDay23 = 0xDF57,
    NLTlvMsgTagDefineHistorySleepRecordTagDay24 = 0xDF58,
    NLTlvMsgTagDefineHistorySleepRecordTagDay25 = 0xDF59,
    NLTlvMsgTagDefineHistorySleepRecordTagDay26 = 0xDF5A,
    NLTlvMsgTagDefineHistorySleepRecordTagDay27 = 0xDF5B,
    NLTlvMsgTagDefineHistorySleepRecordTagDay28 = 0xDF5C,
    NLTlvMsgTagDefineHistorySleepRecordTagDay29 = 0xDF5D,
    NLTlvMsgTagDefineHistorySleepRecordTagDay30 = 0xDF5E,
    NLTlvMsgTagDefineEffectiveSleepRecordTag    = 0xDF5F,//睡眠有效记录
    
    NLTlvMsgTagDefineAlarmClockTag1             = 0xDF60,//闹钟
    NLTlvMsgTagDefineAlarmClockTag2             = 0xDF61,
    NLTlvMsgTagDefineAlarmClockTag3             = 0xDF62,
    NLTlvMsgTagDefineAlarmClockTag4             = 0xDF63,
    NLTlvMsgTagDefineAlarmClockTag5             = 0xDF64,
    NLTlvMsgTagDefineFindBracelet               = 0xDF74,//查找手环
    NLTlvMsgTagDefineCardPackageList            = 0xDF10,//卡包列表(废弃)
    NLTlvMsgTagDefineLocalConsumeRecords        = 0xDF11,//本地消费记录
    NLTlvMsgTagDefineBalanceRemind              = 0xDF12, //余额提醒设置
    NLTlvMsgTagDefineCommitApponitRecord        = 0xDF14, //指定应用记录上传
    NLTlvMsgTagDefineAvailableCardPackageList   = 0xDF17, //卡包列表
}NLTlvMsgTagDefine;
