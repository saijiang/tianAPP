//
//  NLPersonalParams.h
//  MTypeSDK
//
//  Created by wanglx on 15/6/8.
//  Copyright (c) 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLPersonalParams : NSObject
/**
 *  tag DF01
 *  个人身高，单位厘米(cm)，范围0-255
 */
@property (nonatomic, assign) int height;
/**
 *  tag DF02
 *  个人体重，单位千克(kg)；范围0-255
 */
@property (nonatomic, assign) int weight;
/**
 *  tag DF03
 *  个人性别 0女 / 1男
 */
@property (nonatomic, assign) int sex;
@end
