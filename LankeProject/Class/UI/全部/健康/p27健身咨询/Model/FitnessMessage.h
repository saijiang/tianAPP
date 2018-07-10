//
//  FitnessMessage.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitnessMessage : NSObject

@property (nonatomic ,assign) BOOL isRobot;// left
@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * iconImage;
@property (nonatomic ,strong) NSString * time;
@property (nonatomic ,strong) NSString * message;
@property (nonatomic ,assign) CGFloat messageHeight;

+ (instancetype) robot;
+ (instancetype) user;
+ (instancetype) user:(NSString *)message;

+ (instancetype) data:(NSDictionary *)data;
@end
