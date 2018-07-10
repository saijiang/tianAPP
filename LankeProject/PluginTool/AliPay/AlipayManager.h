//
//  AlipayManger.h
//  LankeProject
//
//  Created by itman on 16/8/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#define ALIPAYkey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMrhgpL4237Yo746kw49SdhdHmOSoH1sOmvJmKD+BnYQ1vwfSfbhoFxKlDNeDgzrvK2ks2u9rpaICnsTjo3RT8AZ1oG7C3phx6LEswHiL1ytq3mBR7rIe+EsFTGkNsV63jY+y/0fIDEruiMK8ftad0JLvU+wPoHwKAKdACTSBaidAgMBAAECgYBYejJ8sCThU89NNbROQHJE9o87M4XkTN/JhBiZFU9yC/QF7gtOrKVHuoqZQEp2XhRh0fMhaI6MPXX8qNHBjWfugoBlvpdZW1BO7fljeJ/d/YXGRo3ftkT2cYoSxL1Ue96bezzy/dPQtP1zgW3tlkI8XIngKawzP6uVyzzo6pBeIQJBAPlhk7GUc3MyMrq3QcgHvFdSPlAEc2T2u2BEB23UBNWQ89jXByoUdLVSD7i10IuVIFgSnA6m5Urbv4+L3GSvcfUCQQDQQ/yQuUhP54/sYvnP3xGxj05ycQmsek/vMUwwIgSuaQXeRbuhmF/Ljy+uHvnpAzJBbenHw4LHbzwfFZH6TKsJAkAig1ybYP4xXSskKCSUeG2acClrjZIi0PrRsdiNXKBmpi75PZkiO76DMZ43ZAI+rx7Q0ZKDfJmTKKJ0TVjtHlLZAkEAjNDrPI+KrTxMu/BQKJUTSZMz330+pTguQ/R5JzJZJ/Qq25cavrBgVSqDep/HKh3XJRZEM6WmD2LOq9XR1gNwwQJAMk+P9OL60EfJncK0PnUq02LMitIKrqR70VbyFRHm0dkmMr3EP7ToROpOwJqQAgZ142RdDt0ro2HPyHpl3nn0+Q=="//私钥

#define   ALIPAYseller  @"3252976275@qq.com";//支付宝账号
#define   ALIPAYpartner @"2088621534852875";//合作者身份(PID)


#import <Foundation/Foundation.h>

@protocol AlipayManagerDelegate <NSObject>

@optional

- (void)managerDidRecvAliPayResponse:(NSInteger)response;

@end


@interface AlipayManager : NSObject
@property (nonatomic, assign) id<AlipayManagerDelegate> delegate;

+ (instancetype)sharedManager;

/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl        支付结果url
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl;


/**
 *  <#Description#>
 *
 *  @param orderSn         订单ID
 *  @param amount          订单总额
 *  @param orderType       回调地址类型
 *  @param completionBlock <#completionBlock description#>
 */
+(void)payActionWithorderSn:(NSString *)orderSn
                     amount:(NSString *)amount
                  orderType:(NSString *)orderType
            completionBlock:(void(^)(int result))completionBlock;

/**
 *  <#Description#>
 *
 *  @param orderSn         订单ID
 *  @param amount          订单总额
 *  @param notifyURL       回调地址
 *  @param completionBlock <#completionBlock description#>
 */
+(void)payActionWithorderSn:(NSString *)orderSn
                     amount:(NSString *)amount
                  notifyURL:(NSString *)notifyURL
            completionBlock:(void(^)(int result))completionBlock;

@end
