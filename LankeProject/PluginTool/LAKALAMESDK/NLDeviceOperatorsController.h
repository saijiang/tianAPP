//
//  NLDeviceOperatorsController.h
//  MTypeSDK
//
//  Created by su on 15/7/6.
//  Copyright © 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MESDK/NLPersonalParams.h>
#import <MESDK/NLStepLenght.h>

@interface NLDeviceOperatorsController : NSObject
@property (nonatomic, assign) id delegate;
@property (atomic, assign) BOOL isProcessing;
- (BOOL)isConnected;
- (BOOL)isDeviceTypeAudio;
- (BOOL)isDeviceTypeBluetooth;
- (NSDictionary*)bluetoothDevices;
- (NSDictionary*)bluetoothDevicesPER;
- (void)doScanBluetoothDevices:(NSTimeInterval)timeout;
- (void)doInitBluetoothDeviceWithUUID:(NSString*)name;
- (void)doInitBluetoothDeviceWithPer:(NSString*)name;
- (void)doInitAudioDevice;
- (void)doDeleteDevice;

#pragma mark -获取设备信息
- (NSDictionary*)getDeviceInfo;

#pragma mark -
- (void)processingLock;
- (void)processingUnLock;
@end

@protocol NLDeviceOperatorsControllerDelegate <NSObject>
- (void)onShowMessage:(NSString*)msg;
- (void)onScanDeviceCompleted:(NSDictionary*)devices;
-(void)onUpdateOTAProgress:(float)progress err:(NSError *)err;
-(void)showProcess;
-(void)hideProcess;
@end
