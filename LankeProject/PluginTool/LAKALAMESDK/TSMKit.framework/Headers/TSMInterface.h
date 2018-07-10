//
//  TSMInterface.h
//  TSMKit
//
//  Created by TangZhixiong on 16/6/6.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPTCheckBinRequestParams.h"
#import "UPTAppApplyRequestParams.h"
#import "UPTAppDownloadRequestParams.h"
#import "UPTGetSMSAuthCodeRequestParams.h"
#import "UPTAppActiveRequestParams.h"
#import "UPTAppDeleteRequestParams.h"
#import "UPTAppListRequestParams.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UPTChannelDelegate <NSObject>
- (NSInteger)channelID;
- (NSString*)slectResp;
- (NSData*)transmitWithCommand:(NSData *)command error:(NSError**)error;
@end

@protocol UPTBluetoothDelegate <NSObject>
- (NSInteger)establishWithError:(NSError **)error;
- (id <UPTChannelDelegate>)openLogicChannelWithCommand:(NSData*)command error:(NSError **)error;
- (NSInteger)closeLogicChannelWithChannelId:(NSInteger)channelId error:(NSError **)error;
- (NSString *)bleSEStatusWithError:(NSError **)error;
- (NSData *)btcInfoWithError:(NSError **)error;
- (NSData *)cplcInfoWithError:(NSError **)error;
@end

/**
 *  接口调用成功回调（回调的block会在主线程执行，不用做线程处理）
 *
 *  @param response
 */
typedef void(^__nullable TSMSuccessBlock)(id __nonnull response);


/**
 *  接口执行失败回调（回调的block会在主线程执行，不用做线程处理）
 *
 *  @param errorCode 错误diamante
 *  @param errorDesc 错误描述
 */
typedef void(^__nullable TSMFailureBlock)(NSString*__nonnull errorCode, NSString* __nonnull errorDesc);

/**
 *  调用接口时进度回调（回调的block会在主线程执行，不用做线程处理）
 *
 *  @param NSInteger 取值（1-100）代表接口进行到（1％－100%)
 */
typedef void(^__nullable TSMProgressBlock)(NSInteger);


@protocol TSMInterface <NSObject>

/**
 *  设置蓝牙代理 设置此代理让控件可以调用蓝牙模块
 *
 *  @param delegate
 */
- (void)setDelegate:(id<UPTBluetoothDelegate> __nullable)delegate;

/**
 *  初始化接口
 *  TSM Service Connect之后，首先需要调用初始化接口，只有初始化成功后才可以继续调用其他接口，初始化接口只需要做一次。如果Service disconnect之后需要重新调初始化接口。初始化回调的succBlock里面会通知初始化结果，如果有升级信息，会包含在回调的NSDictionary*里面。
 *
 *  @param succBlock
 *  @param failBlock
 */
- (void)establishWithSuccBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

/**
 *  checkBin接口
 *  用户在应用申请之前对用户输入的实体卡Bin进行校验，检测发卡行是否支持空中发卡模式或者当前手环是否支持持卡人所在发卡行
 *
 *  @param param
 *  @param succBlock
 *  @param failBlock
 */
- (void)checkBinWithParam:(UPTCheckBinRequestParams *__nullable)param succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

/**
 *  应用申请接口
 *  应用申请接口在checkBin通过之后才能调用。个人信息填写需要调用银联APP，信息填写好以后再跳转回第三方APP，由第三方APP调用应用申请接口
 *
 *  @param param
 *  @param succBlock
 *  @param failBlock
 */
- (void)appApplyWithParam:(UPTAppApplyRequestParams * __nullable)param
                succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

/**
 *  应用下载接口
 *  下载指定应用，在发起下载请求之前，应已通过银联APP进行应用申请操作，并在第三方APP回调通知申请成功之后才能发起（不需要确认审核结果，申请成功即代表审核成功，可直接发起下载）
 *
 *  @param param
 *  @param succBlock
 *  @param failBlock
 */
- (void)appDownloadWithParam:(UPTAppDownloadRequestParams * __nullable)param
                   succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock progressBlcok:(TSMProgressBlock)progressBlcok;


/**
 *  获取短信验证码接口
 *
 *  @param param
 *  @param succBlock
 *  @param failBlock
 */

-(void)getSMSAuthCodeWithParam:(UPTGetSMSAuthCodeRequestParams * __nullable)param succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

/**
 *  应用激活接口
 *  此接口应在获取卡片激活码之后调用，并可以根据业务需求，在卡片下载之前或者之后进行。
 *
 *  @param param
 *  @param succBlock
 *  @param failBlock
 */
- (void)appActiveWithParam:(UPTAppActiveRequestParams * __nullable)param
                 succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

/**
 *  应用删除接口 应该在应用申请成功之后调用
 *
 *  @param param
 *  @param succBlock
 *  @param failBlock
 *  @param progressBlcok
 */
- (void)appDeleteWithParam:(UPTAppDeleteRequestParams * __nullable)param
                 succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock progressBlcok:(TSMProgressBlock)progressBlcok;

/**
 *  获取已申请应用列表接口
 *  此接口也可根据状态获取应用列表，需要在请求参数中指明，若请求参数未设置，默认返回的应用列表是全量的
 *
 *  @param succBlock
 *  @param failBlock
 */
- (void)appListWithParam:(UPTAppListRequestParams *__nullable)param succBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

/**
 *  设置默认卡接口
 *
 *  @param appAId
 */
- (void)setDefaultCardWithAppAId:(NSString * __nullable)appAId;

/**
 *  获取默认卡
 *
 *  @param succBlock
 *  @param failBlock
 */
-(void)defaultCardWithSuccBlock:(TSMSuccessBlock)succBlock failBlock:(TSMFailureBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
