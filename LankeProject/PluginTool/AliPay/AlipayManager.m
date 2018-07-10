//
//  AlipayManger.m
//  LankeProject
//
//  Created by itman on 16/8/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AlipayManager.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayManager : NSObject

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static AlipayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayManager alloc] init];
    });
    return instance;
    
}
/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl        支付结果url
 *  @param completionBlock  支付结果回调
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
{
    [[AlipaySDK defaultService]
     processOrderWithPaymentResult:resultUrl
     standbyCallback:^(NSDictionary *resultDic)
     {
         if ([resultDic[@"resultStatus"] isEqualToString:@"9000"])
         {
             //[UnityLHClass showHUDWithStringAndTime:@"支付成功"];
             if (_delegate
                 && [_delegate respondsToSelector:@selector(managerDidRecvAliPayResponse:)])
             {
                 [_delegate managerDidRecvAliPayResponse:0];
             }
         }
         else
         {
             if (_delegate
                 && [_delegate respondsToSelector:@selector(managerDidRecvAliPayResponse:)])
             {
                 [_delegate managerDidRecvAliPayResponse:1];
             }
         }
         
     }];

}
#pragma mark----支付宝支付
+(void)payActionWithorderSn:(NSString *)orderSn
                     amount:(NSString *)amount
                  orderType:(NSString *)orderType
            completionBlock:(void(^)(int result))completionBlock
{
    [UserServices
     payInfoSettingWithOrderType:orderType
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [AlipayManager
             payActionWithorderSn:orderSn
             amount:amount
             notifyURL:responseObject[@"data"][@"apliyAddress"]
             completionBlock:^(int result)
             {
                 if (completionBlock)
                 {
                     completionBlock(result);

                 }
            }];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

#pragma mark----支付宝支付
+(void)payActionWithorderSn:(NSString *)orderSn
                     amount:(NSString *)amount
                  notifyURL:(NSString *)notifyURL
            completionBlock:(void(^)(int result))completionBlock
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*=======================需要填写商户app申请的===================================*/
    
    NSString *seller = ALIPAYseller;//支付宝账号
    NSString *partner = ALIPAYpartner;//合作者身份(PID)
    NSString *privateKey =ALIPAYkey;//私钥
    
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    

    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderSn; //订单ID（由商家自行制定）
    order.productName = @"商品购买"; //商品标题
    order.productDescription = @"商品购买"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[amount floatValue]]; //商品价格
    order.notifyURL = notifyURL; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = @"hangtianfuwu";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    DEF_DEBUG(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        //快捷支付开发包回调函数，返回免登、支付结果。本地未安装支付宝客户端，或未成功调用支付宝客户端进行支付的情况下（走H5收银台），会通过该completionBlock返回支付结果。相应的结果参考"客户端同步返回"。
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"])
            {
                [UnityLHClass showHUDWithStringAndTime:@"支付成功"];
                if (completionBlock)
                {
                    completionBlock(0);
                }
            }
            else
            {
//                [UnityLHClass showHUDWithStringAndTime:@"支付失败"];
                if (completionBlock)
                {
                    completionBlock(1);
                }
            }
            
        }];

    }

}

@end
