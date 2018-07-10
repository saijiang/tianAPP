//
//  BaseViewController.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "LKUserAccessManager.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BaseViewController : UIViewController
{

    UIButton * _rightButton;
}

@property (nonatomic ,strong) UIButton * rightButton;

/**
 *  内容视图，所有的view都加载contentView上，而不再是self.view上
 */
@property (nonatomic, strong) BaseScrollView *contentView;

- (void) createUI;
/**
 *  添加子视图，以后所有添加子视图的操作,
 *  都使用[self addSubview:...];
 *  而不再用[self.view addSubview:...]
 *
 *  @param view 子视图
 */
- (void)addSubview:(UIView *)view;


/**
 *  控制旋转状态，默认不旋转
 *  YES 旋转
 *  NO 不旋转
 */
@property (nonatomic, assign) BOOL isNeedRotate;


#pragma mark - 显示系统自带的导航栏
/**
 *  显示系统自带的导航栏
 *
 *  @param title 标题
 */
- (void)showNavBarCustomByTitle:(NSString *)title;

/**
 *  显示系统自带的导航栏
 *
 *  @param view 自定义的view
 */
- (void)showNavBarCustomByView:(UIView *)view;

/**
 *  自定义导航栏view
 *  结合 [self showNavBarCustomByView:view]; 使用
 *
 *  @param navTitle     标题
 *  @param rightTitle   右侧按钮文字或图片
 *  @param isBack       YES为显示返回按钮，NO为不显示
 */
- (UIView *)viewWithNavBarByTitle:(NSString *)navTitle
                       rightTitle:(NSString *)rightTitle
                           isBack:(BOOL)isBack;


// 单独设置导航栏的返回按钮
- (void)showBackBtnHUD;

// 返回按钮默认方法，根据需求，可自行重写
- (void)baseBackBtnAction:(UIButton *)btn;

// 右侧按钮默认方法，根据需求，可自行重写
- (void)baseRightBtnAction:(UIButton *)btn;


// 添加右侧文字按钮
- (void)showRightBarButtonItemHUDByName:(NSString *)name;

// 添加右侧图片按钮
- (void)showRightBarButtonItemHUDByImage:(UIImage *)image;
- (void)showRightBarButtonNormalImage:(UIImage *)normalImage
                          selectImage:(UIImage *)selectImage;
// 添加右侧图片按钮
- (void)showRightBarButtonItemHUDByImageArray:(NSArray *)imageArray;


/**
 *  界面push前后如果需要隐藏下方的tabbar，则分别在push的前后调用下面方法
 *
 *  [self hideTabbarAndScreenPush];
 *  UIViewController *vc = [[UIViewController alloc] init];
 *  [self.navigationController pushViewController:vc animated:YES];
 *  [self showTabbarAndScreenPush];
 */
- (void)hideTabbarAndScreenPush;
- (void)showTabbarAndScreenPush;

/** 将当前控制器从导航控制器堆栈中移除 */
- (void)removeSelfFromNavigationStack;
- (void)showTipByMessage:(NSString *)message;
- (void) showTipMessage:(NSString *)message cancel:(void(^)())cancel handle:(void(^)())handle;
#pragma mark - 界面push之后，添加界面的手势侧滑Pop效果
/**
 *  界面push之后，添加界面的手势侧滑Pop效果
 *  在需要的界面里调用此方法
 */
- (void)addPopGesture;

// 移除pop手势
- (void)removePopGesture;

/** 设置当前控制器的导航栏隐藏，默认返回NO(不隐藏) */
- (BOOL)hidenNavigationBar;

@end

@interface UIViewController (StringForController)

+ (UIViewController *) controllerWithString:(NSString *)string;

@end

@interface BaseViewController (CartDot)

- (void) fetchCartCount;
- (void) showCartDotWithCount:(NSInteger)count;

@end

