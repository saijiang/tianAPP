//
//  AppDetail.h
//  TSMKit
//
//  Created by chenlei on 16/6/12.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPTAppListRequestParams.h"

@interface UPTAppDetail : NSObject

@property (nonatomic, strong) NSString* appId;
@property (nonatomic, strong) NSString* appName;
@property (nonatomic, strong) NSString* appIcon;
@property (nonatomic, strong) NSString* appDesc;
@property (nonatomic, strong) NSString* appProviderName;
@property (nonatomic, strong) NSString* mPanId;
@property (nonatomic, strong) NSString* mPan;
@property (nonatomic, strong) NSString* lastFour;
@property (nonatomic, strong) NSString* cardType;
@property (nonatomic, assign) UPTAppStatus APPStatus;

@end
