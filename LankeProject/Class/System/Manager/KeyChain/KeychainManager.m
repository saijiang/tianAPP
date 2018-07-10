//
//  KeychainManager.m
//  MHProject
//
//  Created by 董駸 on 15/7/22.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "KeychainManager.h"
#import "KeyChain.h"
#import "LoginViewController.h"

@implementation KeychainManager

//用bundleid来做key 保证唯一性
#define KEY_IN_KEYCHAIN  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey]

#define KEY_PASSWOED [KEY_IN_KEYCHAIN stringByAppendingString:@"Password"]

#define KEY_USERNAME [KEY_IN_KEYCHAIN stringByAppendingString:@"UserName"]

#define KEY_USERNICKNAME [KEY_IN_KEYCHAIN stringByAppendingString:@"NickName"]

#define KEY_USERID [KEY_IN_KEYCHAIN stringByAppendingString:@"UserId"]

#define KEY_EMPLOYEENUM [KEY_IN_KEYCHAIN stringByAppendingString:@"EmployeeNumber"]

#define KEY_ISLOGIN [KEY_IN_KEYCHAIN stringByAppendingString:@"Islogin"]

#define KEY_ISPHONELOGIN [KEY_IN_KEYCHAIN stringByAppendingString:@"IsPhonelogin"]

#define KEY_USERHEADIMAGE [KEY_IN_KEYCHAIN stringByAppendingString:@"HeadImage"]

#define KEY_USERMOBILENUM [KEY_IN_KEYCHAIN stringByAppendingString:@"MobileNum"]

/**
 *  保存数据
 */
+(void)saveUserData:(id)data
{
    [self savePassword:nil
              userName:data[@"userName"]
                userId:data[@"userId"]
              nickName:data[@"nickName"]
             headImage:data[@"headImage"]
             mobileNum:data[@"mobileNum"]
           employeeNum:data[@"employeeNum"]];
}

/**
 *  保存数据
 *
 *  @param password 密码
 *  @param userName 用户名
 */
+ (void)savePassword:(NSString *)password userName:(NSString *)userName userId:(NSString *)userId nickName:(NSString *)nickName headImage:(NSString *)headImage mobileNum:(NSString *)mobileNum employeeNum:(NSString *)employee
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (!password)
    {
        password = [self readPassword];
    }
    if (password) {
        [data setObject:password forKey:KEY_PASSWOED];
    }
    
    if (!userName)
    {
        userName = [self readUserName];
    }
    if (userName) { [data setObject:userName forKey:KEY_USERNAME]; }
    
    if (!userId)
    {
        userId = [self readUserId];
    }
    if (userId) {
        
        [data setObject:userId forKey:KEY_USERID];
    }
    
    if (!nickName)
    {
        nickName = [self readNickName];
    }
    [data setObject:nickName forKey:KEY_USERNICKNAME];
    
    if (!headImage)
    {
        headImage = [self readHeadImage];
    }
    [data setObject:headImage forKey:KEY_USERHEADIMAGE];
    
    if (!mobileNum)
    {
        mobileNum = [self readMobileNum];
    }
    [data setObject:mobileNum forKey:KEY_USERMOBILENUM];
    
    if (!employee) {
        employee = [self readEmployeeNum];
    }
    [data setObject:employee forKey:KEY_EMPLOYEENUM];
    
    [KeyChain saveKeychain:KEY_IN_KEYCHAIN data:data];
    //更改本地登录状态
    [KeychainManager setloginState:YES];
}


/**
 *  保存其他类型数据
 *  withKey 字典key
 *  withValue 字典value
 */
+ (void)saveOtherKey:(id)withKey value:(id)withValue;
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:withValue forKey:withKey];
    [KeyChain saveKeychain:KEY_IN_KEYCHAIN data:data];
}


/**
 *  读取其他数据数据
 *
 *  @return return value description
 */
+ (id)readValueWithKey:(id)withKey
{
    NSMutableDictionary *data = (NSMutableDictionary *)[KeyChain loadKeychain:KEY_IN_KEYCHAIN];
    return [data objectForKey:withKey];
}

/**
 *  读取密码
 *
 *  @return return value description
 */
+ (id)readPassword
{
    return [UserInfo_Preferences sharedInstance].password;
    

}

/**
 *  读取用户名
 *
 *  @return <#return value description#>
 */
+ (id)readUserName
{
    return [UserInfo_Preferences sharedInstance].userName;
    
}
/**
 *  读取用户ID
 *
 *  @return <#return value description#>
 */
+ (id)readUserId
{
    if (![self islogin])
    {
        return @"";
        
    }
    return [UserInfo_Preferences sharedInstance].userId;
    
}

+ (id)readNickName
{
    return [UserInfo_Preferences sharedInstance].nickName;
}

+ (id)readHeadImage
{
    return [UserInfo_Preferences sharedInstance].userIcon;
   
}
+ (id)readMobileNum
{
    return [UserInfo_Preferences sharedInstance].phoneNumber;
    
}
/**
 *  删除数据
 */
+ (void)deleteData
{
    [KeyChain deleteKeychain:KEY_IN_KEYCHAIN];
}

