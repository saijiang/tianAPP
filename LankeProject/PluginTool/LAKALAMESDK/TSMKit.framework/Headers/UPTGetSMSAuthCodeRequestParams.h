//
//  GetSMSAuthCodeRequestParams.h
//  TSMKit
//
//  Created by chenlei on 16/6/6.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>
# import"UPTAppID.h"

@interface UPTGetSMSAuthCodeRequestParams : NSObject

@property (nonatomic, strong) UPTAppID *appId;
@property (nonatomic, strong) NSString *mPanId;
@property (nonatomic, strong) NSString *sisdn;

- (instancetype)initWithAppId:(UPTAppID *)appId
                          mPanId:(NSString *)mPanId
                        sisdn:(NSString *)sisdn;

@end
