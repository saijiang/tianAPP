//
//  HZLocation.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZLocation : NSObject

@property (copy, nonatomic) NSString *country;      //国家
@property (copy, nonatomic) NSString *state;        //省
@property (copy, nonatomic) NSString *stateId;      //省ID
@property (copy, nonatomic) NSString *city;         //市
@property (copy, nonatomic) NSString *cityId;       //市ID
@property (copy, nonatomic) NSString *district;     //区
@property (copy, nonatomic) NSString *districtId;   //区ID
@property (copy, nonatomic) NSString *street;       //街道
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
