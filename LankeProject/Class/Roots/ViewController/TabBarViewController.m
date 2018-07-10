//
//  TabBarViewController.m
//  LankeProject
//
//  Created by itman on 16/12/7.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "TabBarViewController.h"

//首页
#import "HomepageViewController.h"
//全部
#import "AllFunctionViewController.h"
//我的
#import "PersonalcenterViewController.h"
#import "BaseNavigationController.h"


#import "SettingViewController.h"
@interface TabBarViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) NSMutableArray *controllerInfo; // 创建tabbar相关信息

@property (strong ,nonatomic) UIView *selectView; // 自定义选中按钮

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = self;
    //设置选中颜色
    [self.tabBar setTintColor:[UIColor colorWithRed:0.52 green:0.71 blue:0.87 alpha:1]];
    //设置透明
    self.tabBar.opaque = YES;
    [self createTableControllers];
    
}

-(void)createTableControllers
{
    //添加controller数据
    NSMutableArray *info = [NSMutableArray array];
    [info addObject:[[NSDictionary alloc] initWithObjects:@[[UIImage imageNamed:@"item-icon-1"],[UIImage imageNamed:@"item-icon-5"],@"首页",[HomepageViewController new]] forKeys:@[@"icon",@"selectedicon",@"title",@"controller"]]];
    [info addObject:[[NSDictionary alloc] initWithObjects:@[[UIImage imageNamed:@"item-icon-2"],[UIImage imageNamed:@"item-icon-6"],@"全部",[AllFunctionViewController new]] forKeys:@[@"icon",@"selectedicon",@"title",@"controller"]]];
    [info addObject:[[NSDictionary alloc] initWithObjects:@[[UIImage imageNamed:@"item-icon-3"],[UIImage imageNamed:@"item-icon-7"],@"个人中心",[PersonalcenterViewController new]] forKeys:@[@"icon",@"selectedicon",@"title",@"controller"]]];
    [info addObject:[[NSDictionary alloc] initWithObjects:@[[UIImage imageNamed:@"item-icon-4"],[UIImage imageNamed:@"item-icon-8"],@"设置",[SettingViewController new]] forKeys:@[@"icon",@"selectedicon",@"title",@"controller"]]];
    
    [self setControllerInfo:info];
    
}



- (void)setControllerInfo:(NSMutableArray *)controllerInfo
{

    NSMutableArray *controllerArray = [NSMutableArray array];
    
    for (int i = 0; i < controllerInfo.count; i++)
    {
        BaseNavigationController *navController = [[BaseNavigationController alloc]initWithRootViewController:[[controllerInfo objectAtIndex:i] objectForKey:@"controller"]];
        //设置title
        [navController.tabBarItem setTitle:[[controllerInfo objectAtIndex:i] objectForKey:@"title"]];
        NSDictionary *normaldict = @{NSForegroundColorAttributeName:[UIColor grayColor]};
        NSDictionary *selecteddict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.4 green:0.69 blue:0.85 alpha:1],NSForegroundColorAttributeName, nil];
        
        [navController.tabBarItem setTitleTextAttributes:normaldict forState:UIControlStateNormal];
        [navController.tabBarItem setTitleTextAttributes:selecteddict forState:UIControlStateSelected];
        //设置图标Z
        UIImage *selectedImage=[[controllerInfo objectAtIndex:i] objectForKey:@"selectedicon"];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image=[[controllerInfo objectAtIndex:i] objectForKey:@"icon"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navController.tabBarItem.image=image;
        navController.tabBarItem.selectedImage=selectedImage;
        //设置导航的标题颜色和字体大小
        [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        
        [controllerArray addObject:navController];
        
        
    }
    self.viewControllers = controllerArray;

}
//
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//
//    BaseNavigationController * nav = (BaseNavigationController *)viewController;
//    BOOL isSetting = [nav.topViewController isKindOfClass:[SettingViewController class]];
//    if (isSetting) {
//        
//        [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
//    }
//    return !isSetting;
//}

@end
