//
//  AppDelegate.h
//  DDXGProject
//
//  Created by itman on 16/1/21.
//  Copyright (c) 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "AdvertisingTopView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)TabBarViewController *tabBar;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, strong) AdvertisingTopView*topView;
-(void)creatTabBarController;

+ (AppDelegate *)appDelegate;

@end


