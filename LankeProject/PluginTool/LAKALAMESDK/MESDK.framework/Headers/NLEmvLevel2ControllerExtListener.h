//
//  NLEmvLevel2ControllerExtListener.h
//  MTypeSDK
//
//  Created by wanglx on 15/1/5.
//  Copyright (c) 2015年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLEmvControllerListener.h"
#import "NLEmvCardholderCertType.h"
@protocol NLEmvLevel2ControllerExtListener<NLEmvControllerListener>
/**
 * 是否拦截acctType select事件
 * @return
 */
-(BOOL)isAccountTypeSelectInterceptor;

/**
 * 是否拦截持卡人证件确认事件
 * @return
 */
-(BOOL)isCardHolderCertConfirmInterceptor;

/**
 * 是否拦截电子现金确认事件
 * @return
 */
-(BOOL)isEcSwitchInterceptor;

/**
 * 是否拦截使用外部的序列号处理器
 * @return
 */
-(BOOL)isTransferSequenceGenerateInterceptor;

/**
 * 是否拦截消息显示事件
 * @return
 */
-(BOOL)isLCDMsgInterceptor;

/**
 * 账号类型选择<p>
 * 返回int范围<p><ol>
 * <li> default </li>
 * <li> savings </li>
 * <li>Cheque/debit </li>
 * <li>Credit</li>
 * </ol>
 * @return
 * 		1-4：选择范围，
 * 		－1：失败
 */
-(int)accTypeSelect;

/**
 * 持卡人证件确认<p>
 *
 * @return
 * 		YES:确认正确，
 * 		NO:确认失败
 */
-(BOOL)cardHolderCertConfirm:(NLEmvCardholderCertType)certType certNo:(NSString *)certno;

/**
 * 电子现金/emv选择<p>
 * 交易返回：<p><ul>
 * <li>1：继续电子现金交易</li>
 * <li>0：不进行电子现金交易</li>
 * <li>－1:用户中止</li>
 * <li>－3:超时</li>
 * </ul>
 */
-(int)ecSwitch;

/**
 * 流水号加1并返回
 * @return
 */
-(int)incTsc;


/**
 * 显示信息
 * @param title 标题
 * @param msg 消息
 * @param yesnoShowed 是否出现yesno
 * @param waittingTime 等待时间
 * @return
 * 		如果yesnoShow == true, 返回1 表示确认，返回0表示取消
 *      如果yesnoShow == false, 返回值无意义
 */
-(int)lcdTitle:(NSString *)title msg:(NSString *)msg isShow:(BOOL)yesnoShowed waittingTime:(int) waittingTime;
@end
