//
//  KeychainManager.h
//  MHProject
//
//  Created by 董駸 on 15/7/22.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainManager : NSObject


+(void)saveUserData:(id)data;

/**
 *  保存其他类型数据
 *  withKey 字典key
 *  withValue 字典value
 */
+ (void)saveOtherKey:(id)withKey value:(id)withValue;
/**
 *  读取其他数据数据
 *
 *  @return return value description
 */
+ (id)readValueWithKey:(id)withKey;

+ (id)readPassword;

+ (id)readUserName;

+ (id)readUserId;

+ (id)readEmployeeNum;

+ (id)readNickName;

+ (id)readHeadImage;

+ (id)readMobileNum;

//
+ (void)deleteData;

+ (void)deletePassword;

+ (void)deleteUserName;


//设置登录状态
+ (void)setloginState:(BOOL)islogin;

+ (void)setPhoneLogin:(BOOL)phone;
+ (BOOL) isPhoneLogin;

//是否登录
+ (BOOL)islogin;

//跳转登陆页
+(void)gotoLogin;

//是否HR
+(BOOL)isHR;

//是否开启健康
+(BOOL)isHealthAuthorityFlg;

//是否选择小区 物业首页右上角判读 本地数据
+(BOOL)islocalDistrict;
//设置绑定小区状态
+ (void)setlocalDistrictState:(BOOL)district;

+ (void)setlocalDistrictId:(NSString *)districtId;

+ (void)setlocalDistrictName:(NSString *)districtName;

+ (id)readlocalDistrictId;

+ (id)readlocalDistrictName;


//物业后台物 业权限标志
//是否开启物业权限
+(BOOL)isPropertyAuthorityFlg;

+ (id)readDistrictId;

+ (id)readDistrictName;

+ (id)readRoomId;

+ (id)readDistrictAddress;

@end
