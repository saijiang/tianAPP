//
//  AppApplyRequestParams.h
//  TSMKit
//
//  Created by chenlei on 16/6/6.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTAppApplyRequestParams : NSObject

@property (nonatomic, strong) NSDictionary* params;

- (instancetype)initWithParams:(NSDictionary *)params;

@end
