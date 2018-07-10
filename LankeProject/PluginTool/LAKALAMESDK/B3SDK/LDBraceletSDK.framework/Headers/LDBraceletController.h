//
//  LDBraceletController.h
//  LDBraceletSDK
//
//  Created by houhm on 16/11/23.
//  Copyright © 2016年 houhm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDBraceletBLEDeviceOperator.h"
#import "LDBraceletDeviceDelegate.h"
#import "LDBraceletFitOperator.h"
#import "LDBraceletEMVOperator.h"
#import "LDBraceletOutType.h"
#import "LDBraceletEMVController.h"

@interface LDBraceletController : NSObject<LDBraceletBLEDeviceOperator,LDBraceletEMVOperator,LDBraceletFitOperator>
@property(nonatomic,strong)LDBraceletEMVController *emvController;
@property(nonatomic,weak)id<LDBraceletDeviceDelegate> deviceDelegate;
@property(nonatomic,strong)DeviceInfo *deviceInfo;
+ (instancetype)shareInstance;


@end
