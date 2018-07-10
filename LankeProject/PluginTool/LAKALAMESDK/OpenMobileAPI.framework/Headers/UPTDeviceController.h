//
//  UNPayDeviceController.h
//  OpenMobileAPI
//
//  Created by shen on 16/6/15.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMISEService.h"
#import <MESDK/NLICCardModule.h>
#import <TSMKit/TSMInterface.h>
#import "Channel.h"
/*!
 @class
 @abstract 银联可穿戴设备支付核心驱动
 @discussion 驱动主要封装了OpenMobile api体系，以及功能api。本驱动依赖于MESDK驱动的基础功能，如蓝牙设备的扫描、连接、断开，以及IC指令透传通信。
 */
@interface UPTDeviceController : NSObject<UPTBluetoothDelegate>

/*!
 @method
 @abstract 获取实例对象
 @discussion 不要自己实例化该驱动对象，直接从这个方法获取实例对象。该实例对象是线程安全的。
 @result 返回实例对象
 */
+ (id)sharedInstance;

@end
