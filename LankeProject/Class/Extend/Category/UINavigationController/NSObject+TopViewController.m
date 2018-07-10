//
//  NSObject+TopViewController.m
//  LankeProject
//
//  Created by itman on 17/2/22.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "NSObject+TopViewController.h"

@implementation NSObject (TopViewController)

-(void)setTopViewController:(UIViewController *)topViewController
{
    self.topViewController= [self topViewController];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
