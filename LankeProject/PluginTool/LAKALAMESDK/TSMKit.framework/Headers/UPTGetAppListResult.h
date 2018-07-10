//
//  GetAppListResult.h
//  TSMKit
//
//  Created by chenlei on 16/6/12.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPTAppDetail.h"

@interface UPTGetAppListResult : NSObject

@property (nonatomic, readonly, copy) NSArray<UPTAppDetail *> *appList;
- (instancetype)initWithAppList:(NSArray<UPTAppDetail *>*)appList;

@end
