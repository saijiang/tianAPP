//
//  NLDeviceInfo.h
//  mpos
//
//  Created by su on 13-6-18.
//  Copyright (c) 2013年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLProductID.h"
#import "NLManufacturerID.h"
/*!
 @enum
 @abstract 设备当前状态
 @constant NLDeviceStatePassivePrepared 无源待工
 @constant NLDeviceStatePassiveWorking 无源工作 
 @constant NLDeviceStateActivePrepared 有源待工
 @constant NLDeviceStateActiveWorking 有源工作
 */
typedef enum {
    NLDeviceStatePassivePrepared = 0,
    NLDeviceStatePassiveWorking = 1,
    NLDeviceStateActivePrepared = 2,
    NLDeviceStateActiveWorking = 3,
} NLDeviceState;

/*!
 @enum
 @abstract 设备类型
 @constant NLDeviceTypeME30 ME30设备
 @constant NLDeviceTypeME31 ME31设备
 @constant NLDeviceTypeME11 ME11设备
 @constant NLDeviceTypeME81 ME81设备
 @constant NLDeviceTypeME30S ME30S设备
 @constant NLDeviceTypeME30C ME30C设备
 @constant NLDeviceTypeME31New ME31New设备
 @constant NLDeviceTypeME15 ME15设备
 @constant NLDeviceTypeUnKnown 未知设备 @since 1.0.6
 */
typedef enum {
    NLDeviceTypeME30,
    NLDeviceTypeME31,
    NLDeviceTypeME11,
    NLDeviceTypeME81,
    NLDeviceTypeME30S,
    NLDeviceTypeME30C,
    NLDeviceTypeME31New,
    NLDeviceTypeME15,
    NLDeviceTypeUnKnown
} NLDeviceType;

/*!
 @protocol DeviceInfo设备信息
 @abstract 设备信息
 @discussion 对于满足规范的设备，均必须遵循给定接口返回设备信息
 */
@protocol NLDeviceInfo <NSObject>
/*!
 @method 获得设备唯一硬件编号
 @abstract 若该设备的硬件编号需要保护，该方法可以返回为空
 @return 厂商硬件编号
 */
- (NSString*)sn;
/*!
 @method
 @abstract 保留字段
 @return
 */
- (NSData*)reserve;
/*!
 @method
 @abstract 设备状态
 @return
 */
- (NLDeviceState)deviceState;
/*!
 @method 获得当前安全设备固件版本
 @abstract
 @return 固件版本
 */
- (NSString*)firmwareVersion;
/*!
 @method 获得设备应用版本号
 @abstract
 @return appVer
 */
- (NSString*)appVer;
/*!
 @method 获得客户定义的设备序列号CSN
 @abstract
 @return CSN
 */
- (NSString*)CSN;
/*!
 @method 密钥序列号（KSN）
 @abstract
 @return ksn
 */
- (NSString*)ksn;
/*!
 @method 产品ID
 @abstract
 @return
 */
- (NLProductID)productId;
/*!
 @method 厂商ID
 @abstract
 @return
 */
- (NLManufacturerID)manufacturerId;
/*!
 @method 拉卡拉生产SN号
 @abstract
 @return
 */
- (NSString*)lakalaSn;
/*!
 @method 厂商自定义信息
 @abstract
 @return
 */
- (NSData*)manufacturerUserDefined;
/*!
 @method 配置文件版本
 @abstract
 @return
 */
- (NSData*)profileVersion;
/*!
 @since 1.0.6
 @method 获得PID的数值，如果无法获取到对应的设备类型，可以尝试获取该对象匹配具体的产品类型。
 @abstract
 @return
 */
- (NSData*)pidNums;
/**
 @since 1.0.6
 * 生产配置
 *  生产规则：8 个字节的设备能力+两个 0x00(RFU)总 共 10 个字节 设备能力见最新版《拉卡拉产品配置表》
 * @return
 */
- (NSData*)productConfigures;
///**
// * 判断设备是否支持音频
// * @return
// */
//- (BOOL)isSupportAudio;
///**
// * 判断设备是否支持蓝牙
// * @return
// */
//- (BOOL)isSupportBlueTooth;
///**
// * 判断设备是否支持USB
// * @return
// */
//- (BOOL)isSupportUSB;
///**
// * 判断设备是否支持磁条卡
// * @return
// */
//- (BOOL)isSupportMagCard;
///**
// * 判断设备是否支持接触式IC卡
// * @return
// */
//- (BOOL)isSupportICCard;
///**
// * 判断设备是否支持非接触IC卡
// * @return
// */
//- (BOOL)isSupportQuickPass;
///**
// * 判断设备是否支持打印
// * @return
// */
//- (BOOL)isSupportPrint;
///**
// * 判断设备是否支持屏幕显示
// * @return
// */
//- (BOOL)isSupportLCD;
@end
