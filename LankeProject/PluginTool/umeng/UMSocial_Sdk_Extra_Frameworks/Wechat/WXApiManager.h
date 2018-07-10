//
//  WXpay.h
//  DDXGProject
//
//  Created by itman on 16/3/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>

#define WXkey @"02489425836b493092bca450fac7b6c8"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)managerDidRecvPayResponse:(PayResp *)response;

@end


@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;



#pragma mark====微信支付

//参数名 	必选 	类型 	说明
//id 	是 	string 	订单号
//orderType 	否 	string 	订单类型：01、订座订单，02、外卖订单， 03、自营商城多个商家合并支付 ，04、1号店订单， 05、团购商品，06、自营商品我的订单页面进入

+(void)wxPayinfo:(NSString *)orderId orderType:(NSString *)orderType;


+(void)wxpay:(NSDictionary *)responseObject;

+(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key;

@end
