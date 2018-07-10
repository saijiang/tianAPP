//
//  DQAlertViewController.h
//  MHProject
//
//  Created by 董駸 on 16/1/6.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DQAlertViewBlock)(NSInteger buttonIndex);
typedef void(^DQShowAlertBlock)();
typedef void(^DQDismissAlertBlock)();

@interface DQAlertViewController : NSObject

@property (strong,nonatomic) UIAlertController *alert;

@property (strong, nonatomic) NSString *title; // 标题
@property (strong, nonatomic) NSString *message; // 内容
@property (strong, nonatomic) NSArray *buttons;  // 按钮数组
//@property (readonly, nonatomic) NSMutableArray *buttonsStyle;

@property (copy, nonatomic) DQAlertViewBlock clickBlock; // 点击按钮block
@property (copy, nonatomic) DQShowAlertBlock showBlock;  // 提示框出现block
@property (copy, nonatomic) DQDismissAlertBlock dismissBlock; // 提示框消失block

/**
 *  初始化方法
 *
 *  @param title        标题
 *  @param message      内容
 *  @param buttonTitles 按钮数组
 *  @param block        回调block
 *
 *  @return <#return value description#>
 */
-(id)initWithTitle:(NSString*)title
           message:(NSString*)message
           buttons:(NSArray*)buttonTitles
      afterDismiss:(DQAlertViewBlock)block;

/**
 *  alert出现
 *
 *  @param viewController 出现控制器
 */
- (void)showAlert:(UIViewController *)viewController;

/**
 *  alert消失
 *
 *  @param viewController 消失控制器
 */
- (void)dismiss:(UIViewController *)viewController;

/**
 *  alert出现
 *
 *  @param viewController 出现控制器
 *  @param block          出现完成block
 */
- (void)showAlert:(UIViewController *)viewController completion:(DQShowAlertBlock)block;

/**
 *  alert消失
 *
 *  @param viewController 消失控制器
 *  @param block          消失完成block
 */
- (void)dismiss:(UIViewController *)viewController completion:(DQDismissAlertBlock)block;

@end
