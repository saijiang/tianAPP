//
//  ReachabilityManager.h
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

singleton_for_header(ReachabilityManager)
// 网络状态实时监听
@property (strong, nonatomic) Reachability *reachability;

- (void)startRealTimeNetworkStatus;

@end
