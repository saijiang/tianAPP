//
//  ReservationInfo.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/23.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationInfo.h"

@implementation ReservationInfo

- (BOOL) isValid{

    BOOL valid = YES;
    valid = self.count && valid;
    if (!valid) {
        [UnityLHClass showHUDWithStringAndTime:@"请选择人数"];
        return valid;
    }
    
    valid = self.dateString && self.timeString && valid;
    if (!valid) {
        [UnityLHClass showHUDWithStringAndTime:@"请选择时间"];
        return valid;
    }
    
    valid = self.name && valid;
    if (!valid) {
        [UnityLHClass showHUDWithStringAndTime:@"请输入您的姓名"];
        return valid;
    }
    
    valid = self.sex && valid;
    if (!valid) {
        [UnityLHClass showHUDWithStringAndTime:@"请选择性别"];
        return valid;
    }
    
    valid = [UnityLHClass checkTel:self.phoneNumber] && valid;
    if (!valid) {
        [UnityLHClass showHUDWithStringAndTime:@"请输入正确的电话号码"];
        return valid;
    }
    
    return valid;
}

@end