/**
 *  删除密码
 */
+ (void)deletePassword
{
    NSMutableDictionary *data = (NSMutableDictionary *)[KeyChain loadKeychain:KEY_IN_KEYCHAIN];
    [data removeObjectForKey:KEY_PASSWOED];
    [KeyChain saveKeychain:KEY_IN_KEYCHAIN data:data];
}

/**
 *  删除用户名
 */
+ (void)deleteUserName
{
    NSMutableDictionary *data = (NSMutableDictionary *)[KeyChain loadKeychain:KEY_IN_KEYCHAIN];
    [data removeObjectForKey:KEY_USERNAME];
    [KeyChain saveKeychain:KEY_IN_KEYCHAIN data:data];
}


#pragma mark -
#pragma mark Employee Number

+ (void) saveEmployeeNum:(NSString *)employeeNum{

    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:employeeNum forKey:KEY_EMPLOYEENUM];
    [KeyChain saveKeychain:KEY_IN_KEYCHAIN data:data];
}

+ (id ) readEmployeeNum
{
    return [UserInfo_Preferences sharedInstance].employeeNumber;
   
}
//设置登录状态
+ (void)setloginState:(BOOL)islogin
{
    
    [UserInfo_Preferences sharedInstance].loginState = islogin;
    
}
//判断是否登录
+ (BOOL)islogin
{
    return [UserInfo_Preferences sharedInstance].loginState;
}
+ (void)setPhoneLogin:(BOOL)phone{

    if (phone)
    {
        DEF_PERSISTENT_SET_OBJECT(@"1", KEY_ISPHONELOGIN);
        
    }
    else
    {
        DEF_PERSISTENT_SET_OBJECT(@"0", KEY_ISPHONELOGIN);
        
    }
}
+ (BOOL) isPhoneLogin{

    NSString *MHIsLogin= DEF_PERSISTENT_GET_OBJECT(KEY_ISPHONELOGIN);
    if ([MHIsLogin isEqualToString:@"1"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//跳转登陆页
+(void)gotoLogin
{
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    
//    [defaults removeObjectForKey:@"cityArray"];
//    
//    [defaults synchronize];
    //更改本地登录状态
    [KeychainManager setloginState:NO];
    LoginViewController * login = [[LoginViewController alloc] init];
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:login];
    [KAPPDELEGATE.window.rootViewController presentViewController:nav animated:YES completion:nil];
    return;
}

//是否HR
+(BOOL)isHR
{
    if ([[UserInfo_Preferences sharedInstance].isHr integerValue]==1)
    {
        return YES;
    }
    return NO;

}
//是否开启健康
+(BOOL)isHealthAuthorityFlg
{
    if ([[UserInfo_Preferences sharedInstance].healthAuthorityFlg integerValue]==1)
    {
        return YES;
    }
    return NO;
}
//是否绑定小区
+(BOOL)islocalDistrict
{
    return [UserInfo_Preferences sharedInstance].localdistrictState;
}
//设置绑定小区状态
+ (void)setlocalDistrictState:(BOOL)district
{
    [UserInfo_Preferences sharedInstance].localdistrictState = district;

}
+ (void)setlocalDistrictId:(NSString *)districtId
{
    [UserInfo_Preferences sharedInstance].localdistrictId = districtId;

}

+ (void)setlocalDistrictName:(NSString *)districtName
{
    [UserInfo_Preferences sharedInstance].localdistrictName = districtName;

}
+ (id)readlocalDistrictId
{
    return [UserInfo_Preferences sharedInstance].localdistrictId;
}
+ (id)readlocalDistrictName
{
    return [UserInfo_Preferences sharedInstance].localdistrictName;

}
//物业后台物 业权限标志
//是否开启物业权限
+(BOOL)isPropertyAuthorityFlg
{
    if ([[UserInfo_Preferences sharedInstance].propertyAuthorityFlg integerValue]==1)
    {
        return YES;
    }
    return NO;
}

+ (id)readDistrictId
{
    return [UserInfo_Preferences sharedInstance].districtId;
}
+ (id)readDistrictName
{
    return [UserInfo_Preferences sharedInstance].districtName;
}
+ (id)readRoomId
{
    return [UserInfo_Preferences sharedInstance].roomId;
}
+ (id)readDistrictAddress
{
    NSString *provinceName= [UserInfo_Preferences sharedInstance].provinceName;
    NSString *cityName= [UserInfo_Preferences sharedInstance].cityName;
    NSString *countyName= [UserInfo_Preferences sharedInstance].countyName;
    NSString *districtAddress= [UserInfo_Preferences sharedInstance].districtAddress;
    NSString *districtName= [UserInfo_Preferences sharedInstance].districtName;
    NSString *buildingNum= [UserInfo_Preferences sharedInstance].buildingNum;
    NSString *roomNum= [UserInfo_Preferences sharedInstance].roomNum;
    NSString * address=[NSString stringWithFormat:@"%@%@%@%@%@%@号%@室",provinceName,cityName,countyName,districtAddress,districtName,buildingNum,roomNum];
    
    return address;
}
@end
