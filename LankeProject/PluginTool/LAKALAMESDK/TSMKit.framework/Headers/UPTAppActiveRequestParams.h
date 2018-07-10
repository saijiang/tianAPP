//
//  AppActiveRequestParams.h
//  TSMKit
//
//  Created by chenlei on 16/6/6.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTAppActiveRequestParams : NSObject

@property (nonatomic, strong) NSString *mPanId;
@property (nonatomic, strong) NSString *activeCode;

- (instancetype)initWithMPanId:(NSString *)mPanId
                        activeCode:(NSString *)activeCode;

@end
