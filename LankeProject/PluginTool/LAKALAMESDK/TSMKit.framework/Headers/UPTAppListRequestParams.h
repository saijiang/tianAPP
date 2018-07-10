//
//  AppListRequestParams.h
//  TSMKit
//
//  Created by chenlei on 16/6/6.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UPTAppStatusDownloadAndActive = 1 << 0,
    UPTAppStatusDownloadAndInActive = 1 << 1,
    UPTAppStatusUnDownloadAndActive = 1 << 2,
    UPTAppStatusUnDownloadAndInActive = 1 << 3
}UPTAppStatus;

@interface UPTAppListRequestParams : NSObject

@property (nonatomic, assign) UPTAppStatus appStatus;


- (instancetype)initWithAppStatus:(UPTAppStatus )appStatus;

@end
