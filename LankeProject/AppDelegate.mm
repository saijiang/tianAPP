//
//  AppDelegate.h
//  DDXGProject
//
//  Created by itman on 16/1/21.
//  Copyright (c) 2016年 张涛. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideView.h"
#import "IQKeyboardManager.h"
#import "BaiduMapHeader.h"
//#import <KSCrash/KSCrashInstallationStandard.h>
#import "LaunchViewController.h"
#import "ProvinceRegionManager.h"
#import "WXApiManager.h"
#import "AlipayManager.h"
#import "AdvertisingTopView.h"
#import "CitiesDataTool.h"

@interface AppDelegate ()
@property (strong, nonatomic) BMKMapManager *mapManager;
@property (nonatomic ,strong) LaunchViewController * launchViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    //FuPALzq8NX66LUslXg1PBpPuX3ZjCreG 测试
    //4c1yLHx6B55vIk507p1lh4qfSSmNjEhU 航天
    BOOL ret = [_mapManager start:@"4c1yLHx6B55vIk507p1lh4qfSSmNjEhU"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //运营数据埋点
    [JKUBS configureDataWithPlistFile:@"JKUBSConfig"];
    
    //防止键盘盖着输入框
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // 实时监听网络状态
    [[ReachabilityManager sharedReachabilityManager] startRealTimeNetworkStatus];
    //友盟
    [[UMManager sharedUMManager] loadTheConfiguration];
    
    //极光
    [[JPUSHManage sharedJPUSHManage] application:application didFinishLaunchingWithOptions:launchOptions];
    //手环
    [[LAKALABraceletManager sharedInstance] automaticConnection];
    // 构造window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // 显示window主窗口
    [self.window makeKeyAndVisible];
    
    self.launchViewController = [[LaunchViewController alloc] init];
    self.window.rootViewController = self.launchViewController;
    
    //[self creatTabBarController];
    //[self blueMobiWatermark];
    //[self showGuideHUD];
    
//    KSCrashInstallationStandard* installation = [KSCrashInstallationStandard sharedInstance];
//    installation.url = [NSURL URLWithString:@"https://collector.bughd.com/kscrash?key=e926dc423096261dcd70eb86d6181485"];
//    [installation install];
//    [installation sendAllReportsWithCompletion:nil];
    KAPPDELEGATE.isFirst=NO;
    [ProvinceRegionManager sharedRegionManager];
    
    return YES;
}
#pragma mark - 创建tabbarcontroller
- (void)creatTabBarController
{
    
    self.isFirst=YES;
    self.tabBar = [[TabBarViewController alloc]init];
    self.window.rootViewController = self.tabBar;
   
}

#pragma mark -
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - 显示引导页
- (void)showGuideHUD
{
    // 引导页
    if (![DEF_PERSISTENT_GET_OBJECT(@"showGuide") boolValue])
    {
        DEF_PERSISTENT_SET_OBJECT([NSNumber numberWithBool:YES], @"showGuide");
        GuideView *guide = [[GuideView alloc] initWithFrame:self.window.bounds];
        [self.window addSubview:guide];
    }
}

#pragma mark - 水印
- (void)blueMobiWatermark
{
    // 添加水印
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueMobiWatermark"]];
    iv.frame        = CGRectMake(0,0, DEF_WIDTH(self.window), 12);
    [self.window addSubview:iv];
    [self.window bringSubviewToFront:iv];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //app每次启动的时候
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [[CitiesDataTool sharedManager] requestGetData];

        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新， 
        }); 
        
    });

}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    [self handleOpenFromUrl:url];
    return YES;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self handleOpenFromUrl:url];
    return YES;
}

-(void)handleOpenFromUrl:(NSURL*)url
{
    DEF_DEBUG(@"%@",url);
    //如果是支付宝钱包的话就走这里了
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipayManager sharedManager] processOrderWithPaymentResult:url];
       
    }
    
    else if ([url.description hasPrefix:@"wx"])
    {
        //你的处理逻辑
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else
    {
         [UMSocialSnsService handleOpenURL:url];
    }

}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DEF_DEBUG(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DEF_DEBUG(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

//iOS6及以下系统，收到通知
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [[JPUSHManage sharedJPUSHManage] configNotificationMessage:userInfo[@"aps"][@"alert"]];

}
//iOS7及以上系统，收到通知
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    [[JPUSHManage sharedJPUSHManage] configNotificationMessage:userInfo[@"aps"][@"alert"]];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


@end
