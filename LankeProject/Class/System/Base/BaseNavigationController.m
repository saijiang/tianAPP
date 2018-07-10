//
//  BaseNavigationController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0 ) {
        
        UIImage *image = [[UIImage imageNamed:@"navBar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = item;
        
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    // 统一设置优先级低于 控制器类中的自定义设置 super放后面
    [super pushViewController:viewController animated:animated];
}




- (void)back {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BaseViewController *controller= (BaseViewController *)self.topViewController;
        if (controller&&[controller respondsToSelector:@selector(baseRightBtnAction:)])
        {
            [controller baseBackBtnAction:nil];
        }
        else
        {
            [self popViewControllerAnimated:YES];

        }
    });
}


@end
