//
//  UserServices.m
//  Les
//
//  Created by 朱亮亮 on 14-11-4.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UserServices.h"
#import "BMNetworkHandler.h"
#import "HealthExamSecondViewController.h"
#import "DES3Util.h"

@implementation UserServices
#pragma mark 获取用户权限
/*
 参数名 	必选 	类型 	说明
 userId 	是 	string 	用户id
 flag 	否 	string 	01：健康，02：物业（暂时不传）
 */
+ (void)getUserAuthorityByUserId:(NSString *)userId
                            flag:(NSString *)flag
                            type:(NSString *)type
                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:flag forKey:@"flag"];
    [params setValue:type forKey:@"type"];

    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getUserAuthority
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

+ (void)guangGaoWithUserCompletionBlock:(kCompletionBlock)completionBlock{
    
    
    //    params=[DES3Util getSecrityForString:params];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkguang_gao
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark 登录

/**
 userAccount	是	string	手机号码/员工工号
 userPassword	是	string	密码
 registrationId	是	string	极光推送ID
 */
+ (void)loginWithUserAccount:(NSString *)userAccount
                userPassword:(NSString *)userPassword
              registrationId:(NSString *)registrationId
             completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userAccount forKey:@"userAccount"];
    [params setValue:[userPassword md5]  forKey:@"userPassword"];
    [params setValue:[JPUSHService registrationID] forKey:@"registrationId"];
//    params=[DES3Util getSecrityForString:params];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_login
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 登出

/*
 userId	是	string	用户id
 */
+ (void)logouByUserId:(NSString *)userId
      completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_logout
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 发送验证码

/*
 mobileNum	是	string	用户账号（手机号码）
type	是	string	发送验证码类型（1:注册 2：找回密码 3：更改绑定手机号码）
 */
+ (void) sendAuthCodeWithMobileNum:(NSString *)mobileNum
                              type:(NSString *)type
                   completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobileNum forKey:@"mobileNum"];
    [params setValue:type forKey:@"type"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_sendAuthCode
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/*
 msgId	是	String	短信ID
 authCode	是	String	验证码
 */
+ (void) nextStepWithMsgId:(NSString *)msgId
                              authCode:(NSString *)authCode
                   completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:msgId forKey:@"msgId"];
    [params setValue:authCode forKey:@"authCode"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_nextStep
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 注册

/*
 userAccount	是	string	用户账号（手机号）
 userPassword	是	string	密码
 msgId	是	string	短信id
 authCode	是	string	验证码
 mobileSystemType	是	string	手机端设备类型（1:android/2:ios）
 registrationId	是	string
 */
+ (void)registerWithUserAccount:(NSString *)mobileNum
                   userPassword:(NSString *)userPassword
                confirmPassword:(NSString *)confirmPassword
                 registrationId:(NSString *)registrationId
                       nickName:(NSString *)nickName
                completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobileNum forKey:@"mobileNum"];
    [params setValue:[userPassword md5] forKey:@"newPassword"];
    [params setValue:[confirmPassword md5] forKey:@"confirmPassword"];
    [params setValue:registrationId forKey:@"registrationId"];
    [params setValue:@"2" forKey:@"mobileSystemType"];
    [params setValue:nickName forKey:@"nickName"];

    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_register
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 找回密码

/*
 mobileNum	是	string	用户账号（手机号）
 newPassword	是	string	新密码
 confirmPassword	是	string	确认密码
 authCode	是	string	验证码
 msgId	是	string	短信id
 */
