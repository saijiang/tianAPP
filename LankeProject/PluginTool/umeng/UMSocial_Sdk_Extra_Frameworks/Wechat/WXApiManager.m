//
//  WXpay.m
//  DDXGProject
//
//  Created by itman on 16/3/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)])
        {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)])
        {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
    {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)])
        {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }
    else if([resp isKindOfClass:[PayResp class]])
    {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvPayResponse:)])
        {
            PayResp *payResp = (PayResp *)resp;
            [_delegate managerDidRecvPayResponse:payResp];
        }
        
    }
    
}

- (void)onReq:(BaseReq *)req
{
    if ([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)])
        {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)])
        {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    }
    else if ([req isKindOfClass:[LaunchFromWXReq class]])
    {
        
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)])
        {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}


+(void)wxPayinfo:(NSString *)orderId orderType:(NSString *)orderType
{
    [UserServices
     wxPayinfoWithOrderId:orderId
     orderType:orderType
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [WXApiManager wxpay:responseObject[@"data"]];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}


+(void)wxpay:(NSDictionary *)responseObject
{

    /*! @brißef 第三方向微信终端发起支付的消息结构体
     *
     *  第三方向微信终端发起支付的消息结构体，微信终端处理后会向第三方返回处理结果
     * @see PayResp
     */
    
//    "timestamp": 1490173557397,
//    "result_code": "SUCCESS",
//    "sign": "B3D4874605EEA5B2A0D4A06EE6562C9C",
//    "mch_id": "1425422202",
//    "prepay_id": "wx20170322170557cd1676ad0f0566978703",
//    "return_msg": "OK",
//    "appid": "wxbdaac583baefa412",
//    "nonce_str": "9Qyfo5nhE3NqWs50",
//    "return_code": "SUCCESS",
//    "trade_type": "APP"
    
    
    /** 商家向财付通申请的商家id */
    NSString *partnerId=responseObject[@"mch_id"];
    /** 预支付订单 */
    NSString *prepayId=responseObject[@"prepay_id"];
    /** 随机串，防重发 */
    NSString *nonceStr=responseObject[@"nonce_str"];
    /** 时间戳，防重发 */
    UInt32 timeStamp=[responseObject[@"timestamp"] intValue];
    /** 商家根据财付通文档填写的数据和签名 */
    NSString *package =@"Sign=WXPay";
    /** 商家根据微信开放平台文档对数据做的签名 NSString *sign;*/
    
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = partnerId;
    req.prepayId            = prepayId;
    req.package             = package;
    req.nonceStr            = nonceStr;
    req.timeStamp           = timeStamp ;
    req.sign=[self createMD5SingForPay:responseObject[@"appid"] partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr     timestamp:req.timeStamp];
   [WXApi sendReq:req];
    
}

//创建发起支付时的sige签名
+(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@", WXkey];
    NSString *result = [self md5:contentString];
    return result;
}
+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
