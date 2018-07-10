//
//  MEDeviceController.h
//  OpenMobileAPI
//
//  Created by su on 14/9/15.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMISEService.h"
#import <MESDK/NLICCardModule.h>
/*!
 @class
 @abstract ME核心驱动
 @discussion 驱动主要封装了OpenMobile api体系，以及功能api。本驱动依赖于MESDK驱动的基础功能，如蓝牙设备的扫描、连接、断开，以及IC指令透传通信。
 */
@class NLAccountInfo;
@interface MEDeviceController : NSObject
/*!
 @method
 @abstract 获取实例对象
 @discussion 不要自己实例化该驱动对象，直接从这个方法获取实例对象。该实例对象是线程安全的。
 @result 返回实例对象
 */
+ (id)sharedInstance;
/*!
 @method
 @abstract 驱动构造器
 @discussion 务必在调用MESDK MESwiperController（目前为18、19）进行 connect连接成功，并且调用MESDK认证接口成功后，才能进行此初始化动作。
 @param listener SEService相关回调，如连接初始化成功
 @param icCardModule icCardModule模块
 @return 驱动实例
 */
- (id)initWithListener:(id<OMICallBack>)listener icCardModule:(id<NLICCardModule>)icCardModule;
/*!
 @method
 @abstract 判断当前设备是否处于连接可用状态
 @discussion
 @return 是否处于连接状态
 */
- (BOOL)isConnect;
/*!
 @method
 @abstract 获取AID列表
 @discussion
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return AID列表
 */
- (NSArray*)fetchAidList:(NSError**)err;
/*!
 @method
 @abstract 获取指定AID存储空间大小
 @discussion
 @param requestAid 指定的AID
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return 空间大小（单位bit）
 */
- (int)fetchSpecifiedStorageSize:(NSData*)requestAid error:(NSError**)err;
/*!
 @method
 @abstract 获取指定AID存储空间大小列表
 @discussion
 @param requestAids 指定的AID列表
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return 空间大小（单位bit）（key为aid、value为NSNumber存储空间）
 */
- (NSDictionary*)fetchSpecifiedStorageSizes:(NSArray*)requestAids error:(NSError**)err;
/*!
 @method
 @abstract 获取总存储空间大小
 @discussion
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return 空间大小（单位bit）
 */
- (UInt64)fetchTotalStorage:(NSError**)err;
/*!
 @method
 @abstract 获取指定AID详情
 @discussion
 @param aid 指定AID
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return AID详情
 */
- (NSData*)fetchSpecifiedAidDetail:(NSData*)aid error:(NSError**)err;
/*!
 @method
 @abstract 获取指定AID的账号信息
 @discussion
 @param requestAid 指定AID
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return 账号信息
 */
- (NLAccountInfo*)fetchAcctInfo:(NSData*)requestAid error:(NSError**)err;
/*!
 @method
 @abstract 获取SEID
 @discussion
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return SEID
 */
- (NSData*)fetchSeid:(NSError**)err;
/*!
 @method
 @abstract 设备通信
 @discussion
 @param err(out) 传入err指针，内部如通信失败、指令异常、执行错误将对该指针进行赋值
 @return 响应数据
 */
- (NSData*)communicate:(NSError**)err;
/*!
 @method
 @abstract 设置批次号头两位数值
 @discussion
 @param piciNumFirstTwo 批次号头两位 FF
 @return
 */
- (void)setPiCiNum:(NSString*)piciNumFirstSix error:(NSError**)err;

@end


@interface NLAccountInfo : NSObject
/**
 * 账号
 */
@property (nonatomic, copy) NSString *acctNo;
/**
 * 电子现金余额（单位：元）
 */
@property (nonatomic, copy, readonly) NSDecimalNumber *balance;
/**
 * 过期日期
 */
@property (nonatomic, copy) NSString *expiredDate;
/**
 * 货币种类
 */
@property (nonatomic, copy) NSString *currencyCode;
/**
 * 应用版本号
 */
@property (nonatomic, copy) NSString *appVer;
/**
 * 二磁道
 */
@property (nonatomic, copy) NSData *secondTrackData;
/**
 * 卡片序列号
 */
@property (nonatomic, copy) NSString *cardSequenceNumber;

/**
 * 55域数据
 */
@property (nonatomic, copy) NSData *area55Data;
/*!
 *  电子现金余额（单位：分），与balance字段等同，单位不同
 *
 *  @return 电子现金余额
 */
- (NSDecimalNumber*)balanceByFenUnit;
@end

