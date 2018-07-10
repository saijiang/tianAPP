//
//  NLDevice.h
//  mpos
//
//  Created by su on 13-6-20.
//  Copyright (c) 2013年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLModule.h"
#import "NLDeviceInfo.h"
#import "TLVPackage.h"
#import "TLVMsg.h"
#import "NLDeviceBehavior.h"
#import "NLBatteryInfo.h"
@protocol NLUpdateOTADelegate;
typedef void (^OnUpdateReturn)(int fileIndex, BOOL isFinish,NSError * err);
@protocol NLModule;
/*!
 @protocol Device设备描述接口
 @abstract 设备描述接口
 @discussion
 */
@protocol NLDevice <NSObject>
/*!
 @method 获得设备信息
 @abstract 当前设备的设备信息
 @return
 */
- (NSObject<NLDeviceInfo>*)deviceInfo;
/*!
 @since 1.1.3
 @method 获得当前设备内电池信息
 @abstract 获得当前设备内电池信息
 @return
 */
-(id<NLBatteryInfo>)batteryInfo;
/*!
 @method
 @abstract 返回当前设备状态
 @return
 */
- (NLDeviceState)deviceState;
/*!
 @method
 @abstract 获得当前设备内时间
 @discussion 若设备内部没有时钟，则该方法返回空
 @return
 */
- (NSDate*)deviceDate;
/*!
 @method
 @abstract 设置设备内部时间
 @discussion 若设备不支持始终，则该方法不做任何处理。
 @return
 */
- (void)setDeviceDate:(NSDate*)date;
///*!
// @expire
// @method
// @abstract 获得一个终端参数列表
// @return
// */
//- (NSObject<TLVPackage>*)deviceParams;
/*!
 @version 1.0.4
 @method
 @abstract 获得一个终端参数列表
 @param tags (int 数组) 标签
 @return
 */
- (NSObject<TLVPackage>*)deviceParamsWithTags:(NSArray*)tags;
/*!
 @method
 @abstract 获得一个终端参数
 @param model 标签
 @return
 */
- (NSData*)deviceParamsWithModel:(int)model;
/*!
 @method
 @abstract 设置终端参数
 @return
 */
- (void)setDeviceParams:(NSObject<TLVPackage>*)tlvPackage;
/*!
 @method
 @abstract 获得所有支持的模块类型
 @return
 */
- (NSArray*)supportStandardModule;
/*!
 @method
 @abstract 获得对应模块的操作对象
 @param moduleType 模块类型
 @return
 */
- (NSObject<NLModule>*)standardModuleWithModuleType:(NLModuleType)moduleType;
/*!
 @method
 @abstract 获得支持的扩展设备模块
 @return
 */
- (NSArray*)supportExModule;
/*!
 @method
 @abstract 获得扩展模块操作对象
 @param moduleType 模块类型
 @return
 */
- (NSObject<NLModule>*)exModuleWithModuleType:(NSString*)moduleType;
/*!
 @method
 @abstract 关闭设备连接，并回收所有资源
 @return
 */
- (void)destroy;
/*!
 @method
 @abstract 设备连接是否存活
 @return
 */
- (BOOL)isAlive;
/*!
 @method
 @abstract 设备软复位。
 @discussion 撤消设备指令,并初始化状态
 @return 撤销结果
 */
- (int)reset;
/*!
 @version 1.0.4
 @method
 @abstract 撤销当前指令
 @return
 */
- (void)cancelCurrentExecute;

/*!
 @version 1.0.6
 @method
 @abstract 使设备进入休眠状态
 @return
 */
- (void)sleep;
/*!
 @version 1.0.6
 @method
 @abstract 设备关闭
 @return
 */
- (void)shutdown;
/*!
 @version 1.0.6
 @method
 @abstract 更新设备应用
 @param inputStream
 @return
 */
- (void)updateAppWithInputStream:(NSInputStream*)inputStream error:(NSError**)err;
/*!
 @version 1.0.6
 @method
 @abstract 更新设备固件
 @param inpuStream
 @return
 */
- (void)updateFirmwareWithInputStream:(NSInputStream *)inputStream error:(NSError**)err;
/**
 *  更新固件
 *  @version 1.0.7
 *  @param inputStream    文件
 *  @param fileSize       文件长度
 *  @param isForce        是否强制升级
 *  @param block          ^(int length, BOOL isFinish,NSError * err)
 *
 *  @return 更新成功与否
 */
- (BOOL)updateAppWithInputStream:(NSInputStream*)inputStream fileSize:(int)fileSize isForce:(BOOL)isForce  block:(OnUpdateReturn)block;
/**
 *  更新NFC
 *  @version 1.0.7
 *  @param inputStream    文件
 *  @param fileSize       文件长度
 *  @param isForce        是否强制升级
 *  @param block          ^(int length, BOOL isFinish,NSError * err)
 *
 *  @return 更新成功与否
 */
- (BOOL)updateNFCWithInputStream:(NSInputStream*)inputStream fileSize:(int)fileSize isForce:(BOOL)isForce  block:(OnUpdateReturn)block;

/*!
 @version 1.0.6
 @method
 @abstract 设备回响测试<p>
 若回响测试通过则返回<tt>true</tt>
 否则返回<tt>false</tt>
 @param payload 回响测试数据
 @return
 */
- (BOOL)echoWithPayload:(NSData*)payload;
/**
 *  设置系统待机、休眠、关机时间
 *
 *  @param suspendTime  待机时长（秒）
 *  @param dormantTime  休眠时长（秒）
 *  @param shutdownTime 关机时长（秒）
 */
-(void)setSysSuspendTime:(NSInteger)suspendTime dormantTime:(NSInteger)dormantTime shutdownTime:(NSInteger)shutdownTime;
/**
 *  恢复出厂设置
 *
 *  @param types NLRestoreType 数组
 */
-(void)restoreFactory:(NSArray *)types;
/**
 *  设备关闭、休眠、重启
 *
 *  @param operation NLDeviceBehavior_CLOSE 关闭 NLDeviceBehavior_SLEEP 休眠 NLDeviceBehavior_CREBOOT 重启
 */
-(void)shutdownDevice:(NLDeviceBehavior)operation;
/**
 *  设备绑定
 *
 *  @param data
 *
 *  @return
 */
-(BOOL)deviceBinding:(NSData*)data;
/**
 *  进入OTA模式
 *
 *  @param param 参数（预留）（传0x00）
 *
 *  @return 是否设置成功
 */
-(BOOL)turnToOTA:(Byte)param;
/**
 *  蓝牙参数设置
 *
 *  @param reConnectParam 重连参数 （0x00:断开重连后生效 0x01:直接生效）
 *  @param modelParam     模式参数 （0x00:低速模式 0x01:高速模式）
 *  @return 是否设置成功
 */
-(BOOL)bluetoothSetting:(Byte)reConnectParam model:(Byte)modelParam;
/**
 *  OTA升级
 *
 *  @param path     路径
 *  @param uuid     要升级的uuid
 *  @param delegate 升级回调代理
 */
-(void)updateOTA:(NSString *)path uuid:(NSString *)uuid delegate:(id<NLUpdateOTADelegate>)delegate;
@end