+ (void) getBackPasswordWithMobileNum:(NSString *)mobileNum
                          newPassword:(NSString *)newPassword
                      confirmPassword:(NSString *)confirmPassword
                             authCode:(NSString *)authCode
                                msgId:(NSString *)msgId
                      completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobileNum forKey:@"mobileNum"];
    [params setValue:[newPassword md5] forKey:@"newPassword"];
    [params setValue:[confirmPassword md5] forKey:@"confirmPassword"];
    [params setValue:authCode forKey:@"authCode"];
    [params setValue:msgId forKey:@"msgId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getBackPassword
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 首页

#pragma mark -
#pragma mark 广告列表
+ (void) advertAdvertListCompletionBlock:(kCompletionBlock)completionBlock{

    [[BMNetworkHandler sharedInstance] conURL:HK_advert_advertList
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark JD

#pragma mark -
#pragma mark 广告列表
+ (void) JDadvertAdvertListCompletionBlock:(kCompletionBlock)completionBlock{
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDadvert_advertList
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


+ (void) advertAdvertDetailWithId:(NSString *)advertId
                   ompletionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:advertId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_advert_advertDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 订餐模块

#pragma mark 订餐广告列表

+ (void) advertListCompletionBlock:(kCompletionBlock)completionBlock{

    [[BMNetworkHandler sharedInstance] conURL:HK_restaurantAdvert_advertList
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 订餐广告详情接口

/*
 id	是	string	订餐广告编号
 */
+ (void) advertDetialWithId:(NSString *)advertId
            completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:advertId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_restaurantAdvert_advertDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 餐厅或食堂列表接口
/*
 restaurantType	是	string	餐厅类型：01、食堂 02、餐厅
 restaurantLongitude	是	string	经度
 restaurantLatitude	是	string	纬度
 provinceId	否	string	省
 cityId	否	string	市
 districtId	否	string	区
 restaurantName	否	string	餐厅名称
 restaurantClass	否	string	餐厅分类
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) getBackPasswordWithRestaurantType:(NSString *)restaurantType
                       restaurantLongitude:(NSString *)restaurantLongitude
                        restaurantLatitude:(NSString *)restaurantLatitude
                                provinceId:(NSString *)provinceId
                                    cityId:(NSString *)cityId
                                districtId:(NSString *)districtId
                            restaurantName:(NSString *)restaurantName
                           restaurantClass:(NSString *)restaurantClass
                                 pageIndex:(NSString *)pageIndex
                                  pageSize:(NSString *)pageSize
                           completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:restaurantType forKey:@"restaurantType"];
    [params setValue:restaurantLongitude forKey:@"restaurantLongitude"];
    [params setValue:restaurantLatitude forKey:@"restaurantLatitude"];
    [params setValue:provinceId forKey:@"provinceId"];
    [params setValue:cityId forKey:@"cityId"];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:restaurantName forKey:@"restaurantName"];
    [params setValue:restaurantClass forKey:@"restaurantClass"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_restaurant_restaurantList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     
     
     
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             
             
             
             completionBlock(result,returnData);
             
             
             
             
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 食堂/餐厅 详情
/*
 参数名	必选	类型	说明
 id	是	string	餐厅编号
 */
+ (void)getRestaurantDetail:(NSString *)restaurantId
                     userId:(NSString *)userId
            completionBlock:(kCompletionBlock)completionBlock;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:restaurantId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_restaurant_restaurantDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
/** 获取菜品分类 */
+ (void)restaurantRestaurantCompletionBlock:(kCompletionBlock)completionBlock{
    
    [[BMNetworkHandler sharedInstance] conURL:HK_restaurant_restaurantClass
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 每周菜谱接口
/*
 参数名	必选	类型	说明
 menuDate	是	string	日期，格式：yyyy-MM-dd
 restaurantId	是	string	餐厅编号
 menuType 	是 	string 	食谱类型（全部传空或null，01：早餐 02：午餐 03：晚餐）
 */
+ (void)getWeekMenuDetailWithMenuDate:(NSString *)menuDate
                         restaurantId:(NSString *)restaurantId
                             menuType:(NSString *)menuType
                      completionBlock:(kCompletionBlock)completionBlock;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:menuDate forKey:@"menuDate"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:menuType forKey:@"menuType"];

    [[BMNetworkHandler sharedInstance] conURL:HK_weekMenuDetail_weekMenuDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 菜品详情接口
/*
 参数名	必选	类型	说明
 id	是	string	菜品编号
 */
+ (void)getDishesDetailWithdishesId:(NSString *)dishesId
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dishesId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_dishes_dishes
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 提交评价接口
/**
 restaurantType	是	string	餐厅类型 ：01食堂，02周围餐厅
 dishesId	是	string	菜品编号
 dishesName	是	string	菜品名称
 evalScores	是	string	评分
 evalContent	是	string	评价内容
 userId	是	string	用户编号
 userName	是	string	用户名
 */
+ (void) saveEvaluationWithRestaurantType:(NSString *)restaurantType
                                 dishesId:(NSString *)dishesId
                               dishesName:(NSString *)dishesName
                               evalScores:(NSString *)evalScores
                              evalContent:(NSString *)evalContent
                                   userId:(NSString *)userId
                                 userName:(NSString *)userName
                          completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:restaurantType forKey:@"restaurantType"];
    [params setValue:dishesId forKey:@"dishesId"];
    [params setValue:dishesName forKey:@"dishesName"];
    [params setValue:evalScores forKey:@"evalScores"];
    [params setValue:evalContent forKey:@"evalContent"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_dishesEvaluation_saveEvaluation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
/** 评论列表接口 */
+ (void) evaluationListWithDishesId:(NSString *)dishesId
                          pageIndex:(NSString *)pageIndex
                           pageSize:(NSString *)pageSize
                    completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dishesId forKey:@"dishesId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_evaluationList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 外卖菜品列表
/**
 restaurantId	是	string	餐厅编号
 */
+(void) takeOutMenuListWithrRstaurantId:(NSString *)restaurantId
                                 userId:(NSString *)userId
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_takeOutMenu_takeOutMenuList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];

         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 提交外卖订单
/**
 userId	是	string	用户编号
 userName	是	string	用户名称
 restaurantId	是	string	餐厅编号
 restaurantName	是	string	餐厅名称
 takeOutType	是	string	外卖类型：01、自提，02送货上门
 addressId	否	string	地址编号，takeOutType为送货上门时，此值为必填
 orderNote	否	string	备注
 */
+ (void) orderTakeOutWithUserId:(NSString *)userId
                       userName:(NSString *)userName
                   restaurantId:(NSString *)restaurantId
                 restaurantName:(NSString *)restaurantName
                    takeOutType:(NSString *)takeOutType
                      addressId:(NSString *)addressId
                      orderNote:(NSString *)orderNote
                        payMent:(NSString *)payMent
                completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:restaurantName forKey:@"restaurantName"];
    [params setValue:takeOutType forKey:@"takeOutType"];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:orderNote forKey:@"orderNote"];
    [params setValue:payMent forKey:@"payMent"];
    params=[DES3Util getSecrityForString:params];//加密
    [[BMNetworkHandler sharedInstance] conURL:HK_orderTakeOut_orderTakeOut
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 提交订座订单
/**
 userId	是	string	用户编号
 userName	是	string	用户名称
 restaurantId	是	string	餐厅编号
 restaurantName	是	string	餐厅名称
 contactName	是	string	联系人姓名
 contactMobile	是	string	联系人手机
 contactSex	是	string	联系人性别：01男，02女
 dinersNum	是	string	订座人数
 reserveDate	是	string	预订日期 yyyy-MM-dd
 reserveTime	是	string	预订时间 HH:mm
 orderFlg	是	string	是否点菜：0、否，1是
 orderNote	否	string	订单备注
 */
+ (void) orderReservationWithUserId:(NSString *)userId
                           userName:(NSString *)userName
                       restaurantId:(NSString *)restaurantId
                     restaurantName:(NSString *)restaurantName
                        contactName:(NSString *)contactName
                      contactMobile:(NSString *)contactMobile
                         contactSex:(NSString *)contactSex
                          dinersNum:(NSString *)dinersNum
                        reserveDate:(NSString *)reserveDate
                        reserveTime:(NSString *)reserveTime
                           orderFlg:(NSString *)orderFlg
                          orderNote:(NSString *)orderNote
                            payMent:(NSString *)payMent
                    completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:restaurantName forKey:@"restaurantName"];
    [params setValue:contactName forKey:@"contactName"];
    [params setValue:contactMobile forKey:@"contactMobile"];
    [params setValue:contactSex forKey:@"contactSex"];
    [params setValue:dinersNum forKey:@"dinersNum"];
    [params setValue:reserveDate forKey:@"reserveDate"];
    [params setValue:reserveTime forKey:@"reserveTime"];
    [params setValue:orderFlg forKey:@"orderFlg"];
    [params setValue:orderNote forKey:@"orderNote"];
    [params setValue:payMent forKey:@"payMent"];
    params=[DES3Util getSecrityForString:params];//加密
    [[BMNetworkHandler sharedInstance] conURL:HK_orderReservation_orderReservation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 点菜列表
/**
 restaurantId	是	string	餐厅编号
 userId	是	string	用户编号
 */
+(void) dishesListWithrRstaurantId:(NSString *)restaurantId
                            userId:(NSString *)userId
                   completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_dishesClass_dishesList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 下周想吃菜单接口
/**
 restaurantId	是	string	餐厅编号
 userId	是	string	用户编号
 */
+(void) nextWeekMenuDetailWithrRstaurantId:(NSString *)restaurantId
                                    userId:(NSString *)userId
                           completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_weekMenuDetail_nextWeekMenuDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 下周想吃-想吃接口
/**
 userId	是	string	用户编号
 userName	是	string	用户名称
 dishesId	是	string	菜单编号
 */
+ (void) saveWeekEatWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                      dishesId:(NSString *)dishesId
               completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dishesId forKey:@"dishesId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_weekEat_saveWeekEat
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 留言
/**
 userId	是	string	用户编号
 userName	是	string	用户名称
 restaurantId	是	string	餐厅编号
 messageContent	是	string	留言内容
 */
+ (void) saveMessageWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                  restaurantId:(NSString *)restaurantId
                messageContent:(NSString *)messageContent
               completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:messageContent forKey:@"messageContent"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_message_saveMessage
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 加入购物车
/**
 userId	是	string	用户名Id
 cartType	是	string	购物车类型 （01、点餐，02、外卖）
 restaurantId	是	string	餐厅编号
 userName	否	string	用户账号
 cardList	否	string	菜品集合（对应下面格式）
 */
+(void) addOrderCartWithrCardList:(NSString *)cardList
                           userId:(NSString *)userId
                         cartType:(NSString *)cartType
                     restaurantId:(NSString *)restaurantId
                         userName:(NSString *)userName
                  completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:cardList forKey:@"cardList"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    [params setValue:cartType forKey:@"cartType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_orderCart_addOrderCart
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 获取购物车列表
/**
 userId	是	string	用户编号
 cartType	是	string	购物车类型：01、订座，02、外卖
 restaurantId	是	string	餐厅编号
 */
+(void) orderCartListWithrUserId:(NSString *)userId
                        cartType:(NSString *)cartType
                    restaurantId:(NSString *)restaurantId
                 completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:cartType forKey:@"cartType"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_orderCart_orderCartList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 钱包支付
/**
 userId	是	string	用户编号
 orderCode	是	string	订单编号
 orderType	是	string	订单类型：01、订座订单，02、外卖订单
 userPassword	是	string	支付密码
 */
+(void) walletWithrUserId:(NSString *)userId
                orderCode:(NSString *)orderCode
                orderType:(NSString *)orderType
             userPassword:(NSString *)userPassword
          completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:orderType forKey:@"orderType"];
    [params setValue:[userPassword md5] forKey:@"userPassword"];
    params=[DES3Util getSecrityForString:params];//加密
    [[BMNetworkHandler sharedInstance] conURL:HK_wallet_wallet
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 获取订餐和自营信息的价格体系接口
/**
 strJson 	是 	string 	json
 flag 	是 	string 	类型（01:订餐 ，02：自营商品）
 订餐： [{"dishesPrice": "100","dishesCouponPrice": "90","dishesNum":"3"},{"dishesPrice": "80","dishesCouponPrice": "70","dishesNum":"3"}]------- （dishesPrice（原价），dishesCouponPrice（优惠价），dishesNum(数量)）
 
 自营商品： [{"merchantId": "1","merchantName": "1","listGoods": [{"marketPrice": "100","salePrice": "110","goodsNum":"1"},{"marketPrice": "100","salePrice": "110","goodsNum":"1"}]}]------- （salePrice（原价），marketPrice（优惠价），goodsNum(数量)）
 */
+(void) getCouponPriceInfoWithstrJson:(NSString *)strJson
                                 flag:(NSString *)flag
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:strJson forKey:@"strJson"];
    [params setValue:flag forKey:@"flag"];
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getCouponPriceInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝个人中心模块＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#pragma mark－ 用户信息查询
/*
 userId 	是 	string 	用户id
 */
+ (void) getUserInfoWithuserId:(NSString *)userId
               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getUserInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (result==0)
         {
             
             [[UserInfo_Preferences sharedInstance] savePreferencesWithData:returnData[@"data"]];
         }
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 添加收货地址
/*
 userId 	是 	String 	用户id
 receiveName 	是 	String 	收货人
 areaId 	是 	String 	区域id
 areaInfo 	是 	String 	区域名称
 detailedAddress 	是 	String 	详细地址
 receivePhone 	是 	String 	联系电话
 isDefault 	是 	String 	是否默认 0:非默认 1:默认
 */
+ (void) addAddressWithuserId:(NSString *)userId
                  receiveName:(NSString *)receiveName
             addressLongitude:(NSString *)addressLongitude
              addressLatitude:(NSString *)addressLatitude
                     areaInfo:(NSString *)areaInfo
              detailedAddress:(NSString *)detailedAddress
                 receivePhone:(NSString *)receivePhone
                    isDefault:(NSString *)isDefault
                     province:(NSString *)province
                         city:(NSString *)city
                       county:(NSString *)county
              completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:receiveName forKey:@"receiveName"];
    [params setValue:addressLongitude forKey:@"addressLongitude"];
    [params setValue:addressLatitude forKey:@"addressLatitude"];
    [params setValue:areaInfo forKey:@"areaInfo"];
    [params setValue:detailedAddress forKey:@"detailedAddress"];
    [params setValue:receivePhone forKey:@"receivePhone"];
    [params setValue:isDefault forKey:@"isDefault"];

    // add bes Store.One
    province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
    province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
    [params setValue:province forKey:@"province"];// 省
    [params setValue:city forKey:@"city"];// 市
    [params setValue:county forKey:@"county"];// 区
    
    [[BMNetworkHandler sharedInstance] conURL:HK_address_addAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 京东添加收货地址
/*
 
 参数名	必选	类型	说明
 userId	是	String	用户id
 name	是	String	收货人名称
 mobile	是	String	收货人手机
 email	是	String	email
 address	是	String	详细地址
 province	是	String	一级地址
 provinceName	是	String	一级地址名称
 city	是	String	二级地址 没有传0
 cityName	是	String	二级地址名称 没有传空字符串
 county	是	String	三级地址 没有传0
 countyName	是	String	三级地址名称 没有传空字符串
 town	是	String	四级地址 没有传0
 townName	是	String	四级地址名称 没有传空字符串
 isDefault	是	String
 */
+ (void) addJDAddressWithuserId:(NSString *)userId
                           name:(NSString *)name
                           mobile:(NSString *)mobile
                             email:(NSString *)email
                             address:(NSString *)address
                           province:(NSString *)province
                           provinceName:(NSString *)provinceName
                            city:(NSString *)city
                         cityName:(NSString *)cityName
                           county:(NSString *)county
                          countyName:(NSString *)countyName
                           town:(NSString *)town
                       townName:(NSString *)townName
                         isDefault:(NSString *)isDefault
              completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:name forKey:@"name"];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:email forKey:@"email"];
    [params setValue:address forKey:@"address"];
    [params setValue:province forKey:@"province"];
    [params setValue:provinceName forKey:@"provinceName"];
    [params setValue:city forKey:@"city"];
    [params setValue:cityName forKey:@"cityName"];
    [params setValue:county forKey:@"county"];
    [params setValue:countyName forKey:@"countyName"];
    [params setValue:town forKey:@"town"];
    [params setValue:townName forKey:@"townName"];
    [params setValue:isDefault forKey:@"isDefault"];

    [[BMNetworkHandler sharedInstance] conURL:HK_JDaddress_addJDAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


#pragma mark－ 获取默认收货地址
/*
 userId	是	string	用户编号
 restaurantId	否	string	餐厅编号，外卖订单此字段必填
 */
+ (void) getDefaultAddressListWithuserId:(NSString *)userId
                            restaurantId:(NSString *)restaurantId
                         completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:restaurantId forKey:@"restaurantId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_address_getDefaultAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 获取JD默认收货地址
/*
 userId	是	string	用户编号
 restaurantId	否	string	餐厅编号，外卖订单此字段必填
 */
+ (void) getJDDefaultAddressListWithuserId:(NSString *)userId
                         completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDaddress_getJDDefaultAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark－ 获取运费接口
/*
 
 addressId	是	string	地址编号
 orderList	是	string	json集合（对应下面格式）
 
 Json参数说明：
 
 shippingName	是	string	配送方式（ 03：快递配送）
 cartId	是	string	购物车Id
 goodsId	是	string	商品Id
 productType	否	string	商品类型：0、普通商品，1、系列商品（商品详情页立即购买需传此字段）
 goodsName	是	string	商品名称
 marketPrice	是	string	商品价格
 goodsNum	是	String	数量
 */
+ (void) getPostFeeWithaddressId:(NSString *)addressId
                       orderList:(NSString *)orderList
                 completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:orderList forKey:@"orderList"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getPostFee
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 获取JD运费接口
/*
 
 
 参数名	必选	类型	说明
 sku	是	string	[{“skuId”:商品编号1,”num”:商品数量1},{“skuId”:商品编号2,”num”:商品数量2}] （最多支持50种商品）
 province	是	string	一级地址
 city	是	string	二级地址
 county	是	string	三级地址
 town	是	string	四级地址 (如果该地区有四级地址，则必须传递四级地址，没有四级地址则传0)
 */
+ (void) getJDPostFeeWithsku:(NSString *)sku
                       province:(NSString *)province
                         city:(NSString *)city
                         county:(NSString *)county
                 completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:sku forKey:@"sku"];
    [params setValue:province forKey:@"province"];
    [params setValue:city forKey:@"city"];
    [params setValue:county forKey:@"county"];
    [params setValue:@"0" forKey:@"town"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDgoodsOrder_JDgetPostFee
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark－ 地址列表
/*
 userId 	是 	string 	用户id
 */
+ (void) getAddressListWithuserId:(NSString *)userId
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_address_getAddressList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 京东地址列表
/*
 userId 	是 	string 	用户id
 */
+ (void) getJDAddressListWithuserId:(NSString *)userId
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_JDaddress_getJDAddressList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark－ 修改地址
/*
 userId 	是 	String 	用户id
 receiveName 	是 	String 	收货人
 addressLongitude 	是 	String 	经度
 addressLatitude 	是 	String 	纬度
 areaInfo 	是 	String 	区域名称
 detailedAddress 	是 	String 	详细地址
 receivePhone 	是 	String 	联系电话
 isDefault 	是 	String 	是否默认 0:非默认 1:默认
 */
+ (void) getAddressListWithuserId:(NSString *)userId
                        addressId:(NSString *)addressId
                      receiveName:(NSString *)receiveName
                 addressLongitude:(NSString *)addressLongitude
                  addressLatitude:(NSString *)addressLatitude
                         areaInfo:(NSString *)areaInfo
                  detailedAddress:(NSString *)detailedAddress
                     receivePhone:(NSString *)receivePhone
                        isDefault:(NSString *)isDefault
                         province:(NSString *)province
                             city:(NSString *)city
                           county:(NSString *)county
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:receiveName forKey:@"receiveName"];
    [params setValue:addressLongitude forKey:@"addressLongitude"];
    [params setValue:addressLatitude forKey:@"addressLatitude"];
    [params setValue:areaInfo forKey:@"areaInfo"];
    [params setValue:detailedAddress forKey:@"detailedAddress"];
    [params setValue:receivePhone forKey:@"receivePhone"];
    [params setValue:isDefault forKey:@"isDefault"];
    
    // add bes Store.One
    province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
    province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
    [params setValue:province forKey:@"province"];
    [params setValue:city forKey:@"city"];
    [params setValue:county forKey:@"county"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_address_editAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－ JD修改地址
/*
 参数名	必选	类型	说明
 addressId	是	String	地址id
 userId	是	String	用户id
 name	是	String	收货人名称
 mobile	是	String	收货人手机
 email	是	String	email
 address	是	String	详细地址
 province	是	String	一级地址
 provinceName	是	String	一级地址名称
 city	是	String	二级地址 没有传0
 cityName	是	String	二级地址名称 没有传空字符串
 county	是	String	三级地址 没有传0
 countyName	是	String	三级地址名称 没有传空字符串
 town	是	String	四级地址 没有传0
 townName	是	String	四级地址名称 没有传空字符串
 isDefault	是	String	是否默认 0:非默认 1:默认
 */
+ (void) getJDAddressListWithaddressId:(NSString *)addressId
                        userId:(NSString *)userId
                      name:(NSString *)name
                 mobile:(NSString *)mobile
                  email:(NSString *)email
                         address:(NSString *)address
                  province:(NSString *)province
                     provinceName:(NSString *)provinceName
                        city:(NSString *)city
                         cityName:(NSString *)cityName
                           county:(NSString *)county
                          countyName:(NSString *)countyName
                                town:(NSString *)town
                            townName:(NSString *)townName

                            isDefault:(NSString *)isDefault
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:name forKey:@"name"];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:email forKey:@"email"];
    [params setValue:address forKey:@"address"];
    [params setValue:province forKey:@"province"];
    [params setValue:provinceName forKey:@"provinceName"];
    [params setValue:city forKey:@"city"];
    [params setValue:cityName forKey:@"cityName"];
    [params setValue:county forKey:@"county"];
    [params setValue:countyName forKey:@"countyName"];
    [params setValue:town forKey:@"town"];
    [params setValue:townName forKey:@"townName"];
    [params setValue:isDefault forKey:@"isDefault"];
   

    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDaddress_JDeditAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark－ 删除地址
/*
 userId 	是 	string 	用户id
 addressId 	是 	String 	地址id
 */
+ (void) deleteAddressWithuserId:(NSString *)userId
                       addressId:(NSString *)addressId
                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:addressId forKey:@"addressId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_address_deleteAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark－ 删除JD地址
/*
 userId 	是 	string 	用户id
 addressId 	是 	String 	地址id
 */
+ (void) JDdeleteAddressWithaddressId:(NSString *)addressId
                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //[params setValue:userId forKey:@"userId"];
    [params setValue:addressId forKey:@"addressId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_JDaddress_JDdeleteAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 设置默认地址
/*
 userId 	是 	String 	用户id
 addressId 	是 	String 	地址id
 */
+ (void) setDefaultAddressWithuserId:(NSString *)userId
                           addressId:(NSString *)addressId
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:addressId forKey:@"addressId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_address_setDefaultAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 设置JD默认地址
/*
 userId 	是 	String 	用户id
 addressId 	是 	String 	地址id
 */
+ (void) setJDDefaultAddressWithuserId:(NSString *)userId
                           addressId:(NSString *)addressId
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:addressId forKey:@"addressId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_JDaddress_JDsetDefaultAddress
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark－ 用户信息更新
/*
 userId 	是 	string 	用户id
 headImage 	是 	MultipartFile[] 	headImage
 nickName 	是 	MultipartFile[] 	昵称
 */
+ (void) updateUserInfoWithuserId:(NSString *)userId
                        headImage:(UIImage *)headImage
                         nickName:(NSString *)nickName
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:nickName forKey:@"nickName"];
    NSMutableDictionary *images=[[NSMutableDictionary alloc]init];
    [images setValue:@[headImage] forKey:@"headImage"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_updateUserInfo
                                  networkType:NetWorkPOST
                                       params:params
                                       images:images
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 用户信息更新
/*
 userId 	是 	string 	用户id
 nickName 	是  string  昵称
 */
+ (void) updateNickNameWithuserId:(NSString *)userId
                         nickName:(NSString *)nickName
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:nickName forKey:@"nickName"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_updateNickName
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 用户信息更新
/*
 userId 	是 	string 	用户id
 mobileNum 	是 	string 	手机号码
 msgId 	是 	string 	短信ID
 authCode 	是 	string 	验证码
 */
+ (void) updateMobileNumWithuserId:(NSString *)userId
                         mobileNum:(NSString *)mobileNum
                             msgId:(NSString *)msgId
                          authCode:(NSString *)authCode
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:mobileNum forKey:@"mobileNum"];
    [params setValue:msgId forKey:@"msgId"];
    [params setValue:authCode forKey:@"authCode"];

    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_updateMobileNum
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 自营订单
/*
 userId	是	string	用户Id
 orderState	是	string	状态（全部：空或不传，02：待付款 ， 03：待发货 ， 04：待收货  ，05：待评价）
 pageIndex	是	string	当前页
 pageSize	是	string	每页条数
 */
+ (void) getGoodsOrderListWithuserId:(NSString *)userId
                            pageSize:(NSString *)pageSize
                           pageIndex:(NSString *)pageIndex
                          orderState:(NSString *)orderState
                     completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageSize forKey:@"pageSize"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:orderState forKey:@"orderState"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getGoodsOrderList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 订单
/*
 userId 	是 	String 	用户id
 pageSize 	是 	String 	一页显示条数
 pageIndex 	是 	int 	页数
 orderType 	是 	String 	01:订餐 02：外卖
 */
+ (void) getMealOrderListWithuserId:(NSString *)userId
                           pageSize:(NSString *)pageSize
                          pageIndex:(NSString *)pageIndex
                          orderType:(NSString *)orderType
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageSize forKey:@"pageSize"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:orderType forKey:@"orderType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getMealOrderList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 外卖订单详细
/*
 orderId	是	String	订单id
 */
+ (void) getTakeOutOrderDetailWithorderId:(NSString *)orderId
                          completionBlock:(kCompletionBlock)completionBlock{

    NSString * userId = [UserInfo_Preferences sharedInstance].userId;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:orderId forKey:@"orderId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getTakeOutOrderDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 订餐订单详细
/*
 orderId	是	String	订单id
 */
+ (void) getReservationOrderDetailWithorderId:(NSString *)orderId
                              completionBlock:(kCompletionBlock)completionBlock{

    NSString * userId = [UserInfo_Preferences sharedInstance].userId;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderId forKey:@"orderId"];
    [params setValue:userId forKey:@"userId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getReservationOrderDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 删除订单或取消订单
/*
 orderId	是	String	订单id
 orderType	是	String	01:订餐 02：外卖
 reservationType	是	String	01:订座 02：订座订菜(外卖类型下不传)
 delType	是	String	01：删除订单 02：取消订单
 */
+ (void) cancelMealOrderWithOrderId:(NSString *)orderId
                          orderType:(NSString *)orderType
                    reservationType:(NSString *)reservationType
                            delType:(NSString *)delType
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderId forKey:@"orderId"];
    [params setValue:orderType forKey:@"orderType"];
    [params setValue:reservationType forKey:@"reservationType"];
    [params setValue:delType forKey:@"delType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_cancelMealOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    

}
#pragma mark 疗养券
+(void) getThreapayBalanceWithuserId:(NSString *)userId completionBlock:(kCompletionBlock)completionBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getTherapayBalance
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark 疗养券消费记录
+ (void) getThreapayDetailWithuserId:(NSString *)userId
                   completionBlock:(kCompletionBlock)completionBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getTherapayDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 钱包余额
/*
 userId 	是 	String 	用户id
 */
+ (void) getWalletBalanceWithuserId:(NSString *)userId
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getWalletBalance
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 消费记录
/*
 userId 	是 	String 	用户id
 orderId 	是 	String 	订单id
 */
+ (void) getWalletDetailWithuserId:(NSString *)userId
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getWalletDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 重设支付密码
/*
 userId 	是 	String 	用户ID
 msgId 	是 	String 	极光推送ID
 authCode 	是 	String 	验证码
 newPassword 	是 	String 	新密码
 confirmPassword 	是 	String 	确认密码
 */
+ (void) updateWalletPasswordWithuserId:(NSString *)userId
                                  msgId:(NSString *)msgId
                               authCode:(NSString *)authCode
                            newPassword:(NSString *)newPassword
                        confirmPassword:(NSString *)confirmPassword
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:msgId forKey:@"msgId"];
    [params setValue:authCode forKey:@"authCode"];
    [params setValue:[newPassword md5]forKey:@"newPassword"];
    [params setValue:[confirmPassword md5]forKey:@"confirmPassword"];

    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_updateWalletPassword
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－ 我的消息接口
/*
 userId 	是 	string 	用户Id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getMessageListWithuserId:(NSString *)userId
                        pageIndex:(NSString *)pageIndex
                         pageSize:(NSString *)pageSize
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_message_getMessageList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－ 清空我的消息
/*
 userId 	是 	string 	用户Id
 id 	否 	string 	消息id
 */
+ (void) cleanMessageWithuserId:(NSString *)userId
                      messageId:(NSString *)messageId
                completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:messageId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_message_cleanMessage
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark－ 消息标记为已读
/*
 id 	否 	string 	消息id
 */
+ (void) readMessageId:(NSString *)messageId
       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:messageId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_message_readMessage
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark－ 查看是否有新消息
/*
 id 	否 	string 	消息id
 */
+ (void) getMessageCount:(NSString *)userId
         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_message_getMessageCount
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝健康总模块＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#pragma mark－ 轮播图
/*
 
 */
+ (void) getHealthNoticeListCompletionBlock:(kCompletionBlock)completionBlock{

    [[BMNetworkHandler sharedInstance] conURL:HK_healthNotice_gethealthNoticeList
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 轮播图详情
/*
 banerId 轮播图id
 */
+ (void) gethHealthNoticeDetailWithId:(NSString *)bannerId
                      completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:bannerId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_healthNotice_gethealthNoticeDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝健康资讯模块＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#pragma mark－ 健康资讯分类
/*
 className	否	String	分类名称
 */
+ (void) healthAdviceClassWithClassName:(NSString *)className
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:className forKey:@"className"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_healthAdvice_healthAdviceClass
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 资讯列表
/*
 adviceClassId	是	String	分类Id
 */
+ (void) healthAdviceListWithAdviceClassId:(NSString *)adviceClassId
                                 pageIndex:(NSString *)pageIndex
                                  pageSize:(NSString *)pageSize
                                       key:(NSString *)key
                           completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:adviceClassId forKey:@"adviceClassId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [params setValue:key forKey:@"key"];

    [[BMNetworkHandler sharedInstance] conURL:HK_healthAdvice_healthAdviceList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－ 资讯详情
/*
 userId 	是 	String 	用户ID
 msgId 	是 	String 	极光推送ID
 authCode 	是 	String 	验证码
 newPassword 	是 	String 	新密码
 confirmPassword 	是 	String 	确认密码
 */
+ (void) healthAdviceDetailWithId:(NSString *)adviceId
                           userId:(NSString *)userId
                  completionBlock:(kCompletionBlock)completionBlock{
 
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:adviceId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_healthAdvice_healthAdviceDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 收藏
/*
 userId	是	string	用户id
 itemsId	是	string	收藏项id
 collectType	是	string	收藏类型 (01：商品 02：餐厅 03：资讯 04：帖子 05:商铺 06：社区头条)
 userName	是	string	用户账号
 */
+ (void) collectionHeadlthAdviceWithUserId:(NSString *)userId
                                   itemsId:(NSString *)itemsId
                               collectType:(NSString *)collectType
                                  userName:(NSString *)userName
                           completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:itemsId forKey:@"itemsId"];
    [params setValue:collectType forKey:@"collectType"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_collect_collectHealthAdvice
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

+ (void) cancelHealthAdviceWithUserId:(NSString *)userId
                              itemsId:(NSString *)itemsId
                          collectType:(NSString *)collectType
                      completionBlock:(kCompletionBlock)completionBlock
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:itemsId forKey:@"itemsId"];
    [params setValue:collectType forKey:@"collectType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_collect_cancelHealthAdvice
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 我收藏的帖子接口

/*
 userId 	是 	string 	用户id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getCollectTopicListWithUserId:(NSString *)userId
                             pageIndex:(NSString *)pageIndex
                              pageSize:(NSString *)pageSize
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_topic_getCollectTopicList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark -
#pragma mark 健身榜
/**
 userId	是	string	用户Id
 type	是	string	01:好友 02：单位排名 03：世界排行
 pageIndex	是	string	当前页
 pageSize	是	string	每页条数
 */
+ (void) getFitnessPlanListWithUserId:(NSString *)userId
                                 type:(NSString *)type
                            pageIndex:(NSString *)pageIndex
                             pageSize:(NSString *)pageSize
                      completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:type forKey:@"type"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_getFitnessPlanList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 关注好友
/** friend/attentFriend
 userId	是	string	用户Id
 concernedUserId	是	string	被关注的用户Id
 userName	是	string	用户账号
 */
+ (void) attentFriendWithUserId:(NSString *)userId
                concernedUserId:(NSString *)concernedUserId
                       userName:(NSString *)userName
                completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/friend/attentFriend"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 取消关注好友
/** friend/cancelAttentFriend
 userId	是	string	用户Id
 concernedUserId	是	string	被关注的用户Id
 */
+ (void) cancelAttentFriendWithUserId:(NSString *)userId
                      concernedUserId:(NSString *)concernedUserId
                      completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/friend/cancelAttentFriend"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 点赞
/** friend/addClick
 userId	是	string	用户Id
 concernedUserId	是	string	被关注的用户Id
 userName	是	string	用户账号
 */
+ (void) addClickWithUserId:(NSString *)userId
            concernedUserId:(NSString *)concernedUserId
                   userName:(NSString *)userName
            completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/friend/addClick"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 取消点赞
/** friend/cancelClick
 userId	是	string	用户Id
 concernedUserId	是	string	被关注的用户Id
 */
+ (void) cancelClickWithUserId:(NSString *)userId
               concernedUserId:(NSString *)concernedUserId
               completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/friend/cancelClick"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 获取健身榜历史数据
/**
 userId	是	string	用户Id
 */
+ (void) getFitnessPlanHistoryUserId:(NSString *)userId
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                     completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_getFitnessPlanHistory
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

+ (void) getAddressInfoCompletionBlock:(kCompletionBlock)completionBlock{

    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/TrendRegion/getAreaInfo"]
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
//京东城市地址
+ (void) getJDAddressInfoCompletionBlock:(kCompletionBlock)completionBlock{
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/jdArea/getAddress"]
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 健身直播
/** /healthLive/getHealthFitnessList
 userId	是	string	用户Id
 */
+ (void) getHealthFitnessListWithUserId:(NSString *)userId
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/healthLive/getHealthFitnessList"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/** /healthLive/getHealthFitnessList
 userId	是	string	用户id
 startTime	是	string	开始时间（列如：2017-07-01）
 endTime	是	string	结束时间（列如：2017-07-06）
 pageIndex	是	String	当前页
 pageSize	是	String	每页条数
 */
+ (void) getHealthFitnessNewListWithUserId:(NSString *)userId
                                 startTime:(NSString *)startTime
                                   endTime:(NSString *)endTime
                                 pageIndex:(NSString *)pageIndex
                                  pageSize:(NSString *)pageSize
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [params setValue:startTime forKey:@"startTime"];
    [params setValue:endTime forKey:@"endTime"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/healthLive/getHealthFitnessNewList"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 预约健身直播
/** /healthLive/addHealthAppoint
 userId	是	string	用户Id
 userName	是	string	账号名
 healthLiveId	是	string	健身直播id
 */
+ (void) addHealthAppointWithUserId:(NSString *)userId
                           userName:(NSString *)userName
                       healthLiveId:(NSString *)healthLiveId
                    completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:healthLiveId forKey:@"healthLiveId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/healthLive/addHealthAppoint"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 关注用户
/**
 userId	是	string	用户Id
 concernedUserId	是	string	被关注的用户Id
 userName	是	string	用户账号
 */
+ (void) attentFriendUserId:(NSString *)userId
            concernedUserId:(NSString *)concernedUserId
                   userName:(NSString *)userName
            completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_attentFriend
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 取消关注用户
/**
 userId	是	string	用户Id
 concernedUserId	是	string	被关注的用户Id
 */
+ (void) cancelAttentFriendUserId:(NSString *)userId
                  concernedUserId:(NSString *)concernedUserId
                  completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_cancelAttentFriend
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 点赞
/**
 userId	是	string	用户名Id
 concernedUserId	是	string	被关注的用户Id
 userName	是	string	用户账号
 */
+ (void) addClickUserId:(NSString *)userId
        concernedUserId:(NSString *)concernedUserId
               userName:(NSString *)userName
        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_addClick
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 取消点赞
/**
 userId	是	string	用户名Id
 concernedUserId	是	string	被关注的用户Id
 */
+ (void) cancelClickUserId:(NSString *)userId
           concernedUserId:(NSString *)concernedUserId
           completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:concernedUserId forKey:@"concernedUserId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_cancelClick
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

+ (void) saveBodySelfCheck:(NSString *)userId
                  userName:(NSString *)userName
                healthInfo:(HealthInfo *)healthInfo
           completionBlock:(kCompletionBlock)completionBlock{


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
//    [params setValue:concernedUserId forKey:@"concernedUserId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_cancelClick
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/** /onlineService/getOnlineService
 serviceType	是	string	在线客服类型（01：健康 02：健身）
 userId	是	string	用户Id
 */
#pragma mark - 健康直播列表
+ (void)getOnlineServiceWithUserId:(NSString *)userId
                       serviceType:(NSString *)serviceType
                   completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:serviceType forKey:@"serviceType"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/onlineService/getOnlineService"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/** onlineService/sendOnlineService
 
 serviceType	是	string	在线客服类型（01：健康 02：健身）
 userId	是	string	用户Id
 content	是	string	内容
 userName	是	string	用户账号
 */
#pragma mark - 健康直播列表
+ (void)sendOnlineServiceWithUserId:(NSString *)userId
                       serviceType:(NSString *)serviceType
                           content:(NSString *)content
                          userName:(NSString *)userName
                   completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:serviceType forKey:@"serviceType"];
    [params setValue:content forKey:@"content"];
    [params setValue:userName forKey:@"userName"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/onlineService/sendOnlineService"]
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/*  /api/healthLive/getHealthLiveList
 *   健康直播列表
 */
#pragma mark - 健康直播列表
+ (void)healthLivingListCompletionBlock:(kCompletionBlock)completionBlock{

    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/healthLive/getHealthLiveList"]
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/*  /api/bodyinfo/getSickenList
 *   患病情况
 */
#pragma mark - hr患病情况
+ (void)getSickenListWithUserId:(NSString *)userId
                completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/bodyinfo/getSickenList"]

                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/*  /api/bodyinfo/getSickenDetail
 *   患病明细情况
 */
#pragma mark - hr患病明细情况
+ (void)getSickenListWithUserId:(NSString *)userId
                           flag:(NSString *)flag
                completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:flag forKey:@"flag"];
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/bodyinfo/getSickenDetail"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/*  /api/fitness/getDayFitnessPlan
 *   每日健康情况
 */
#pragma mark - 每日健康情况
+ (void)getDayFitnessPlanWithUserId:(NSString *)userId
                        dayTime:(NSString *)dayTime
                      pageIndex:(NSString *)pageIndex
                       pageSize:(NSString *)pageSize
                completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:dayTime forKey:@"fitnessDate"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/getDayFitnessPlan"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/* /api/physiquePer/getPhysiquePerDetail
 *   hr中医体质检测情况详情
 userId	是	string	用户Id
 physiqueType	是	string	体质类型(01：平和质， 02：气虚质， 03：阳虚质 ，04：阴虚质 ，05：痰虚质， 06：湿热质， 07：血瘀质， 08：气郁质， 09：特禀质 )
 */
#pragma mark - hr中医体质检测情况详情
+ (void)getPhysiquePerDetailWithUserId:(NSString *)userId
                            physiqueType:(NSString *)physiqueType

                    completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:physiqueType forKey:@"physiqueType"];
 
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/getPhysiquePerDetail"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/** /physiquePer/getHealthReport
 
 */
#pragma mark - 每日健康情况
+ (void)getHealthReportWithUserId:(NSString *)userId
                  completionBlock:(kCompletionBlock)completionBlock{
 
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/getHealthReport"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
/*
 *zhsq/api/watchInfo/addInfo
 userId	是	string	用户Id
 stepNum	否	int	步数
 heartRate	否	int	心率
 */
#pragma mark -添加智能手环信息
+ (void)gaddInfoWithUserId:(NSString *)userId
                    stepNum:(NSString *)stepNum
                    heartRate:(NSString *)heartRate
                  completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
     [params setValue:stepNum forKey:@"stepNum"];
     [params setValue:heartRate forKey:@"heartRate"];
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/watchInfo/addInfo"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
/*  /api/physiquePer/getPhysiquePerNum
 *   每日健康情况
 */
#pragma mark - 每日健康情况
+ (void)getTCMInfoUserId:(NSString *)userId
         completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/getPhysiquePerNum"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


/** /physiquePer/physiquePerList
 已做题目获取接口
 userId	是	string	用户Id
 physicalType	是	String	体质类型(01：平和质， 02：气虚质， 03：阳虚质 ，04：阴虚质 ，05：痰虚质， 06：湿热质， 07：血瘀质， 08：气虚质， 09：特禀质 )
 */
#pragma mark - 已做题目获取接口
+ (void)physiquePerListWithUserId:(NSString *)userId
                     physicalType:(NSString *)physicalType
                  completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:physicalType forKey:@"physicalType"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/physiquePerList"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/** /physiquePer/addPhysiquePerPoint
 已做题目获取接口
 userId	是	string	用户Id
 userName	是	string	用户账号
 jsonStr	否	string	json集合
 
 physicalType	是	string	体质类型(01：平和质， 02：气虚质， 03：阳虚质 ，04：阴虚质 ，05：痰虚质， 06：湿热质， 07：血瘀质， 08：气虚质， 09：特禀质 )
 questionNum	是	string	题目序号
 questionContent	否	string	题目标题
 questionScore	否	string	选项得分（1：没有 ，2：很少， 3：有时 ，4：经常， 5：总是）
 */
#pragma mark - 下一步题目提交接口
+ (void)addPhysiquePerPointWithUserId:(NSString *)userId
                             userName:(NSString *)userName
                              jsonStr:(NSString *)jsonStr
                      completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:jsonStr forKey:@"jsonStr"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/addPhysiquePerPoint"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


/** /physiquePer/addPhysiquePerScore
 已做题目获取接口
 userId	是	string	用户Id
 userName	是	string	用户账号
 jsonStr	否	string	json集合
 
 physicalType	是	string	体质类型(01：平和质， 02：气虚质， 03：阳虚质 ，04：阴虚质 ，05：痰虚质， 06：湿热质， 07：血瘀质， 08：气虚质， 09：特禀质 )
 questionNum	是	string	题目序号
 questionContent	否	string	题目标题
 questionScore	否	string	选项得分（1：没有 ，2：很少， 3：有时 ，4：经常， 5：总是）
 */
#pragma mark - 题目完成接口
+ (void)addPhysiquePerScoreWithUserId:(NSString *)userId
                             userName:(NSString *)userName
                              jsonStr:(NSString *)jsonStr
                      completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:jsonStr forKey:@"jsonStr"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/addPhysiquePerPoint"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


/** /physiquePer/cleanPhysiquePerPoint
 已做题目获取接口
 userId	是	string	用户Id
 */
#pragma mark - 题目完成接口
+ (void)cleanPhysiquePerPointWithUserId:(NSString *)userId
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/cleanPhysiquePerPoint"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/** physiquePer/getPhysiquePerResult
 userId	是	string	用户Id
 */
#pragma mark - 测试结果接口
+ (void) getPhysiquePerResultWithUserId:(NSString *)userId
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physiquePer/getPhysiquePerResult"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
/** physique/setSex?userId=asdfasf&sex=01
 userId	是	string	用户Id
 sex	是	String	01：男 02：女
 */
#pragma mark - 设置中医体质检测性别
+ (void) getPhysiqueSetSexWithUserId:(NSString *)userId
                                  sex:(NSString *)sex
                        completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:sex forKey:@"sex"];
    [[BMNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@%@",API_HOST,@"/physique/setSex"]
     
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 判断是否有进行中的健身计划
+ (void) fitnessPlanIsExistWithUserId:(NSString *)userId
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_fitnessPlanIsExist
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark - 新增健身计划详情信息（手环数据）
/**
 参数名 	必选 	类型 	说明
 userId 	是 	string 	用户编号
 consumeCalories 	是 	string 	消耗的卡路里
 */
+ (void) saveFitnessPlanDetailWithUserId:(NSString *)userId
                         consumeCalories:(NSString *)consumeCalories
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:consumeCalories forKey:@"consumeCalories"];
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_saveFitnessPlanDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark - 主题教学分类列表接口
/**
 参数名 	必选 	类型 	说明
 */
+ (void) getTeachVideoClassCompletionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [[BMNetworkHandler sharedInstance] conURL:HK_teach_getTeachVideoClass
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    

}

#pragma mark - 获取主题列表接口
/**
 videoClassId 	否 	string 	分类id
 title 	否 	string 	标题
 teachingType 	是 	string 	教学类型（01：视频 02：咨询）
 */
+ (void) getTeachListWithVideoClassId:(NSString *)videoClassId
                                title:(NSString *)title
                         teachingType:(NSString *)teachingType
                            pageIndex:(NSString *)pageIndex
                             pageSize:(NSString *)pageSize
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:videoClassId forKey:@"videoClassId"];
    [params setValue:title forKey:@"title"];
    [params setValue:teachingType forKey:@"teachingType"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_teach_getTeachList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 获取主题教学详情接口
/**
 id 	是 	string 	主题教学id
 */
+ (void) getTeachDetailWithTeachId:(NSString *)teachId
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:teachId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_teach_getTeachDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark - 健身直播列表接口
/**
 userId 	是 	string 	用户id
 startTime 	是 	string 	开始时间（列如：2017-07-01）
 endTime 	是 	string 	结束时间（列如：2017-07-06）
 */
+ (void) getHealthFitnessNewListWithUserId:(NSString *)userId
                                 startTime:(NSString *)startTime
                                   endTime:(NSString *)endTime
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:startTime forKey:@"startTime"];
    [params setValue:endTime forKey:@"endTime"];
    [[BMNetworkHandler sharedInstance] conURL:HK_healthLive_getHealthFitnessNewList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark --  ===================== 商城模块 =========================


/*  HK_Store_AddGoodsCart
 *   加入购物车<商城模块>
 *
 goodsId	是	string	商品Id
 userId	是	string	用户Id
 merchantId	否	string	商户Id，一号店商品不需要传此参数，京东商品不需要传此参数

 goodsNum	是	string	数量
 cartType	是	string	购物车类型（01：自营 ， 02：一号店） ， 03：京东）

 userName	否	string	用户账号
 productType	否	string	商品类型(0 普通商品 1系列商品)，一号店商品传此参数

 */
#pragma mark - 加入购物车<商城模块>
+ (void)addGoodsInShopCarListWithGoodsId:(NSString *)goodsId
                                  userId:(NSString *)userId
                              merchantId:(NSString *)merchantId
                                goodsNum:(id)goodsNum
                                cartType:(NSString *)cartType
                                userName:(NSString *)userName
                             productType:(NSString *)productType
                         completionBlock:(kCompletionBlock)completionBlock;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:goodsId forKey:@"goodsId"];
    if (merchantId) {
        [params setValue:merchantId forKey:@"merchantId"];
    }
    [params setValue:goodsNum forKey:@"goodsNum"];
    [params setValue:cartType forKey:@"cartType"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:productType forKey:@"productType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_Store_AddGoodsCart
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (result==0)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:DEFN_AddGoodsCart object:nil];
         }
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/**
 
 参数名	必选	类型	说明
 userId	是	string	用户Id
 userName	是	string	买家姓名
 contactName	是	string	收货人姓名
 contactMobile	是	string	收货人手机号
 deliveryAddress	是	string	收货人地址
 addressLongitude	是	string	经度
 addressLatitude	是	string	纬度
 orderList	是	string	json集合（对应下面格式）
 payMent 	是 	string 	支付方式（01：支付宝 ，02：微信 ， 03：钱包支付）
 */
#pragma mark - 提交订单
+ (void)addGoodsOrderWithUserId:(NSString *)userId
                       userName:(NSString *)userName
                    contactName:(NSString *)contactName
                  contactMobile:(NSString *)contactMobile
                deliveryAddress:(NSString *)deliveryAddress
               addressLongitude:(NSString *)addressLongitude
                addressLatitude:(NSString *)addressLatitude
                      orderList:(NSString *)orderList
                        payMent:(NSString *)payMent
                completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:contactName forKey:@"contactName"];
    [params setValue:contactMobile forKey:@"contactMobile"];
    [params setValue:deliveryAddress forKey:@"deliveryAddress"];
    [params setValue:addressLongitude forKey:@"addressLongitude"];
    [params setValue:addressLatitude forKey:@"addressLatitude"];
    [params setValue:orderList forKey:@"orderList"];
    [params setValue:payMent forKey:@"payMent"];
    
     params=[DES3Util getSecrityForString:params];//加密
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_addGoodsOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/**
 userId	是	string	用户Id
 userName	是	string	买家姓名
 addressId	是	string	地址编号
 orderList	是	string	json集合（对应下面格式）
 
 shippingName	是	string	配送方式（ 03：快递配送）**写死的**
 cartId	是	string	购物车Id
 goodsId	是	string	商品Id
 productType	否	string	商品类型：0、普通商品，1、系列商品（商品详情页立即购买需传此字段）
 goodsName	是	string	商品名称
 marketPrice	是	string	商品价格
 goodsNum	是	String	数量
 */
#pragma mark - 提交订单-一号店商品
+ (void)addYhdGoodsOrderWithUserId:(NSString *)userId
                          userName:(NSString *)userName
                         addressId:(NSString *)addressId
                         orderList:(NSString *)orderList
                   completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:orderList forKey:@"orderList"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_addYhdGoodsOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/**
 参数名	必选	类型	说明
 userId	是	string	用户编号
 addressId	是	string	地址id
 remark	是	string	备注
 orderList	是	string	json集合（对应下面格式）
 selectedInvoiceTitle	是	string	发票类型：4个人，5单位
 companyName	是	string	发票抬头 (如果selectedInvoiceTitle=5则此字段必须)
 regcode	是	string	纳税人识别号 (如果selectedInvoiceTitle=5则此字段必须)
 invoiceContent	是	string	1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细
 */
#pragma mark - 提交订单-JD商品
+ (void)addJDGoodsOrderWithUserId:(NSString *)userId
                          addressId:(NSString *)addressId
                         remark:(NSString *)remark
                         orderList:(NSString *)orderList
                       selectedInvoiceTitle:(NSString *)selectedInvoiceTitle
                      companyName:(NSString *)companyName
                      regcode:(NSString *)regcode

                     invoiceContent:(NSString *)invoiceContent
                   completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:remark forKey:@"remark"];
    [params setValue:orderList forKey:@"orderList"];
    
    [params setValue:selectedInvoiceTitle forKey:@"selectedInvoiceTitle"];
    [params setValue:companyName forKey:@"companyName"];
    [params setValue:regcode forKey:@"regcode"];

    [params setValue:invoiceContent forKey:@"invoiceContent"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_addJDGoodsOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/**
 
 参数名	必选	类型	说明
 jdOrderId	是	string	京东订单号
 skuId	是	string	京东商品编号
 jdReturnOrder/getWareReturnJdComp
 */
#pragma mark - 提交订单-JD商品
+ (void)getWareReturnJdCompWithjdOrderId:(NSString *)jdOrderId
                        skuId:(NSString *)skuId

                  completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    [params setValue:skuId forKey:@"skuId"];

    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdReturnOrder_getWareReturnJdComp
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark - 二维码支付
/**
 userId	是	string	用户id
 merchantId	是	string	商家id
 payMoney	是	string	支付金额
 userPassword	是	string	支付密码
 
 */
+(void) walletQrCodeWalletWithrUserId:(NSString *)userId
                           merchantId:(NSString *)merchantId
                             payMoney:(NSString *)payMoney
                         userPassword:(NSString *)userPassword
                      completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:merchantId forKey:@"merchantId"];
    [params setValue:payMoney forKey:@"payMoney"];
    [params setValue:[userPassword md5] forKey:@"userPassword"];
    params=[DES3Util getSecrityForString:params];
    [[BMNetworkHandler sharedInstance] conURL:HK_wallet_QrCodeWallet
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark - 钱包支付
/**
 userId	是	string	用户编号
 orderCode	是	string	订单编号
 orderType	是	string	订单类型：03、自营店（提交订单），04、一号店 ， 05、我的订单、06：团购订单
 userPassword	是	string	支付密码
 */
+(void) orderWalletWithrUserId:(NSString *)userId
                     orderCode:(NSString *)orderCode
                     orderType:(NSString *)orderType
                  userPassword:(NSString *)userPassword
               completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:orderType forKey:@"orderType"];
    [params setValue:[userPassword md5] forKey:@"userPassword"];
    params=[DES3Util getSecrityForString:params];
    [[BMNetworkHandler sharedInstance] conURL:HK_Store_OrderWallet
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 轮播图
/*
 */
+ (void) mallAdvertGetMallAdvertCompletionBlock:(kCompletionBlock)completionBlock{

    [[BMNetworkHandler sharedInstance] conURL:HK_mallAdvert_getMallAdvert
                                  networkType:NetWorkPOST
                                       params:nil
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

/*
 
 参数名	必选	类型	说明
 userId	是	string	用户Id
 cartType	是	string	购物车类型（01：自营，02：一号店，03：京东）
 cartId	否	String	购物车id 网页订单确认页使用
 imageSize	否	String	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)京东必须传
 */
+ (void)getStoreCartListWithUserId:(NSString *)userId
                          cartType:(NSString *)cartType
                   completionBlock:(kCompletionBlock)completionBlock;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:cartType forKey:@"cartType"];
    if ([cartType integerValue]==3) {
        [params setValue:@"n3" forKey:@"imageSize"];

    }
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_Store_GoodsCartList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 购物车商品加减
/*
 cartId	是	string	购物车Id
 goodsNum	是	string	数量
 */
+ (void)updateGoodsCartWithCartId:(NSString *)cartId
                         goodsNum:(id)goodsNum
                  completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:cartId forKey:@"cartId"];
    [params setValue:goodsNum forKey:@"goodsNum"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_Store_UpdateGoodsCart
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 删除购物车中商品
/*
 cartId	是	string	购物车Id(逗号隔开)
 */
+ (void)delGoodsCartWithCartId:(NSString *)cartId
               completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:cartId forKey:@"cartId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_Store_DelGoodsCart
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 一号店商品列表接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) getProductListWithProductCname:(NSString *)productCname
                                   sort:(NSString *)sort
                             goodsSales:(NSString *)goodsSales
                             priceRange:(NSString *)priceRange
                     categorySearchCode:(NSString *)categorySearchCode
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[KeychainManager readUserId] forKey:@"userId"];
    [params setValue:goodsSales forKey:@"goodsSales"];
    [params setValue:productCname forKey:@"productCname"];
    [params setValue:sort forKey:@"sort"];
    [params setValue:priceRange forKey:@"priceRange"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [params setValue:categorySearchCode forKey:@"categorySearchCode"];

    [[BMNetworkHandler sharedInstance] conURL:HK_yhdProduct_getProductList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 京东商品列表接口
/*
 参数名	必选	类型	说明
 userId	是	string	用户ID 未登录可不传
 name	否	string	商品名称
 category	否	string	类别
 brandName	否	string	品牌
 zkPriceLess	否	string	价格小于等于
 zkPriceGreat	否	string	价格大于等于
 priceOrder	否	string	价格排序（desc降序 asc升序）
 salesVolumeOrder	否	string	销量排序（desc降序 asc升序）
 imageSize	是	string	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 pageIndex	是	string	当前页
 pageSize	是	string	每页条数
 */
+ (void) getJDProductListWithname:(NSString *)name
                             category:(NSString *)category
                              brandName:(NSString *)brandName
                               zkPriceLess:(NSString *)zkPriceLess
                               zkPriceGreat:(NSString *)zkPriceGreat
                             priceOrder:(NSString *)priceOrder
                             salesVolumeOrder:(NSString *)salesVolumeOrder
                              imageSize:(NSString *)imageSize
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                        completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([KeychainManager islogin]) {
        [params setValue:[KeychainManager readUserId] forKey:@"userId"];
    }
    [params setValue:name forKey:@"name"];
    [params setValue:category forKey:@"category"];
    [params setValue:brandName forKey:@"brandName"];
    [params setValue:zkPriceLess forKey:@"zkPriceLess"];
    [params setValue:zkPriceGreat forKey:@"zkPriceGreat"];
    [params setValue:priceOrder forKey:@"priceOrder"];
    [params setValue:salesVolumeOrder forKey:@"salesVolumeOrder"];
    [params setValue:imageSize forKey:@"imageSize"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdProductDetail_productDetailList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 一号店商品详情接口
/*
 userId	是	string	用户id
 productId	是	string	商品id
 productType	是	string	商品类型(0 普通商品 1系列商品)
 */
+ (void) getProductDetailInfoWithUserId:(NSString *)userId
                              productId:(NSString *)productId
                            productType:(NSString *)productType
                        completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (userId.length) {
        [params setValue:userId forKey:@"userId"];
    }
    [params setValue:productId forKey:@"productId"];
    [params setValue:productType forKey:@"productType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdProduct_getProductDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 京东店商品详情接口
/*
 userId	是	string	用户ID 未登录可不传
 sku	否	string	sku
 imageSize	是	string	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 */
+ (void) getJDProductDetailInfoWithUserId:(NSString *)userId
                              sku:(NSString *)sku
                            imageSize:(NSString *)imageSize
                        completionBlock:(kCompletionBlock)completionBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (userId.length) {
        [params setValue:userId forKey:@"userId"];
    }
    [params setValue:sku forKey:@"sku"];
    [params setValue:imageSize forKey:@"imageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yjdProductDetail_getProductDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 一号店订单列表接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) getYhdOrderListWithUserId:(NSString *)userId
                        orderState:(NSString *)orderState
                         pageIndex:(NSString *)pageIndex
                          pageSize:(NSString *)pageSize
                   completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    [params setValue:orderState forKey:@"orderState"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdOrder_getYhdOrderList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark JD订单列表接口
/*
 参数名	必选	类型	说明
 userId	是	string	用户id
 state	是	string	状态 01全部 02待付款03待收货 04已完成 05已取消
 imageSize	是	string	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) getJDOrderListWithUserId:(NSString *)userId
                        state:(NSString *)state
                         pageIndex:(NSString *)pageIndex
                          pageSize:(NSString *)pageSize
                   completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    [params setValue:state forKey:@"state"];
    [params setValue:@"n3" forKey:@"imageSize"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDOrder_getJDOrderList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 一号店订单详情接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) getYhdOrderDetailWithOrderCode:(NSString *)orderCode
                   completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:orderCode forKey:@"orderCode"];
   
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdOrder_getYhdOrderDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark JD店订单详情接口
/*
 
 参数名	必选	类型	说明
 jdOrderId	是	string	用户id
 imageSize	是	string	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 */
+ (void) getJDOrderDetailWithjdOrderId:(NSString *)jdOrderId
                        completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    [params setValue:@"n0" forKey:@"imageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDOrder_getJDOrderDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 一号店取消订单接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) cancelOrderWithOrderCode:(NSString *)orderCode
                  completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:orderCode forKey:@"orderCode"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdOrder_cancelOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark JD取消订单接口
/*
 参数名	必选	类型	说明
 userId	是	string	用户编号
 jdOrderId	是	string	京东订单号
 */
+ (void) cancelJDOrderWithuserId:(NSString *)userId
                           jdOrderId:(NSString *)jdOrderId
                  completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
      [params setValue:jdOrderId forKey:@"jdOrderId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDOrder_cancelJDOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 一号店删除订单接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) deleteOrderWithOrderCode:(NSString *)orderCode
                  completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:orderCode forKey:@"orderCode"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdOrder_deleteOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark JD删除订单接口
/*
 
 参数名	必选	类型	说明
 userId	是	string	用户编号
 jdOrderId	是	string	京东订单号
 */
+ (void) deleteJDOrderWithuserId:(NSString *)userId
                       jdOrderId:(NSString *)jdOrderId
                 completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDOrder_deleteOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 1号店订单物流信息接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) getYhdLogisticsInfoWithOrderCode:(NSString *)orderCode
                          completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:orderCode forKey:@"orderCode"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdOrder_getYhdLogisticsInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 立即支付前调用，判断订单是否取消接口，若订单已取消，则不需要调用支付接口
/*
 productCname	否	string	商品名称
 sort	否	string	排序：1、价格升序，2、价格降序
 pageIndex	是	string	页码
 pageSize	是	string	每页几条
 */
+ (void) checkOrderStatusWithOrderCode:(NSString *)orderCode
                       completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:orderCode forKey:@"orderCode"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdOrder_checkOrderStatus
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark JD立即支付前调用，判断订单是否取消接口，若订单已取消，则不需要调用支付接口
/*
 
 参数名	必选	类型	说明
 userId	是	String
 */
+ (void) checkJDOrderStatusWithuserId:(NSString *)userId
                       completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDOrder_checkOrderStatus
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 1号店1级商品分类列表接口
/*

 */
+ (void) getFirstCategoryListCompletionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_yhdCategory_getFirstCategoryList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark JD1级商品分类列表接口
/*
 
 参数名	必选	类型	说明
 parentId	是	String	父分类ID 一级分类传0
 */
+ (void) getJDFirstCategoryListWithparentId:(NSString*)parentId
        CompletionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:parentId forKey:@"parentId"];
    [[BMNetworkHandler sharedInstance] conURL:HK_JDCategory_getFirstCategoryList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


#pragma mark -
#pragma mark 1号店2级以及3级商品分类列表接口
/*
 参数名 	必选 	类型 	说明
 categoryIdFirst 	是 	string 	1级分类id
 */
+ (void) getSecondCategoryListWithCategoryIdFirst:(NSString *)categoryIdFirst
                                  completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:categoryIdFirst forKey:@"categoryIdFirst"];

    [[BMNetworkHandler sharedInstance] conURL:HK_yhdCategory_getSecondCategoryList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


#pragma mark -
#pragma mark JD2级以及3级商品分类列表接口
/*
 参数名 	必选 	类型 	说明
 categoryIdFirst 	是 	string 	1级分类id
 */
+ (void) getJDSecondCategoryListWithparentId:(NSString *)parentId
                                  completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:parentId forKey:@"parentId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JDCategory_getSecondCategoryList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 自营商品详情接口
/*
 goodsId	是	string	商品Id
 userId	否	string	用户Id
 */
+ (void) goodsGetGoodsDetailWithUserId:(NSString *)userId
                               goodsId:(NSString *)goodsId
                       completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (userId.length) {
        [params setValue:userId forKey:@"userId"];
    }
    [params setValue:goodsId forKey:@"goodsId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getGoodsDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark -
#pragma mark 自营店铺详情接口
/*
 merchantId	是	string	商家id
 userId	否	string	用户Id
 */
+ (void) getMerchantDetailInfoWithUserId:(NSString *)userId
                              merchantId:(NSString *)merchantId
                         completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:merchantId forKey:@"merchantId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_merchant_getMerchantDetailInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark -
#pragma mark 本店主打商品接口
/*
 merchantId	是	string	商家id
 pageIndex	是	string	当前页
 pageSize	否	string	每页条数
 */
+ (void) getGoodsOurMainWithMerchantId:(NSString *)merchantId
                             pageIndex:(NSString *)pageIndex
                              pageSize:(NSString *)pageSize
                                  type:(NSInteger)type
                       completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:merchantId forKey:@"merchantId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    NSString *url=HK_goods_getGoodsOurMain;
    if (type==1)
    {
        url=HK_goods_getGoodsByMerchant;
    }
    [[BMNetworkHandler sharedInstance] conURL:url
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


#pragma mark -
#pragma mark 商品评价接口
/*
 goodsId	是	string	商品id
 pageIndex	是	string	当前页
 pageSize	否	string	每页条数
 */
+ (void) goodsGetGoodsEvaluationWithGoodsId:(NSString *)goodsId
                                  pageIndex:(NSString *)pageIndex
                                   pageSize:(NSString *)pageSize
                            completionBlock:(kCompletionBlock)completionBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:goodsId forKey:@"goodsId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getGoodsEvaluation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 商品分类接口
+ (void) getGoodsClassListCompletionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getGoodsClassList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 推荐商品接口
/*
 参数名 	必选 	类型 	说明
 goodsName 	否 	string 	商品名称
 goodsSales 	否 	string 	销量（0降序 1升序）
 isPrice 	否 	string 	价格（0降序 1升序）
 goodsComment 	否 	string 	好评（0降序 1升序）
 brandId 	否 	string 	品牌id
 marketPrice 	否 	string 	价格区间（0：0-50，1：50-100，2：100-200，3：200-500，4：500以上）
 classOneId 	否 	string 	一级分类Id
 classTwoId 	否 	string 	二级分类Id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 type   是 	string 	0推荐商品接口 1商品搜索接口
 */
+ (void) getRecommendGoodsWithgoodsName:(NSString *)goodsName
                             goodsSales:(NSString *)goodsSales
                                isPrice:(NSString *)isPrice
                           goodsComment:(NSString *)goodsComment
                                brandId:(NSString *)brandId
                            marketPrice:(NSString *)marketPrice
                             classOneId:(NSString *)classOneId
                             classTwoId:(NSString *)classTwoId
                           classThridId:(NSString *)classThridId
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                                   type:(NSString *)type
                             merchantId:(NSString *)merchantId
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:goodsName forKey:@"goodsName"];
    [params setValue:goodsSales forKey:@"goodsSales"];
    [params setValue:isPrice forKey:@"isPrice"];
    [params setValue:goodsComment forKey:@"goodsComment"];
    [params setValue:brandId forKey:@"brandId"];
    [params setValue:marketPrice forKey:@"marketPrice"];
    [params setValue:classOneId forKey:@"classOneId"];
    [params setValue:classTwoId forKey:@"classTwoId"];
    [params setValue:classThridId forKey:@"classThridId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    NSString *conURL=HK_goods_getRecommendGoods;
    if ([type isEqualToString:@"1"])
    {
        [params setValue:merchantId forKey:@"merchantId"];
        conURL=HK_goods_getSearchGoodsList;
    }
    [[BMNetworkHandler sharedInstance] conURL:conURL
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 自营店铺列表接口
/*
 merchantName 	否 	string 	商家名称
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getMerchantInfoWithMerchantName:(NSString *)merchantName
                               pageIndex:(NSString *)pageIndex
                                pageSize:(NSString *)pageSize
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:merchantName forKey:@"merchantName"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_merchant_getMerchantInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 获取商品一级分类接口
/*
 */
+ (void) getGoodsClassFirstCompletionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getGoodsClassFirst
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark 自营商品订单详情接口
/*
 orderCode 	是 	string 	订单号
 */
+ (void) getGoodsOrderDetailWithOrderCode:(NSString *)orderCode
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getGoodsOrderDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 更新订单状态
/*
 orderCode 	是 	string 	订单号
 orderFlag 	是 	string 	类型（01：取消订单 ，02：确认收货，03：删除订单）
 */
+ (void) changeOrderStatusWithOrderCode:(NSString *)orderCode
                              orderFlag:(NSString *)orderFlag
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:orderFlag forKey:@"orderFlag"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_changeOrderStatus
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 申请退款接口
/*
 orderCode 	是 	string 	订单号
 goodsId 	是 	string 	商品id
 goodsName 	是 	string 	商品名称
 goodsPrice 	是 	string 	商品价格
 goodsNum 	是 	string 	商品数量
 merchantId 	是 	string 	商家id
 merchantName 	是 	string 	商家名称
 refundReason 	是 	string 	退款原因 （01：商品质量问题 ，02：卖家发错货 ，03：其他）
 refundMessage 	否 	string 	退款备注
 userId 	是 	string 	用户id
 userName 	是 	string 	用户账号
 imagesPath 	否 	string 	图片
 */
+ (void) returnOrderWithOrderCode:(NSString *)orderCode
                        orderType:(NSString *)orderType
                          goodsId:(NSString *)goodsId
                        goodsName:(NSString *)goodsName
                       goodsPrice:(NSString *)goodsPrice
                         goodsNum:(NSString *)goodsNum
                       merchantId:(NSString *)merchantId
                     merchantName:(NSString *)merchantName
                     refundReason:(NSString *)refundReason
                    refundMessage:(NSString *)refundMessage
                           userId:(NSString *)userId
                         userName:(NSString *)userName
                       imagesPath:(NSArray *)imagesPath
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:orderType forKey:@"orderType"];
    [params setValue:goodsId forKey:@"goodsId"];
    [params setValue:goodsName forKey:@"goodsName"];
    [params setValue:goodsPrice forKey:@"goodsPrice"];
    [params setValue:goodsNum forKey:@"goodsNum"];
    [params setValue:merchantId forKey:@"merchantId"];
    [params setValue:merchantName forKey:@"merchantName"];
    [params setValue:refundReason forKey:@"refundReason"];
    [params setValue:refundMessage forKey:@"refundMessage"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];

    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:imagesPath  forKey:@"imagesPath"];
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_returnOrder
                                  networkType:NetWorkPOST
                                       params:params
                                       images:dic
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 商品评价接口
/*
 orderCode 	是 	string 	订单号
 merchantId 	是 	string 	商家id
 merchantName 	是 	string 	商家名称
 userId 	是 	string 	用户id
 userName 	是 	string 	用户账号
 evaluateList 	是 	string 	评价集合 （对应一下json）
 */
+ (void) addGoodsEvaluateWithOrderCode:(NSString *)orderCode
                            merchantId:(NSString *)merchantId
                          merchantName:(NSString *)merchantName
                                userId:(NSString *)userId
                              userName:(NSString *)userName
                          evaluateList:(NSString *)evaluateList
                       completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:merchantId forKey:@"merchantId"];
    [params setValue:merchantName forKey:@"merchantName"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:evaluateList forKey:@"evaluateList"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_addGoodsEvaluate
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 我的收藏（商品）接口
/*
 userId 	是 	string 	用户id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getGoodsCollectWithUserId:(NSString *)userId
                         pageIndex:(NSString *)pageIndex
                          pageSize:(NSString *)pageSize
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getGoodsCollect
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark 我的收藏（JD商品）接口
/*
 
 参数名	必选	类型	说明
 userId	是	string	用户ID 未登录可不传
 imageSize	是	string	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 pageIndex	是	string	当前页
 pageSize	是	string	每页条数
 */
+ (void) getJDGoodsCollectWithUserId:(NSString *)userId
                         pageIndex:(NSString *)pageIndex
                          pageSize:(NSString *)pageSize
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:@"n4" forKey:@"imageSize"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getJDGoodsCollect
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark 我的收藏（商家）接口
/*
 userId 	是 	string 	用户id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getMerchantInfoCollectWithUserId:(NSString *)userId
                                pageIndex:(NSString *)pageIndex
                                 pageSize:(NSString *)pageSize
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getMerchantInfoCollect
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 我的收藏（资讯）接口
/*
 userId 	是 	string 	用户id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getHealthCollectWithUserId:(NSString *)userId
                          pageIndex:(NSString *)pageIndex
                           pageSize:(NSString *)pageSize
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getHealthCollect
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 查看物流接口
/*
 com 	是 	string 	快递公司代码
 num 	是 	string 	快递单号
 */
+ (void) getLogisticsInfoWithCom:(NSString *)com
                             num:(NSString *)num
                 completionBlock:(kCompletionBlock)completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:com forKey:@"com"];
    [params setValue:num forKey:@"num"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getLogisticsInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 获取积分明细接口
/*
 userId 	是 	string 	用户id
 pageIndex 	是 	string 	当前页
 pageSize 	否 	string 	每页条数
 */
+ (void) getIntegralDetailWithUserId:(NSString *)userId
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getIntegralDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}


#pragma mark 积分兑换接口
/*
 userId 	是 	string 	用户id
 point 	是 	string 	兑换的积分

 */
+ (void) getIntegraljifenWithUserId:(NSString *)userId
                           point:(NSString *)point
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:point forKey:@"point"];;
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getIntegraljifen
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark 退款订单列表接口
/*
 userId 	是 	string 	用户id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getReturnOrderWithUserId:(NSString *)userId
                        pageIndex:(NSString *)pageIndex
                         pageSize:(NSString *)pageSize
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getReturnOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
 
}

#pragma mark 删除售后订单记录接口
/*
 id 	是 	string 	退货单号
 */
+ (void) deleteReturnOrderWithOrderId:(NSString *)OrderId
                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:OrderId forKey:@"id"];
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_deleteReturnOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 填写快递单号信息接口
/*
 id 	是 	string 	退货单号
 deliveryCompanyName 	是 	string 	快递公司名称
 deliverySn 	否 	string 	快递单号
 */
+ (void) updateReturnOrderWithOrderId:(NSString *)OrderId
                  deliveryCompanyName:(NSString *)deliveryCompanyName
                           deliverySn:(NSString *)deliverySn
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:OrderId forKey:@"id"];
    [params setValue:deliveryCompanyName forKey:@"deliveryCompanyName"];
    [params setValue:deliverySn forKey:@"deliverySn"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_updateReturnOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 团购列表接口
/*
 flag 	是 	string 	类型（首页传此字段，其他页面不传此字段）
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getGroupGoodsWithFlag:(NSString *)flag
                     pageIndex:(NSString *)pageIndex
                      pageSize:(NSString *)pageSize
               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:flag forKey:@"flag"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_groupGoods_getGroupGoods
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 团购详情接口
/*
 goodsId 	是 	string 	商品Id
 */
+ (void) getGroupGoodsDetailWithGoodsId:(NSString *)goodsId
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:goodsId forKey:@"goodsId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_groupGoods_getGroupGoodsDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 提交订单并支付
/*
 userId 	是 	string 	用户Id
 userName 	是 	string 	买家姓名
 addressId 	是 	string 	收货Id
 orderList 	是 	string 	json集合（对应下面格式）
 payMent 	是 	string 	支付方式（01：支付宝, 02：微信 , 03：钱包支付）
 */
+ (void) addGroupGoodsOrderWithUserId:(NSString *)userId
                             userName:(NSString *)userName
                            addressId:(NSString *)addressId
                            orderList:(NSString *)orderList
                              payMent:(NSString *)payMent
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:addressId forKey:@"addressId"];
    [params setValue:orderList forKey:@"orderList"];
    [params setValue:payMent forKey:@"payMent"];
    params=[DES3Util getSecrityForString:params];//加密
    [[BMNetworkHandler sharedInstance] conURL:HK_groupGoods_addGroupGoodsOrder
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}


#pragma mark 团购订单列表接口
/*
 userId 	是 	string 	用户Id
 orderState 	是 	string 	状态（全部传空或者null，04：待发货，05：待收货 ， 06：已完成 ）
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */
+ (void) getGroupGoodsOrderListWithUserId:(NSString *)userId
                               orderState:(NSString *)orderState
                                pageIndex:(NSString *)pageIndex
                                 pageSize:(NSString *)pageSize
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:orderState forKey:@"orderState"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_groupGoods_getGroupGoodsOrderList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 团购订单详情接口
/*
 orderCode 	是 	string 	订单号
 */
+ (void) getGroupGoodsOrderDetailWithOrderCode:(NSString *)orderCode
                               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
 
    
    [[BMNetworkHandler sharedInstance] conURL:HK_groupGoods_getGroupGoodsOrderDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark 修改订单状态接口
/*
 orderCode 	是 	string 	订单号
 orderFlag 	是 	string 	类型（01：确认收货，02：删除订单）
 */
+ (void) changeGroupOrderStatusWithOrderCode:(NSString *)orderCode
                                   orderFlag:(NSString *)orderFlag
                             completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:orderFlag forKey:@"orderFlag"];

    
    [[BMNetworkHandler sharedInstance] conURL:HK_groupGoods_changeGroupOrderStatus
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 获取购物车总数量接口
/*
 userId 	是 	string 	用户Id
 */
+ (void) getGoodsCartNumWithUserId:(NSString *)userId
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_goodsCart_getGoodsCartNum
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 获取分类名称信息接口
/*
 classOneId 	是 	string 	一级分类id
 classTwoId 	否 	string 	二级分类id
 classThridId 	否 	string 	三级分类id
 */
+ (void) getCategoryNameWithClassOneId:(NSString *)classOneId
                            classTwoId:(NSString *)classTwoId
                          classThridId:(NSString *)classThridId
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:classOneId forKey:@"classOneId"];
    [params setValue:classTwoId forKey:@"classTwoId"];
    [params setValue:classThridId forKey:@"classThridId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getCategoryName
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark 获取品牌列表接口
/*
 参数名 	必选 	类型 	说明
 flag 	否 	string 	类型（传01获取前三条，其他则获取所有品牌）
 */
+ (void) getBrandListWithFlag:(NSString *)flag
                   classOneId:(NSString *)classOneId
                   classTwoId:(NSString *)classTwoId
                 classThridId:(NSString *)classThridId
                    goodsName:(NSString *)goodsName
              completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:flag forKey:@"flag"];
    [params setValue:classOneId forKey:@"classOneId"];
    [params setValue:classTwoId forKey:@"classTwoId"];
    [params setValue:classThridId forKey:@"classThridId"];
    [params setValue:goodsName forKey:@"goodsName"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getBrandList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－－－－－－－－－－－－－－－－－－车辆限号接口－－－－－－－－－－－－－－－－－－
+ (void) getLimitLicenseWithCompletionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [[BMNetworkHandler sharedInstance] conURL:HK_zkUser_getLimitLicense
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－－－－－－－－－－－－－－－－－－健康模块－－－－－－－－－－－－－－－－－－

#pragma mark-- 症状自测接口
/*
 bodyName 	否 	string 	身体部位
 */
+ (void) getSymptomsListWithBodyName:(NSString *)bodyName
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:bodyName forKey:@"bodyName"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_symptomsClass_getSymptomsList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark-- 可能患病列表接口
/*
 symptomsId 	是 	string 	症状Id
 */
+ (void) getDiseaseInfoWithSymptomsId:(NSString *)symptomsId
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:symptomsId forKey:@"symptomsId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_symptomsClass_getDiseaseInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];


}

#pragma mark-- 身体情况自测
/*
 userId 	是 	string 	用户编号
 userName 	是 	string 	用户名称
 sex 	是 	string 	性别：01、男，02、女
 height 	是 	string 	身高，单位cm
 age 	是 	string 	年龄
 weight 	是 	string 	体重，单位kg
 diabetesFlg 	是 	string 	糖尿病标识，0、否，1、是
 heartDiseaseFlg 	是 	string 	心脏病标识，0、否，1、是
 hypertensionFlg 	是 	string 	高血压标识，0、否，1、是
 hypopiesiaFlg 	是 	string 	低血压标识，0、否，1、是
 glucopeniaFlg 	是 	string 	低血糖标识，0、否，1、是
 noDiseaseFlg 	是 	string 	无疾病标识，0、否，1、是
 walkFlg 	是 	string 	散步标识，0、否，1、是
 joggingFlg 	是 	string 	慢跑标识，0、否，1、是
 swimmingFlg 	是 	string 	游泳标识，0、否，1、是
 trackFlg 	是 	string 	田径标识，0、否，1、是
 basketballFlg 	是 	string 	篮球标识，0、否，1、是
 bicycleFlg 	是 	string 	自行车标识，0、否，1、是
 ridingHorseFlg 	是 	string 	骑马标识，0、否，1、是
 badmintonFlg 	是 	string 	羽毛球标识，0、否，1、是
 golfFlg 	是 	string 	高尔夫标识，0、否，1、是
 footballFlg 	是 	string 	足球标识，0、否，1、是
 jumpFlg 	是 	string 	跳绳标识，0、否，1、是
 squashFlg 	是 	string 	壁球标识，0、否，1、是
 tennisFlg 	是 	string 	网球标识，0、否，1、是
 tableTennisFlg 	是 	string 	乒乓球标识，0、否，1、是
 volleyballFlg 	是 	string 	排球标识，0、否，1、是
 sportsRate 	是 	string 	每周运动频率，01、从不运动，02、一次，03、二至三次，04、三次以上
 */
+ (void) saveBodySelfCheckWithUserId:(NSString *)userId
                            userName:(NSString *)userName
                                 sex:(NSString *)sex
                              height:(NSString *)height
                                 age:(NSString *)age
                              weight:(NSString *)weight
                         diabetesFlg:(NSString *)diabetesFlg
                     heartDiseaseFlg:(NSString *)heartDiseaseFlg
                     hypertensionFlg:(NSString *)hypertensionFlg
                       hypopiesiaFlg:(NSString *)hypopiesiaFlg
                       glucopeniaFlg:(NSString *)glucopeniaFlg
                        noDiseaseFlg:(NSString *)noDiseaseFlg
                             walkFlg:(NSString *)walkFlg
                          joggingFlg:(NSString *)joggingFlg
                         swimmingFlg:(NSString *)swimmingFlg
                            trackFlg:(NSString *)trackFlg
                       basketballFlg:(NSString *)basketballFlg
                          bicycleFlg:(NSString *)bicycleFlg
                      ridingHorseFlg:(NSString *)ridingHorseFlg
                        badmintonFlg:(NSString *)badmintonFlg
                             golfFlg:(NSString *)golfFlg
                         footballFlg:(NSString *)footballFlg
                             jumpFlg:(NSString *)jumpFlg
                           squashFlg:(NSString *)squashFlg
                           tennisFlg:(NSString *)tennisFlg
                      tableTennisFlg:(NSString *)tableTennisFlg
                       volleyballFlg:(NSString *)volleyballFlg
                          sportsRate:(NSString *)sportsRate
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:sex forKey:@"sex"];
    [params setValue:height forKey:@"height"];
    [params setValue:age forKey:@"age"];
    [params setValue:weight forKey:@"weight"];
    [params setValue:diabetesFlg forKey:@"diabetesFlg"];
    [params setValue:heartDiseaseFlg forKey:@"heartDiseaseFlg"];
    [params setValue:hypertensionFlg forKey:@"hypertensionFlg"];
    [params setValue:hypopiesiaFlg forKey:@"hypopiesiaFlg"];
    [params setValue:glucopeniaFlg forKey:@"glucopeniaFlg"];
    [params setValue:noDiseaseFlg forKey:@"noDiseaseFlg"];
    [params setValue:walkFlg forKey:@"walkFlg"];
    [params setValue:joggingFlg forKey:@"joggingFlg"];
    [params setValue:swimmingFlg forKey:@"swimmingFlg"];
    [params setValue:trackFlg forKey:@"trackFlg"];
    [params setValue:basketballFlg forKey:@"basketballFlg"];
    [params setValue:bicycleFlg forKey:@"bicycleFlg"];
    [params setValue:ridingHorseFlg forKey:@"ridingHorseFlg"];
    [params setValue:badmintonFlg forKey:@"badmintonFlg"];
    [params setValue:golfFlg forKey:@"golfFlg"];
    [params setValue:footballFlg forKey:@"footballFlg"];
    [params setValue:jumpFlg forKey:@"jumpFlg"];
    [params setValue:squashFlg forKey:@"squashFlg"];
    [params setValue:tennisFlg forKey:@"tennisFlg"];
    [params setValue:tableTennisFlg forKey:@"tableTennisFlg"];
    [params setValue:volleyballFlg forKey:@"volleyballFlg"];
    [params setValue:sportsRate forKey:@"sportsRate"];

    [[BMNetworkHandler sharedInstance] conURL:HK_bodySelfCheck_saveBodySelfCheck
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark-- 开启健身计划
/*
 userId 	是 	string 	用户编号
 userName 	是 	string 	用户名称
 */
+ (void) saveFitnessPlanWithUserId:(NSString *)userId
                          userName:(NSString *)userName
                   completionBlock:(kCompletionBlock)completionBlock
{
 
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_saveFitnessPlan
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark-- 判断是否有未完成的健身计划
/*
userId 	是 	string 	用户编号
 */
+ (void) getLastFitnessPlanWithUserId:(NSString *)userId
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_getLastFitnessPlan
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark-- 重置健身计划
/*
 id 	是 	string 	健身计划编号
 */
+ (void) resetFitnessPlanWithFitnessId:(NSString *)fitnessId
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fitnessId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_resetFitnessPlan
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark-- 健身计划详情
/*
 fitnessId 	是 	string 	健身计划编号
 */
+ (void) getFitnessPlanDetailWithFitnessId:(NSString *)fitnessId
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fitnessId forKey:@"fitnessId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_getFitnessPlanDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark-- 每日健身情况接口新
/*
 userId	是	string	用户Id
 startTime	是	string	开始时间
 endTime	是	string	结束时间
 pageIndex	否	string	当前页
 pageSize	否	string	每页条数
 */
+ (void) getStepNumListWithUserId:(NSString *)userId
                         startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:startTime forKey:@"startTime"];
    [params setValue:endTime forKey:@"endTime"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_watchInfo_getStepNumList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark-- 获取用户健身情况列表
/*
 userId	是	string	用户Id
 startTime	是	string	开始时间
 endTime	是	string	结束时间

 */
+ (void) getFitnessPlanDetailListWithUserId:(NSString *)userId
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime

                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:startTime forKey:@"startTime"];
    [params setValue:endTime forKey:@"endTime"];
  
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_getFitnessPlanDetailList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark-- 获取心率列表
/*
 userId	是	string	用户Id
 startTime	是	string	开始时间
 endTime	是	string	结束时间
 
 */
+ (void) getHeartRateListListWithUserId:(NSString *)userId
                                  time:(NSString *)time

                            completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:time forKey:@"time"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_watchInfo_getHeartRateList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark-- 每日健身情况接口
/*
 userId 	是 	string 	用户Id
 fitnessDate 	是 	string 	时间
 pageIndex 	否 	string 	当前页
 pageSize 	否 	string 	每页条数
 */
+ (void) getDayFitnessPlanWithUserId:(NSString *)userId
                         fitnessDate:(NSString *)fitnessDate
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:fitnessDate forKey:@"fitnessDate"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitness_getDayFitnessPlan
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark-- 健身计划页面信息
/*
 userId 	是 	string 	用户编号
 */
+ (void) fitnessPlanWithUserId:(NSString *)userId
               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:[KeychainManager readNickName] forKey:@"userName"];

    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_fitnessPlan
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark-- 删除今日健身智能计划
/*
id：运动计划编号，fitnessPlanId：健身计划编号
 */
+ (void) deleteSportsPlanWithId:(NSString *)planId
                  fitnessPlanId:(NSString *)fitnessPlanId
                           flag:(NSString *)flag
                completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:planId forKey:@"id"];
    [params setValue:fitnessPlanId forKey:@"fitnessPlanId"];

    NSString *url=HK_sportsPlan_deleteSportsPlan;
    if ([flag integerValue]==2) {
        url=HK_sportsPlan_deleteCustomSportsPlan;
    }
    [[BMNetworkHandler sharedInstance] conURL:url
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark-- 手动添加今日消耗卡路里接口
/*
 userId 	是 	string 	用户id
 userName 	是 	string 	用户名称
 fitnessPlanId 	是 	string 	健身计划编号
 sportsName 	是 	String 	运动项目 01：散步 02：慢跑 03：游泳 04：田径:05：篮球06：自行车 07：骑马 08：滑雪 09：高尔夫 10：滑旱冰11：跳绳 12：壁球 13：网球 14：乒乓球 15：排球
 sportsTime 	是 	String 	运动时间
 targetCalorie 	是 	String 	目标卡路里
 */
+ (void) insertSportsPlanWithUserId:(NSString *)userId
                           userName:(NSString *)userName
                      fitnessPlanId:(NSString *)fitnessPlanId
                         sportsName:(NSString *)sportsName
                         sportsTime:(NSString *)sportsTime
                      targetCalorie:(NSString *)targetCalorie
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:fitnessPlanId forKey:@"fitnessPlanId"];
    [params setValue:sportsName forKey:@"sportsName"];
    [params setValue:sportsTime forKey:@"sportsTime"];
    [params setValue:targetCalorie forKey:@"targetCalorie"];

    [[BMNetworkHandler sharedInstance] conURL:HK_sportsPlan_insertSportsPlan
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark-- 历史健身
/*
 userId 	是 	string 	用户编号
 pageIndex 	是 	string 	页码
 pageSize 	是 	string 	每页几条
 */
+ (void) getHistoryFitnessWithUserId:(NSString *)userId
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_getHistoryFitness
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark-- 查看喜爱的运动
/*
 身体编号 bodyId
 */
+ (void) getFavoriteSportsWithBodyId:(NSString *)bodyId
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:bodyId forKey:@"bodyId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_bodySelfCheck_getBodyInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark-- 重置喜爱的运动
/*
 id 	是 	string 	身体情况编号
 userId 	是 	string 	用户编号
 userName 	是 	string 	用户名称
 fitnessPlanId 	是 	string 	健身计划编号
 walkFlg 	是 	string 	散步标识，0、否，1、是
 joggingFlg 	是 	string 	慢跑标识，0、否，1、是
 swimmingFlg 	是 	string 	游泳标识，0、否，1、是
 trackFlg 	是 	string 	田径标识，0、否，1、是
 basketballFlg 	是 	string 	篮球标识，0、否，1、是
 bicycleFlg 	是 	string 	自行车标识，0、否，1、是
 ridingHorseFlg 	是 	string 	骑马标识，0、否，1、是
 badmintonFlg 	是 	string 	羽毛球标识，0、否，1、是
 golfFlg 	是 	string 	高尔夫标识，0、否，1、是
 footballFlg 	是 	string 	足球标识，0、否，1、是
 jumpFlg 	是 	string 	跳绳标识，0、否，1、是
 squashFlg 	是 	string 	壁球标识，0、否，1、是
 tennisFlg 	是 	string 	网球标识，0、否，1、是
 tableTennisFlg 	是 	string 	乒乓球标识，0、否，1、是
 volleyballFlg 	是 	string 	排球标识，0、否，1、是
 */
+ (void) resetSportsWithUserId:(NSString *)userId
                        bodyId:(NSString *)bodyId
                      userName:(NSString *)userName
                 fitnessPlanId:(NSString *)fitnessPlanId
                       walkFlg:(NSString *)walkFlg
                    joggingFlg:(NSString *)joggingFlg
                   swimmingFlg:(NSString *)swimmingFlg
                      trackFlg:(NSString *)trackFlg
                 basketballFlg:(NSString *)basketballFlg
                    bicycleFlg:(NSString *)bicycleFlg
                ridingHorseFlg:(NSString *)ridingHorseFlg
                  badmintonFlg:(NSString *)badmintonFlg
                       golfFlg:(NSString *)golfFlg
                   footballFlg:(NSString *)footballFlg
                       jumpFlg:(NSString *)jumpFlg
                     squashFlg:(NSString *)squashFlg
                     tennisFlg:(NSString *)tennisFlg
                tableTennisFlg:(NSString *)tableTennisFlg
                 volleyballFlg:(NSString *)volleyballFlg
               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:bodyId forKey:@"id"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:fitnessPlanId forKey:@"fitnessPlanId"];

    [params setValue:walkFlg forKey:@"walkFlg"];
    [params setValue:joggingFlg forKey:@"joggingFlg"];
    [params setValue:swimmingFlg forKey:@"swimmingFlg"];
    [params setValue:trackFlg forKey:@"trackFlg"];
    [params setValue:basketballFlg forKey:@"basketballFlg"];
    [params setValue:bicycleFlg forKey:@"bicycleFlg"];
    [params setValue:ridingHorseFlg forKey:@"ridingHorseFlg"];
    [params setValue:badmintonFlg forKey:@"badmintonFlg"];
    [params setValue:golfFlg forKey:@"golfFlg"];
    [params setValue:footballFlg forKey:@"footballFlg"];
    [params setValue:jumpFlg forKey:@"jumpFlg"];
    [params setValue:squashFlg forKey:@"squashFlg"];
    [params setValue:tennisFlg forKey:@"tennisFlg"];
    [params setValue:tableTennisFlg forKey:@"tableTennisFlg"];
    [params setValue:volleyballFlg forKey:@"volleyballFlg"];

    [[BMNetworkHandler sharedInstance] conURL:HK_bodySelfCheck_resetSports
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark-- 查看报告
/*
 id 	是 	string 	健身计划编号
 */
+ (void) getFitnessDetailWithFitnessId:(NSString *)fitnessId
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fitnessId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_fitnessPlan_getFitnessDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－支付宝微信相关配置
/*
 id 	是 	string 	订单号
 orderType 	否 	string 	订单类型：01、订座订单，02、外卖订单， 03、自营商城多个商家合并支付 ，04、1号店订单， 05、团购商品，06、自营商品我的订单页面进入
 */
+ (void) wxPayinfoWithOrderId:(NSString *)orderId
                    orderType:(NSString *)orderType
              completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderId forKey:@"id"];
    [params setValue:orderType forKey:@"orderType"];

    [[BMNetworkHandler sharedInstance] conURL:HK_payMent_wxPayinfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－支付宝微信相关配置
/*
 orderType 	否 	string 	订单类型：01、订座订单，02、外卖订单， 03、自营商城多个商家合并支付 ，04、1号店订单， 05、团购商品，06、自营商品我的订单页面进入
 */
+ (void) payInfoSettingWithOrderType:(NSString *)orderType
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderType forKey:@"orderType"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_payMent_payInfoSetting
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－动态获取支付方式接口
+ (void) getPayTypeWithOrderCode:(NSString *)orderCode
                            flag:(NSString *)flag
                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:flag forKey:@"flag"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getPayType
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－订单确认页面享受优惠信息接口

//参数名 	必选 	类型 	说明
//merchantId 	是 	string 	商家id (多个商家逗号隔开)
//flag 	是 	string 	01:订餐 02：购物（不含1号店） 03：团购
//goodAmount 	是 	string 	商品总价

+ (void) getOrderPayTypeWithMerchantId:(NSString *)merchantId
                            goodAmount:(NSString *)goodAmount
                                  flag:(NSString *)flag
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:merchantId forKey:@"merchantId"];
    [params setValue:goodAmount forKey:@"goodAmount"];
    [params setValue:flag forKey:@"flag"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goodsOrder_getOrderPayType
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝社区＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#pragma mark－－我的社群接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

+ (void) getAssociationUserWithUserId:(NSString *)userId
                            pageIndex:(NSString *)pageIndex
                             pageSize:(NSString *)pageSize
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getAssociationUser
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－社群管理接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

+ (void) getMyAssociationWithUserId:(NSString *)userId
                          pageIndex:(NSString *)pageIndex
                           pageSize:(NSString *)pageSize
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getMyAssociation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－加入更多社群--分类接口
+ (void) getAssociationClassWithCompletionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getAssociationClass
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－加入更多社群--列表接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//classId 	否 	string 	分类id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

+ (void) getAssociationListWithuserId:(NSString *)userId
                              classId:(NSString *)classId
                            pageIndex:(NSString *)pageIndex
                             pageSize:(NSString *)pageSize
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:classId forKey:@"classId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getAssociationList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－查看成员--拉黑成员接口
//参数名 	必选 	类型 	说明

//associationId 	否 	string 社群id
//userId 	是 	string 	用户Id
+ (void) getDeleteMemberListWithAssociationId:(NSString *)associationId
                                 userId:(NSString *)userId
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_deleteMemberList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark－－查看成员--成员列表接口

//参数名 	必选 	类型 	说明

//associationId 	否 	string 社群id

//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

+ (void) getMemberListWithAssociationId:(NSString *)associationId
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getMemberList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－加入社群接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//userName 	是 	string 	账号
//associationId 	是 	string 	社群id

+ (void) addAssociationWithuserId:(NSString *)userId
                         userName:(NSString *)userName
                    associationId:(NSString *)associationId
                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:associationId forKey:@"associationId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_addAssociation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－社区活动接口
//参数名 	必选 	类型 	说明
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

+ (void) getCommunityActiviyWithpageIndex:(NSString *)pageIndex
                                 pageSize:(NSString *)pageSize
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_community_getCommunityActiviy
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－社区活动详情接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	活动id

+ (void) getCommunityActiviyDetailWithActiviyId:(NSString *)activiyId
                                completionBlock:(kCompletionBlock)completionBlock

{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:activiyId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_community_getCommunityActiviyDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－在线报名接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	活动id
//userName 	是 	string 	用户姓名
//mobileNum 	否 	string 	手机号

+ (void) communityActivityApplyWithActiviyId:(NSString *)activiyId
                                    userName:(NSString *)userName
                                   mobileNum:(NSString *)mobileNum
                             completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:activiyId forKey:@"id"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:mobileNum forKey:@"mobileNum"];

    [[BMNetworkHandler sharedInstance] conURL:HK_community_communityActivityApply
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－社群管理接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id

+ (void) getMyAssociationWithuserId:(NSString *)userId
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getMyAssociation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}



#pragma mark－－添加编辑社群条款接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id
//associationProvision 	是 	string 	条款内容

+ (void) editAssociationWithassociationId:(NSString *)associationId
                     associationProvision:(NSString *)associationProvision
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:associationProvision forKey:@"associationProvision"];

    [[BMNetworkHandler sharedInstance] conURL:HK_association_editAssociation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－社群申请列表接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id

+ (void) getAssociationUserApplyWithassociationId:(NSString *)associationId
                                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_getAssociationUserApply
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－申请同意或拒绝接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id
//userId 	是 	string 	申请加群的用户Id
//flag 	否 	string 	类型（02：拒绝，03：同意）

+ (void) applyAssociationUserWithassociationId:(NSString *)associationId
                                        userId:(NSString *)userId
                                          flag:(NSString *)flag
                               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:flag forKey:@"flag"];

    [[BMNetworkHandler sharedInstance] conURL:HK_association_applyAssociationUser
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－发布话题接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id
//topicTitle 	是 	string 	标题
//topicContent 	是 	string 	内容
//userId 	是 	string 	用户id
//userName 	是 	string 	用户姓名
//imagesPath 	是 	string 	图片

+ (void) addTopicWithassociationId:(NSString *)associationId
                        topicTitle:(NSString *)topicTitle
                      topicContent:(NSString *)topicContent
                            userId:(NSString *)userId
                          userName:(NSString *)userName
                        imagesPath:(NSArray *)imagesPath
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:topicTitle forKey:@"topicTitle"];
    [params setValue:topicContent forKey:@"topicContent"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    
    NSMutableDictionary *imageDic=[[NSMutableDictionary alloc]init];
    NSArray *imagespathArr=@[@"imagesPathOne",@"imagesPathTwo",@"imagesPathThree",@"imagesPathFour",];
    for (int i=0; i<imagesPath.count; i++)
    {
         [imageDic setValue:@[imagesPath[i]] forKey:imagespathArr[i]];
    }
    
    [[BMNetworkHandler sharedInstance] conURL:HK_topic_addTopic
                                  networkType:NetWorkPOST
                                       params:params
                                       images:imageDic
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}



#pragma mark－－话题列表接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id
//pageIndex 	是 	string 	当前页
//pageSize 	否 	string 	每页条数

+ (void) getTopicListWithassociationId:(NSString *)associationId
                             pageIndex:(NSString *)pageIndex
                              pageSize:(NSString *)pageSize
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_topic_getTopicList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－话题详情接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	话题id
+ (void) getTopicDetailWithassociationId:(NSString *)associationId
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"id"];
    [params setValue:[KeychainManager readUserId] forKey:@"userId"];

    
    [[BMNetworkHandler sharedInstance] conURL:HK_topic_getTopicDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}



#pragma mark－－话题评价列表接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	话题id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数
+ (void) getTopicEvaluateWithassociationId:(NSString *)associationId
                                 pageIndex:(NSString *)pageIndex
                                  pageSize:(NSString *)pageSize
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"id"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_topic_getTopicEvaluate
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－发表评论接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	话题id
//userId 	是 	string 	用户id
//userName 	是 	string 	姓名
//evalContent 	是 	string 	评论内容
+ (void) addTopicEvaluateWithassociationId:(NSString *)associationId
                                    userId:(NSString *)userId
                                  userName:(NSString *)userName
                               evalContent:(NSString *)evalContent
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:evalContent forKey:@"evalContent"];

    [[BMNetworkHandler sharedInstance] conURL:HK_topic_addTopicEvaluate
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－删除话题接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	话题id
//userId 	是 	string 	用户id
+ (void) delTopicWithassociationId:(NSString *)associationId
                            userId:(NSString *)userId
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_topic_delTopic
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}



#pragma mark－－删除用户评论接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	话题id
//userId 	是 	string 	用户id
//evalId 	否 	string 	评论id
+ (void) delTopicEvaluateWithassociationId:(NSString *)associationId
                                    userId:(NSString *)userId
                                    evalId:(NSString *)evalId
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:evalId forKey:@"evalId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_topic_delTopicEvaluate
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark－－拉黑用户接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	话题Id
//userId 	是 	string 	当前用户id
//publishUserId 	否 	string 	拉黑用户id
+ (void) delAssociationUserWithassociationId:(NSString *)associationId
                                      userId:(NSString *)userId
                               publishUserId:(NSString *)publishUserId
                             completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:publishUserId forKey:@"publishUserId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_topic_delAssociationUser
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark－－社群申请列表接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id
+ (void) getAssociationUserApplyWithAssociationId:(NSString *)associationId
                                        pageIndex:(NSString *)pageIndex
                                         pageSize:(NSString *)pageSize
                                  completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_association_getAssociationUserApply
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－社群申请列表接口
//参数名 	必选 	类型 	说明
//associationId 	是 	string 	社群id
//userId 	是 	string 	申请加群的用户Id
//flag 	是 	string 	类型（02：拒绝，03：同意）
+ (void) applyAssociationUserWithAssociationId:(NSString *)associationId
                                        userId:(NSString *)userId
                                          flag:(NSString *)flag
                               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:associationId forKey:@"associationId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:flag forKey:@"flag"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_association_applyAssociationUser
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－获取最新版本信息
//参数名 	必选 	类型 	说明
//platformType 	是 	string 	平台类型：01、ios,02、安卓
//type 	否 	string 	版本类型：1、消费者端，2、物业工作人员端(安卓传此参数)
+ (void) upVersionWithcompletionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"01" forKey:@"platformType"];
    [params setValue:@"1" forKey:@"type"];
    [[BMNetworkHandler sharedInstance] conURL:HK_version_version
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－－－－－－－－－－－－－－－－－－物业模块－－－－－－－－－－－－－－－－－－

#pragma mark－－获取所有小区信息接口
//参数名 	必选 	类型 	说明
//provinceId 	否 	string 	省Id
//cityId 	否 	string 	城市id
//countyId 	否 	string 	区id
+ (void) getDistrictListWithProvinceId:(NSString *)provinceId
                                cityId:(NSString *)cityId
                              countyId:(NSString *)countyId
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:provinceId forKey:@"provinceId"];
    [params setValue:cityId forKey:@"cityId"];
    [params setValue:countyId forKey:@"countyId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getDistrictList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－获取所有小区信息接口
//参数名 	必选 	类型 	说明
//districtId 	是 	string 	小区id
+ (void) getDistrictInfoWithDistrictId:(NSString *)districtId
                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:[KeychainManager readUserId] forKey:@"userId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getDistrictInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    

}

#pragma mark－－社区头条接口
//参数名 	必选 	类型 	说明
//districtId 	是 	string 	小区id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数
+ (void) getNoticeAnnounceWithDistrictId:(NSString *)districtId
                               pageIndex:(NSString *)pageIndex
                                pageSize:(NSString *)pageSize
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getNoticeAnnounce
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark－－社区头条详情接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	社区头条id
//userId 	是 	string 	用户id
+ (void) getDistrictInfoWithTitleId:(NSString *)titleId
                             userId:(NSString *)userId
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:titleId forKey:@"id"];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getNoticeAnnounceDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－提交报修接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//districtId 	是 	string 	小区id
//repairArea 	是 	string 	报修区域（01：住宅区域 ，02：科研办公区域）
//repairTypeFirst 	是 	string 	报修类型（01：公共报修， 02：室内报修）
//repairTypeSecond 	是 	string 	报修类型（二级分类：石材）
//repairAddress 	是 	string 	维修地址
//repairContent 	是 	string 	报修内容
//imagesPathOne 	是 	string 	图片1
//imagesPathTwo 	是 	string 	图片2
//imagesPathThree 	是 	string 	图片3
+ (void)   addOrderRepairWithDistrictId:(NSString *)districtId
                                 userId:(NSString *)userId
                             repairArea:(NSString *)repairArea
                        repairTypeFirst:(NSString *)repairTypeFirst
                       repairTypeSecond:(NSString *)repairTypeSecond
                          repairAddress:(NSString *)repairAddress
                          repairContent:(NSString *)repairContent
                             imagesPath:(NSArray *)imagesPath
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:repairArea forKey:@"repairArea"];
    [params setValue:repairTypeFirst forKey:@"repairTypeFirst"];
    [params setValue:repairTypeSecond forKey:@"repairTypeSecond"];
    [params setValue:repairAddress forKey:@"repairAddress"];
    [params setValue:repairContent forKey:@"repairContent"];

    NSMutableDictionary *imageDic=[[NSMutableDictionary alloc]init];
    NSArray *imagespathArr=@[@"imagesPathOne",@"imagesPathTwo",@"imagesPathThree",];
    for (int i=0; i<imagesPath.count; i++)
    {
        [imageDic setValue:@[imagesPath[i]] forKey:imagespathArr[i]];
    }
    [[BMNetworkHandler sharedInstance] conURL:HK_repair_addOrderRepair
                                  networkType:NetWorkPOST
                                       params:params
                                       images:imageDic
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

    

}

#pragma mark－－获取报修类型接口
//参数名 	必选 	类型 	说明
//repairTypeFirst 	是 	string 	一级报修类型（01：公共报修， 02：室内报修）
+ (void) getRepairTypeWithRepairTypeFirst:(NSString *)repairTypeFirst
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:repairTypeFirst forKey:@"repairTypeFirst"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_repair_getRepairType
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－获取报修记录接口
//参数名 	必选 	类型 	说明
//repairState 	是 	string 	状态（01：进行中，02：已完成）
//userId 	是 	string 	用户id
//districtId 	是 	string 	小区id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数
+ (void) getRepairRecordWithRepairState:(NSString *)repairState
                                 userId:(NSString *)userId
                             districtId:(NSString *)districtId
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:repairState forKey:@"repairState"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_repair_getRepairRecord
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    

}
#pragma mark－－获取报修评价列表接口
//参数名 	必选 	类型 	说明
/*
 id 	是 	string 	报修id
 repairUserId 	是 	string 	维修人员id
 pageIndex 	是 	string 	当前页
 pageSize 	是 	string 	每页条数
 */

+ (void) getRepairEvaluationWithRepairId:(NSString *)RepairId
                            repairUserId:(NSString *)repairUserId
                               pageIndex:(NSString *)pageIndex
                                pageSize:(NSString *)pageSize
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:RepairId forKey:@"id"];
    [params setValue:repairUserId forKey:@"repairUserId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    [[BMNetworkHandler sharedInstance] conURL:HK_repair_getRepairEvaluation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－保修记录确认完成接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	报修id
//repairState 	是 	string 	报修状态（03：确认完成，05：取消）
+ (void) confirmRepairRecordWithRepairId:(NSString *)repairId
                             repairState:(NSString *)repairState
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:repairId forKey:@"id"];
    [params setValue:repairState forKey:@"repairState"];
    [[BMNetworkHandler sharedInstance] conURL:HK_repair_confirmRepairRecord
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－提交报修评价接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	维修id
//evalScores 	是 	string 	评分
//evalContent 	是 	string 	评价内容
//evalUserId 	是 	string 	评价用户id
//repairUserId 	是 	string 	维修用户id
+ (void) submitRepairEvaluationWithRepairId:(NSString *)repairId
                                 evalScores:(NSString *)evalScores
                                evalContent:(NSString *)evalContent
                                 evalUserId:(NSString *)evalUserId
                               repairUserId:(NSString *)repairUserId
                            completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:repairId forKey:@"id"];
    [params setValue:evalScores forKey:@"evalScores"];
    [params setValue:evalContent forKey:@"evalContent"];
    [params setValue:evalUserId forKey:@"evalUserId"];
    [params setValue:repairUserId forKey:@"repairUserId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_repair_submitRepairEvaluation
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－获取报修详情接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	保修id
+ (void) getRepairRecordDetailWithRepairId:(NSString *)repairId
                           completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:repairId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_repair_getRepairRecordDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    

}
#pragma mark－－提交有话要说接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//districtId 	是 	string 	小区id
//complainType 	是 	string 	投诉类型（01：物业费用， 02：物业保修， 03：其他）
//complainContent 	是 	string 	投诉内容
//imagesPathOne 	是 	string 	图片1
//imagesPathTwo 	是 	string 	图片2
//imagesPathThree 	是 	string 	图片3
+ (void) addTopicComplainWithUserId:(NSString *)userId
                         districtId:(NSString *)districtId
                       complainType:(NSString *)complainType
                    complainContent:(NSString *)complainContent
                         imagesPath:(NSArray *)imagesPath
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:complainType forKey:@"complainType"];
    [params setValue:complainContent forKey:@"complainContent"];
    
    NSMutableDictionary *imageDic=[[NSMutableDictionary alloc]init];
    NSArray *imagespathArr=@[@"imagesPathOne",@"imagesPathTwo",@"imagesPathThree",];
    for (int i=0; i<imagesPath.count; i++)
    {
        [imageDic setValue:@[imagesPath[i]] forKey:imagespathArr[i]];
    }
    
    [[BMNetworkHandler sharedInstance] conURL:HK_topicComplain_addTopicComplain
                                  networkType:NetWorkPOST
                                       params:params
                                       images:imageDic
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－获取有话要说列表接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//districtId 	是 	string 	小区id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数
+ (void) getTopicComplainListWithUserId:(NSString *)userId
                             districtId:(NSString *)districtId
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                        completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];

    [[BMNetworkHandler sharedInstance] conURL:HK_topicComplain_getTopicComplainList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－获取便民服务列表接口
//参数名 	必选 	类型 	说明
//districtId 	是 	string 	小区id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数
+ (void) getDistrictMerchantListWithDistrictId:(NSString *)districtId
                                     pageIndex:(NSString *)pageIndex
                                      pageSize:(NSString *)pageSize
                               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_districtMerchant_getDistrictMerchantList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－获取便民服务详情接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	商家id
+ (void) getDistrictMerchantDetailWithMerchantId:(NSString *)merchantId
                                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:merchantId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_districtMerchant_getDistrictMerchantDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－我的物业资料接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
+ (void) getMypropertyWithUserId:(NSString *)userId
                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getMyproperty
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－物业资料设置默认接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户id
//roomId 	是 	string 	房间号id
//isDefault 	是 	string 	是否是默认（1：是，0:否）
+ (void) setDefaultProperyWithUserId:(NSString *)userId
                              roomId:(NSString *)roomId
                           isDefault:(NSString *)isDefault
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:userId forKey:@"userId"];
    [params setValue:roomId forKey:@"roomId"];
    [params setValue:isDefault forKey:@"isDefault"];

    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_setDefaultPropery
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark－－获取各类型需缴费的账单接口
//参数名 	必选 	类型 	说明
//billType 	是 	string 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
//roomId 	是 	string 	房间id
+ (void) getPropertyBillWithBillType:(NSString *)billType
                              roomId:(NSString *)roomId
                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:billType forKey:@"billType"];
    [params setValue:roomId forKey:@"roomId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_properytyBill_getPropertyBill
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－物业钱包支付
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户编号
//id 	是 	string 	缴费id(多个用逗号隔开：1,2,3)
//districtId 	是 	string 	小区id
//billType 	是 	string 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
//userPassword 	是 	string 	支付密码
+ (void) propertyWalletWithBillType:(NSString *)billType
                             userId:(NSString *)userId
                         districtId:(NSString *)districtId
                       userPassword:(NSString *)userPassword
                             billId:(NSString *)billId
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:billType forKey:@"billType"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:[userPassword md5]forKey:@"userPassword"];
    [params setValue:billId forKey:@"id"];
    params=[DES3Util getSecrityForString:params];//加密
    [[BMNetworkHandler sharedInstance] conURL:HK_wallet_propertyWallet
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    

}
#pragma mark－－获取各类型缴费明细接口
//参数名 	必选 	类型 	说明
//id 	是 	string 	缴费id
+ (void) getPropertyBillDetailWithBillId:(NSString *)billId
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setValue:billId forKey:@"id"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_properytyBill_getPropertyBillDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}

#pragma mark－－获取各类型缴费历史接口
//参数名 	必选 	类型 	说明
//billType 	否 	string 	缴费类型（全部（不传或为空），01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
//roomId 	是 	string 	房间号id
//beginTime 	否 	string 	开始时间 (2017-01)
//endTime 	否 	string 	结束时间 (2017-05)
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数
+ (void) getPropertyBillRecordListWithBillType:(NSString *)billType
                                        roomId:(NSString *)roomId
                                     beginTime:(NSString *)beginTime
                                       endTime:(NSString *)endTime
                                     pageIndex:(NSString *)pageIndex
                                      pageSize:(NSString *)pageSize
                               completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:billType forKey:@"billType"];
    [params setValue:roomId forKey:@"roomId"];
    [params setValue:beginTime forKey:@"beginTime"];
    [params setValue:endTime forKey:@"endTime"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_properytyBill_getPropertyBillRecord
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark－－获取用户选择的小区是否是默认小区接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//districtId 	是 	string 	小区id
+ (void) getDefaultpropertyWithDistrictId:(NSString *)districtId
                          completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:districtId forKey:@"districtId"];
    [params setValue:[KeychainManager readUserId] forKey:@"userId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getDefaultproperty
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
#pragma mark－－获取用户选择的小区是否是默认小区接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
+ (void) getQuestionInfoWithUserId:(NSString *)userId
                        districtId:(NSString *)districtId
                   completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:districtId forKey:@"districtId"];

    [[BMNetworkHandler sharedInstance] conURL:HK_question_getQuestionInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}
