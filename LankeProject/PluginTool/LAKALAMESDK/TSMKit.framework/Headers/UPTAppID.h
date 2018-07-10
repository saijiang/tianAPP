//
//  AppID.h
//  TSMKit
//
//  Created by chenlei on 16/6/6.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTAppID : NSObject

@property (nonatomic, strong) NSString* appAid;
@property (nonatomic, strong) NSString* appVersion;

- (instancetype)initWithAppAid:(NSString*)appAid appVersion:(NSString*)appVersion;

@end
