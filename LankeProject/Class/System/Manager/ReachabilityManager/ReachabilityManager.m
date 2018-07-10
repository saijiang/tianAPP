//
//  ReachabilityManager.m
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

singleton_for_class(ReachabilityManager)


#pragma mark - 实时监听网络状态

- (void)startRealTimeNetworkStatus
{
    // 开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification* )note
{
    Reachability *curReach  = [note object];
    NetworkStatus status    = [curReach currentReachabilityStatus];
    
    DEF_DEBUG(@"网络状态值: %ld", (long)status);
    // 根据网络状态值，在这里做你想做的事
    // ...
    if (status==NotReachable)
    {
        
    }
    
}

@end
