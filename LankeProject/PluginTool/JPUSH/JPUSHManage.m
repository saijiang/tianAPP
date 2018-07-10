//
//  JPUSHManage.m
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JPUSHManage.h"
#import "JPUSHService.h"
#import "MyNewsViewController.h"

@implementation JPUSHManage

singleton_for_class(JPUSHManage)


-(void)configNotificationMessage:(NSString *)messageString
{
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:messageString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alert show];
    }
    else{
        [self configGoToController];
    }
   
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self configGoToController];
    }
}

-(void)configGoToController
{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.topViewController isKindOfClass:[UIAlertController class]]) {
            [self configGoToController];
        }else{
            MyNewsViewController *message=[[MyNewsViewController alloc]init];
            UIViewController *currentView=self.topViewController;
            [currentView.navigationController pushViewController:message animated:YES];
        }
        
    });
   
}

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 极光推送
     
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID)
    {
        if(resCode == 0)
        {
            DEF_DEBUG(@"registrationID获取成功：%@",registrationID);
           
        }
        else
        {
            DEF_DEBUG(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService resetBadge];
    
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self configNotificationMessage:userInfo[@"aps"][@"alert"]];
    }

}



#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

//前台得到推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    DEF_DEBUG(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        [self configNotificationMessage:body];
        
    }
    else
    {
        // 判断为本地通知
        
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//后台得到推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    DEF_DEBUG(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        [self configNotificationMessage:body];
    }
    else
    {
        // 判断为本地通知　
        
    }
    completionHandler();  // 系统要求执行这个方法
}


#endif



@end