#pragma mark－－提交问卷接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户Id
//questionId 	是 	string 	问卷id
//questionList 	是 	string 	json集合（对应下面格式）
//提交格式： [{"titleId": "1","optionsId": "1"},{"titleId": "2","optionsId": "1"}]

+ (void) submitQuestionInfoWithUserId:(NSString *)userId
                           questionId:(NSString *)questionId
                         questionList:(NSString *)questionList
                      completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:questionId forKey:@"questionId"];
    [params setValue:questionList forKey:@"questionList"];

    [[BMNetworkHandler sharedInstance] conURL:HK_question_submitQuestionInfo
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark－－获取收藏社区头条信息接口
//参数名 	必选 	类型 	说明
//userId 	是 	string 	用户id
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

+ (void) getCollectNoticeAnnounceWithUserId:(NSString *)userId
                                  pageIndex:(NSString *)pageIndex
                                   pageSize:(NSString *)pageSize
                            completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_districtInfo_getCollectNoticeAnnounce
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark --- 获取京东物流信息
/*
 jdOrderId     是     string     京东订单号
 */
+(void)getJDOrderTrackWithJdOrderId:(NSString *)jdOrderId
                    completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JD_jdOrder_orderTrack
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark --- 京东商品评价接口
/*
 orderCode     是     string     订单号
 userId     是     string     用户id
 userName     是     string     用户账号
 evaluateList     是     string     评价集合 （对应一下json）
 */
+(void)addJDGoodsEvaluateWithJdOrderCode:(NSString *)orderCode
                                  userId:(NSString *)userId
                                //userName:(NSString *)userName
                            evaluateList:(NSString *)evaluateList
                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:orderCode forKey:@"orderCode"];
    [params setValue:userId forKey:@"userId"];
    //[params setValue:userName forKey:@"userName"];
    [params setValue:evaluateList forKey:@"evaluateList"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JD_jdGoodsEvaluate_addGoodsEvaluate
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark --- 售后申请列表接口
/*
 userId     是     string     用户id
 imageSize     是     string     图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 pageIndex     是     string     页码
 pageSize     是     string     每页几条 建议传5 加载速度慢
 */
+(void)jdAfterSellApplyGetOrderListWithUserId:(NSString *)userId
                                    imageSize:(NSString *)imageSize
                                    pageIndex:(NSString *)pageIndex
                                     pageSize:(NSString *)pageSize
                              completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:imageSize forKey:@"imageSize"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JD_jdAfterSellApply_getOrderList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark --- 售后申请列表接口
/*
 jdOrderId     是     string     京东订单号
 customerExpect     是     string     客户预期 必填，退货(10)、换货(20)、维修(30)
 questionDesc     是     string     产品问题描述
 isHasPackage     是     string     是否有包装 0否 1是
 packageDesc     是     string     包装描述 0 无包装 10 包装完整 20 包装破损
 pickwareType     是     string     取件方式 4 上门取件 7 客户送货 40客户发货
 skuId     是     string     sku
 skuNum     是     string     数量
 imagesPathOne     否     file     图1
 imagesPathTwo     否     file     图2
 imagesPathThree     否     file     图3
 */
+(void)jdAfterSellApplyAddApplyWithJdOrderId:(NSString *)jdOrderId
                              customerExpect:(NSString *)customerExpect
                                questionDesc:(NSString *)questionDesc
                                isHasPackage:(NSString *)isHasPackage
                                 packageDesc:(NSString *)packageDesc
                                pickwareType:(NSString *)pickwareType
                                       skuId:(NSString *)skuId
                                      skuNum:(NSString *)skuNum
                                  imagesPath:(NSArray *)imagesPath
                             completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    [params setValue:customerExpect forKey:@"customerExpect"];
    [params setValue:questionDesc forKey:@"questionDesc"];
    [params setValue:isHasPackage forKey:@"isHasPackage"];
    [params setValue:packageDesc forKey:@"packageDesc"];
    [params setValue:pickwareType forKey:@"pickwareType"];
    [params setValue:skuId forKey:@"skuId"];
    [params setValue:skuNum forKey:@"skuNum"];
    [params setValue:[KeychainManager readUserId] forKey:@"userId"];
    
    
    NSMutableDictionary *imageDic=[[NSMutableDictionary alloc]init];
    NSArray *imagespathArr=@[@"imagesPathOne",@"imagesPathTwo",@"imagesPathThree",];
    for (int i=0; i<imagesPath.count; i++)
    {
        [imageDic setValue:@[imagesPath[i]] forKey:imagespathArr[i]];
    }
    [[BMNetworkHandler sharedInstance] conURL:HK_JD_jdAfterSellApply_addApply
                                  networkType:NetWorkPOST
                                       params:params
                                       images:imageDic
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark ---  售后记录列表
/*
 userId     是     string     用户id
 imageSize     是     string     图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 pageIndex     是     string     页码
 pageSize     是     string     每页几条 建议传5 加载速度慢
 */
+(void)jdAfterSellApplyGetJdAfterSellApplyListWithUserId:(NSString *)userId
                                               imageSize:(NSString *)imageSize
                                               pageIndex:(NSString *)pageIndex
                                                pageSize:(NSString *)pageSize
                                         completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:imageSize forKey:@"imageSize"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdAfterSellApply_getJdAfterSellApplyList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark --- 获取京东售后详情
/*
 afsServiceId     是     string     服务单号
 imageSize     是     string     图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
 */
+(void)jdAfterSellApplyGetJdAfterSellApplyDetailWithAfsServiceId:(NSString *)afsServiceId
                                                       imageSize:(NSString *)imageSize
                                                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:afsServiceId forKey:@"afsServiceId"];
    [params setValue:imageSize forKey:@"imageSize"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdAfterSellApply_getJdAfterSellApplyDetail
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark --- 获取京东发票详情
/*
 jdOrderId	是	string	京东订单号
 */
+(void)jdgetInvoiceListDetailWithjdOrderId:(NSString *)jdOrderId
                                                 completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdOrder_ggetInvoiceList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark --- 根据订单号、商品编号查询支持的商品返回京东方式接口
/*
 jdOrderId     是     string     京东订单号
 skuId     是     string     京东商品编号
 */
+(void)jdReturnOrderGetWareReturnJdCompWithJdOrderId:(NSString *)jdOrderId
                                               skuId:(NSString *)skuId
                                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    [params setValue:skuId forKey:@"skuId"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JD_jdReturnOrder_getWareReturnJdComp
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark --- 根据订单号、商品编号查询支持的服务类型接口
/*
 jdOrderId     是     string     京东订单号
 skuId     是     string     京东商品编号
 */
+(void)jdReturnOrderGetCustomerExpectCompWithJdOrderId:(NSString *)jdOrderId
                                                 skuId:(NSString *)skuId
                                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    [params setValue:skuId forKey:@"skuId"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_JD_jdReturnOrder_getCustomerExpectComp
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}


#pragma mark --- 获取商品评价列表
/*
 参数名     必选     类型     说明
 goodsId     是     string     sku
 pageIndex     是     string     当前页
 pageSize     是     string     每页条数
 */
+ (void) jdGoodsEvaluateGoodsEvaluationListWithGoodsId:(NSString *)goodsId
                                             pageIndex:(NSString *)pageIndex
                                              pageSize:(NSString *)pageSize
                                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:goodsId forKey:@"goodsId"];
    [params setValue:pageIndex forKey:@"pageIndex"];
    [params setValue:pageSize forKey:@"pageSize"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdGoodsEvaluate_goodsEvaluationList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma mark --- 取消服务单/客户放弃
/**
 afsServiceId     是     string     服务单号
 */
+ (void) jdAfterSellApplyAuditCancelWithAfsServiceId:(NSString *)afsServiceId
                                     completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:afsServiceId forKey:@"afsServiceId"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdAfterSellApply_auditCancel
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark 获取JD品牌列表接口
/*
 参数名	必选	类型	说明
 categoryId	是	string	分类ID
 */
+ (void) getJDBrandListWithcategoryId:(NSString *)categoryId
                          goodsName:(NSString *)goodsName
              completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:categoryId forKey:@"categoryId"];
    [params setValue:goodsName forKey:@"goodsName"];

    [[BMNetworkHandler sharedInstance] conURL:HK_goods_getJDBrandList
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark --- 填写客户发运信息
/**
 afsServiceId     是     int     服务单号
 freightMoney     是     BigDecimal     运费
 expressCompany     是     string     发运公司 圆通快递、申通快递、韵达快递、中通快递、宅急送、EMS、顺丰快递
 deliverDate     是     string     发货日期 格式为yyyy-MM-dd HH:mm:ss
 expressCode     是     string     货运单号
 */
+ (void) jdAfterSellApplyUpdateSendSkuWithAfsServiceId:(NSString *)afsServiceId
                                          freightMoney:(NSString *)freightMoney
                                        expressCompany:(NSString *)expressCompany
                                           deliverDate:(NSString *)deliverDate
                                           expressCode:(NSString *)expressCode
                                       completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:afsServiceId forKey:@"afsServiceId"];
    [params setValue:freightMoney forKey:@"freightMoney"];
    [params setValue:expressCompany forKey:@"expressCompany"];
    [params setValue:deliverDate forKey:@"deliverDate"];
    [params setValue:expressCode forKey:@"expressCode"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdAfterSellApply_updateSendSku
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}
#pragma mark 修改JD订单状态接口
/*
 jdOrderId 	是 	string 	订单号
 */
+ (void) changeGroupOrderStatusWithjdOrderId:(NSString *)jdOrderId

                             completionBlock:(kCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:jdOrderId forKey:@"jdOrderId"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:HK_jdOrder_confirmReceived
                                  networkType:NetWorkPOST
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
     } failureBlock:^(NSError *error)
     {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}
@end
