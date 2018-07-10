//
//  DQAlertSheetController.h
//  MHProject
//
//  Created by 董駸 on 16/1/6.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DQAlertSheetController;

typedef void(^DQAlertViewBlock)(DQAlertSheetController * alertSheet,NSInteger buttonIndex);
typedef void(^DQShowAlertBlock)();
typedef void(^DQDismissAlertBlock)();
typedef void(^DQCancelBlock)();

@interface DQAlertSheetController : NSObject <UIActionSheetDelegate>

@property (strong,nonatomic) UIAlertController *sheet;
@property (strong,nonatomic) UIActionSheet *oldSheet;

@property (strong, nonatomic) NSString *title; // 标题
@property (strong, nonatomic) NSString *message; // 内容
@property (strong, nonatomic) NSString *cancelButton; // 取消按钮
@property (strong, nonatomic) NSArray *buttons; // 选项按钮
//@property (readonly, nonatomic) NSMutableArray *buttonsStyle;

@property (copy, nonatomic) DQAlertViewBlock clickBlock; // 点击block
@property (copy, nonatomic) DQShowAlertBlock showBlock; // 出现block
@property (copy, nonatomic) DQDismissAlertBlock dismissBlock; // 消失block
@property (copy, nonatomic) DQCancelBlock cancelBlock; // 取消block

/**
 *  初始化sheet 无取消按钮
 *
 *  @param title        标题
 *  @param message      内容
 *  @param buttonTitles 选项按钮
 *  @param block        回调block
 *
 *  @return <#return value description#>
 */
-(id)initWithTitle:(NSString*)title
           message:(NSString*)message
           buttons:(NSArray*)buttonTitles
      afterDismiss:(DQAlertViewBlock)block;

/**
 *  初始化sheet 有取消按钮
 *
 *  @param title        标题
 *  @param message      内容
 *  @param buttonTitles 选项按钮
 *  @param cancelButton 取消按钮
 *  @param block        回调block
 *  @param cancelBlock  取消block
 *
 *  @return <#return value description#>
 */
-(id)initWithTitle:(NSString*)title
           message:(NSString*)message
           buttons:(NSArray*)buttonTitles
      cancelButton:(NSString *)cancelButton
      afterDismiss:(DQAlertViewBlock)block
            cancel:(DQCancelBlock)cancelBlock;

/**
 *  sheet 出现
 *
 *  @param viewController 出现控制器
 */
- (void)showSheet:(UIViewController *)viewController;

/**
 *  sheet消失
 *
 *  @param viewController 消失控制器
 */
- (void)dismiss:(UIViewController *)viewController;

/**
 *  sheet 出现
 *
 *  @param viewController 出现控制器
 *  @param showBlock      出现完成block
 */
- (void)showSheet:(UIViewController *)viewController completion:(DQShowAlertBlock)showBlock;

/**
 *  sheet 消失
 *
 *  @param viewController 消失控制器
 *  @param dismissBlock   消失完成block
 */
- (void)dismiss:(UIViewController *)viewController completion:(DQDismissAlertBlock)dismissBlock;

@end
