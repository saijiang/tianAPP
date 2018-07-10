//
//  LAKALABraceletManager.h
//  LankeProject
//
//  Created by itman on 17/4/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

typedef NS_ENUM(NSInteger, LKLBraceletType)
{
    LKLBraceletTypeB1 =1,//拉卡拉B1
    LKLBraceletTypeB2 =2,//拉卡拉B2
    LKLBraceletTypeB3 =3,//拉卡拉B3
};
typedef enum {
    LKLWatchControllerDecodeResultSwipeFail,
    LKLWatchControllerDecodeResultCRCError,
    LKLWatchControllerDecodeResultCommError,
    LKLWatchControllerDecodeResultUnknownError
} LKLWatchControllerDecodeResult;

typedef NS_ENUM(NSInteger,LKLWatchAdapterConnectType) {
    LKL_ADAPTER_CONNECT_0,                           // 表示主动断开成功，调用disconnect返回或者调用connect失败返回；
    LKL_ADAPTER_CONNECT_1,                           // 表示链接成功，调用connect成功返回
    LKL_ADAPTER_CONNECT_2,                           // 表示被动断开成功，当手环与手机在没有调用disconnect的条件下出现蓝牙断开返回。
    LKL_ADAPTER_CONNECT_3,                           // 表示重连失败，当手环与手机在没有调用connect的条件下出现蓝牙连接失败。
    LKL_ADAPTER_CONNECT_4,                           // 表示重连成功 , 当手环与手机在没有调用connect的条件下出现蓝牙连接成功
    LKL_ADAPTER_CONNECT_5,                           // 表示超时，调用connect超时返回
    LKL_ADAPTER_CONNECT_6,                           // 表示连接失败时
    
};

#import <Foundation/Foundation.h>
#import "LAKALAHeader.h"

@class LAKALARecordParams,LAKALABleDeviceInfo;

typedef void(^BluetoothConnecteBlock)(NSInteger status);//1 成功 0失败

@interface LAKALABraceletManager : NSObject

+(instancetype)sharedInstance;

@property(nonatomic,strong)BluetoothConnecteBlock bluetoothConnecteBlock;

//自动连接
-(void)automaticConnection;

//是否连接手环
- (BOOL)isConnected;

//获取设备类型信息
- (LKLBraceletType)getDeviceType;

//获取设备信息
- (LAKALABleDeviceInfo*)getDeviceInfo;

//获取运动信息
- (LAKALARecordParams*)getRecordParams;

/**
 * 获取心率
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


//获取蓝牙设备
- (NSDictionary*)bluetoothDevicesPER;
- (NSDictionary*)bluetoothDevices;

//连接蓝牙 超时timeout
- (void)doScanBluetoothDevices:(NSTimeInterval)timeout;

//连接手环
- (void)onInitDevice;
/**
 *MT100设备连接状态响应
 * state 0表示主动断开成功，1表示链接成功，2，表示被动断开成功，3表示重连失败，4表示重连成功 ,5表示超时 ，6表示连接失败
 */
- (void)onInitDeviceWithBluetoothConnecteBlock:(BluetoothConnecteBlock)bluetoothConnecteBlock;

//断开手环
- (void)onDeleteDevice;

//同步个人信息
- (void)synchronizationInformation;


@end

@interface LAKALARecordParams : NSObject

//＝＝＝＝＝＝＝＝＝＝＝个人信息＝＝＝＝＝＝＝＝＝＝＝
/**
 *  tag DF01
 *  个人身高，单位厘米(cm)，范围0-255
 */
@property (nonatomic, assign) int height;
/**
 *  tag DF02
 *  个人体重，单位千克(kg)；范围0-255
 */
@property (nonatomic, assign) int weight;
/**
 *  tag DF03
 *  个人性别 0女 / 1男
 */
@property (nonatomic, assign) int sex;
/**
 *  tag DF04
 *  个人性别 0女 / 1男
 */
@property (nonatomic, assign) int age;

//＝＝＝＝＝＝＝＝＝＝＝运动信息＝＝＝＝＝＝＝＝＝＝＝
/**
 *  步行歩长，单位米(m)
 */
@property (nonatomic, assign) int walkStepLenght;
/**
 *  跑步步长，单位米(m)
 */
@property (nonatomic, assign) int runStepLenght;

/**
 *  运动步长，单位米(m)
 */
@property (nonatomic, assign) int sportStepLenght;


/**
 *  步行时间，单位分(min)
 */
@property (nonatomic, assign) int walkStepTime;
/**
 *  跑步时间，单位分(min)
 */
@property (nonatomic, assign) int runStepTime;
/**
 *  运动总时间，单位分(min)
 */
@property (nonatomic, assign) int sportTime;



/**
 *  步行歩数，单位步(b)
 */
@property (nonatomic, assign) int walkStepNum;
/**
 *  跑步歩数，单位步(b)
 */
@property (nonatomic, assign) int runStepNum;
/**
 *  运动歩数，单位步(b)
 */
@property (nonatomic, assign) int sportStepNum;

/**
 *  运动总消耗卡路里，单位卡(k)
 */
@property (nonatomic, assign) double sportCalories;
@property (nonatomic, assign) int heartNum;


//＝＝＝＝＝＝＝＝＝＝＝睡眠信息＝＝＝＝＝＝＝＝＝＝＝
/**
 *  tag DF16
 *  清醒时间，单位分(mins)
 */
@property (nonatomic, assign) int awakeTime;
/**
 *  tag DF17
 *  潜意识时间，单位分(mins)
 */
@property (nonatomic, assign) int subconsciousMindTime;
/**
 *  tag DF18
 *  浅睡时间，单位分(mins)
 */
@property (nonatomic, assign) int latentSleepTime;
/**
 *  tag DF19
 *  深睡时间，单位分(mins)
 */
@property (nonatomic, assign) int deepSleepTime;



@end


/*!
 蓝牙设备对象（bleDevice）
 */
@interface LAKALABleDeviceInfo : NSObject

/**
 * 当前连接的手环类型
 */
@property(nonatomic,assign)LKLBraceletType braceletType;

/**
 * 设备别名，可以由用户设置，设置后替代deviceName显示于界面
 */
@property (nonatomic, copy) NSString* nickName;
/**
 * 设备名称，只读
 */
@property (nonatomic, copy) NSString *deviceName;
/**
 * 设备唯一性标示，只读
 */
@property (nonatomic, copy) NSString *uuid;
/**
 * 当前电量，只读
 */
@property (nonatomic,assign) int powerLevel;
/**
 * 厂商设备类型，只读
 */
@property (nonatomic,assign) NLProductID type;
/**
 * 设备物理地址，只读
 */
@property (nonatomic, copy) NSString *macAddress;

/*
 * 获得当前安全设备固件版本，只读
 */
@property (nonatomic, copy) NSString *firmwareVersion;
/*
 * 获得设备应用版本号，只读
 */
@property (nonatomic, copy) NSString *appVer;


@end

