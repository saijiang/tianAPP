//
//  ReservationInfo.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/23.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReservationInfo : NSObject

@property (nonatomic ,assign) NSInteger count;

@property (nonatomic ,strong) NSDate * date;

@property (nonatomic ,strong) NSString * dateString;
@property (nonatomic ,strong) NSString * timeString;

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * sex;
@property (nonatomic ,strong) NSString * phoneNumber;

@property (nonatomic ,strong) NSString * note;

- (BOOL) isValid;
@end
