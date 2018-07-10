//
//  LDBraceletBLEOperator.h
//  LDBraceletSDK
//
//  Created by houhm on 16/11/24.
//  Copyright © 2016年 houhm. All rights reserved.
//


#ifndef LDBraceletBLEDeviceOperator_h
#define LDBraceletBLEDeviceOperator_h
#import "CommonClass.h"

@class DeviceBaseInfo;
@class DeviceInfo;
@class LklPersonalParams;

@protocol LDBraceletBLEDeviceOperator

- (NSString *)sdkVersion;

- (void)searchDevWithTime:(NSInteger)timer
    foundOneDeviceHandler:(void(^)(DeviceBaseInfo *deviceInfo))foundOneDeviceHandler
          completeHandler:(void(^)(NSArray *allDevices))completeHandler;

- (void)stopSearchDev;

- (void)connectDevUUID:(NSString *)UUID ;

- (BOOL)isConnect;

- (BOOL)initUPT;

- (void)disConnectDev;

- (DeviceInfo *)deviceInfo;

- (void)findBracelet:(NSString *)data;

- (void)setDeviceSysTime:(NSDate *)date;

- (NSDate *)deviceSysTime;

- (NSData *)powerOnSlot:(NSInteger)slot cardType:(NSInteger)cardType;

- (void)powerOffSlot:(NSInteger)slot cardType:(NSInteger)cardType;

- (NSData*)callWithSlot:(ICCardSlot)slot req:(NSData*)req;

- (void)setSysSuspendTime:(NSInteger)suspendTime dormantTime:(NSInteger)dormantTime shutdownTime:(NSInteger)shutdownTime;

- (void)restoreFactory:(NSArray *)types;

- (int)batteryPower;

- (BOOL)bindDevice:(NSData *)data;

- (void)updateFirmware:(NSString *)path progressBlock:(void(^)(float progress))progressBlock successBlock:(void(^)()) successBlock failedeBlock:(void(^)(int failCode,NSString *failInfo))failedBlock;

-(void)changeBTName:(NSString *)name;

- (BOOL)writeProfileWith:(NSString *)fileName
             inputStream:(NSInputStream*)input
                fileType:(FileType )fileType
           progressBlock:(void(^)(float progress))progressBlock
            successBlock:(void(^)()) successBlock
            failedeBlock:(void(^)(int failCode,NSString *failInfo))failedBlock;

-(NSData *)readFileOrRecord:(FileType)fileType fileName:(NSData *)fileName;

- (NSData*)writeSEL78:(NSData*)data;

- (NSData*)readSEL78:(NSData*)data length:(int)len;

- (BOOL)isAncsExist;

- (BOOL)openAncs;

@end

#endif /* asd_h */
