//
//  UserInfo_Preferences.m
//  PAPreferencesSample
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 Peer Assembly. All rights reserved.
//

#import "UserInfo_Preferences.h"

@implementation UserInfo_Preferences

@dynamic nickName;
@dynamic userName;
@dynamic employeeNumber;
@dynamic phoneNumber;
@dynamic password;
@dynamic userId;
@dynamic loginState;
@dynamic loginInfo;
@dynamic userIcon;
@dynamic rememberPassword;

@dynamic sex;
@dynamic age;
@dynamic height;
@dynamic weight;
@dynamic integral;
@dynamic isHr;
@dynamic healthAuthorityFlg;

@dynamic localdistrictState;
@dynamic localdistrictId;
@dynamic localdistrictName;

@dynamic propertyAuthorityFlg;  //物业权限标志(0：未开通, 1：已开通)
@dynamic districtId;            // 	小区id
@dynamic buildingId;            // 	楼栋id
@dynamic roomId;                // 	房间号id
@dynamic districtName;          // 	小区名称
@dynamic districtAddress;       // 	小区地址
@dynamic buildingNum;           // 	楼栋号
@dynamic roomNum;               // 	房间号
@dynamic provinceName;          // 	省名称
@dynamic cityName;              // 	城市名
@dynamic countyName;            // 	区县名

/** 用于获取用户信息接口的返回数据 */
- (void) savePreferencesWithData:(id)data{
    
    self.userName = data[@"userName"];
    self.nickName = data[@"nickName"];
    self.userId = data[@"userId"];
    self.phoneNumber = data[@"mobileNum"];
    self.userIcon = data[@"headImage"];
    if (data[@"employeeNum"])
    {
        self.employeeNumber = data[@"employeeNum"];
    }
    if (data[@"sex"])
    {
        self.sex = data[@"sex"];
    }
    if (data[@"age"])
    {
        self.age = data[@"age"];
    }
    if (data[@"height"])
    {
        self.height = data[@"height"];
    }
    if (data[@"height"])
    {
        self.weight = data[@"weight"];
    }
    if (data[@"integral"])
    {
        self.integral = data[@"integral"];
    }
    if (data[@"isHr"])
    {
        self.isHr = data[@"isHr"];
    }
    if (data[@"healthAuthorityFlg"])
    {
        self.healthAuthorityFlg = data[@"healthAuthorityFlg"];
    }
    if (data[@"propertyAuthorityFlg"])
    {
        self.propertyAuthorityFlg = data[@"propertyAuthorityFlg"];
    }
    if (data[@"districtId"])
    {
        self.districtId = data[@"districtId"];
    }
    if (data[@"buildingId"])
    {
        self.buildingId = data[@"buildingId"];
    }
    if (data[@"roomId"])
    {
        self.roomId = data[@"roomId"];
    }
    if (data[@"districtName"])
    {
        self.districtName = data[@"districtName"];
    }
    if (data[@"districtAddress"])
    {
        self.districtAddress = data[@"districtAddress"];
    }
    if (data[@"buildingNum"])
    {
        self.buildingNum = data[@"buildingNum"];
    }
    if (data[@"roomNum"])
    {
        self.roomNum = data[@"roomNum"];
    }
    if (data[@"provinceName"])
    {
        self.provinceName = data[@"provinceName"];
    }
    if (data[@"cityName"])
    {
        self.cityName = data[@"cityName"];
    }
    if (data[@"countyName"])
    {
        self.countyName = data[@"countyName"];
    }

}

- (NSString *)suiteName{

    return @"LK_UserDefault";
}

- (NSDictionary *)setupDefaults{

    return @{
             @"loginState":@NO,
             @"loginInfo":@"",
             @"rememberPassword":@NO,
             @"localdistrictState":@NO
             };
}

@end
