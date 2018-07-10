//
//  JPUSHManage.h
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
//极光推送
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *appKey = @"a0284a0de528fb9c2b295e85";
static NSString *channel = @"Publish channel";
static BOOL isProduction = NO;

@interface JPUSHManage : NSObject<JPUSHRegisterDelegate,UIAlertViewDelegate>

singleton_for_header(JPUSHManage)

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

-(void)configNotificationMessage:(NSString *)messageString;

@end
