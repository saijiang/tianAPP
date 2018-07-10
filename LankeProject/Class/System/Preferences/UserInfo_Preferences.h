//
//  UserInfo_Preferences.h
//  PAPreferencesSample
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 Peer Assembly. All rights reserved.
//

#import "PAPreferences.h"

// Ensure we get an error if we forget to add @dynamic for each property
#pragma clang diagnostic push
#pragma clang diagnostic error "-Wobjc-missing-property-synthesis"

@interface UserInfo_Preferences : PAPreferences

@property (nonatomic ,assign) BOOL loginState;

// 用于登录，不论是员工号还是手机号
@property (nonatomic ,assign) NSString * loginInfo;

@property (nonatomic ,assign) NSString * phoneNumber;
@property (nonatomic ,assign) NSString * employeeNumber;

@property (nonatomic ,assign) NSString * password;
@property (nonatomic ,assign) BOOL rememberPassword;

//用户基本信息
@property (nonatomic ,assign) NSString * userId;
@property (nonatomic ,assign) NSString * userName;
@property (nonatomic ,assign) NSString * nickName;
@property (nonatomic ,assign) NSString * userIcon;

//用户运动信息
@property (nonatomic ,assign) NSString * healthAuthorityFlg;//是否开启健身
@property (nonatomic ,assign) NSString * sex;
@property (nonatomic ,assign) NSString * age;
@property (nonatomic ,assign) NSString * height;
@property (nonatomic ,assign) NSString * weight;
@property (nonatomic ,assign) NSString * integral;
@property (nonatomic ,assign) NSString * isHr;

//用户物业基本信息
//本地数据 用于社区头条
@property (nonatomic ,assign) BOOL localdistrictState;//是否拥有小区
@property (nonatomic ,assign) NSString * localdistrictId;//小区id
@property (nonatomic ,assign) NSString * localdistrictName;//小区名称

//后台数据 用户资料
@property (nonatomic ,assign) NSString * propertyAuthorityFlg;//物业权限标志(0：未开通, 1：已开通)

@property (nonatomic ,assign) NSString *districtId;         // 	小区id
@property (nonatomic ,assign) NSString *buildingId;         // 	楼栋id
@property (nonatomic ,assign) NSString *roomId;             // 	房间号id
@property (nonatomic ,assign) NSString *districtName;       // 	小区名称
@property (nonatomic ,assign) NSString *districtAddress; 	// 	小区地址
@property (nonatomic ,assign) NSString *buildingNum;        // 	楼栋号
@property (nonatomic ,assign) NSString *roomNum;            // 	房间号
@property (nonatomic ,assign) NSString *provinceName;       // 	省名称
@property (nonatomic ,assign) NSString *cityName;           // 	城市名
@property (nonatomic ,assign) NSString *countyName;         // 	区县名


/** 用于获取用户信息接口的返回数据 */
- (void) savePreferencesWithData:(id)data;

@end

#pragma clang diagnostic pop
