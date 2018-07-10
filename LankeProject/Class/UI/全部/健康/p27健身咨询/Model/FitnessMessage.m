//
//  FitnessMessage.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessMessage.h"

@implementation FitnessMessage

+ (instancetype) robot{

    FitnessMessage * message = [[FitnessMessage alloc] init];
    message.isRobot = YES;
    message.name = @"客服";
    message.message = @"很高兴为你服务很高兴为你服务很高兴为你服务很高兴为你服务很高兴为你服务";
    return message;
}

+ (instancetype) user{

    return [self user:@"你好"];
}

+ (instancetype) user:(NSString *)content{

    FitnessMessage * message = [[FitnessMessage alloc] init];
    message.isRobot = NO;
    message.name = @"我";
    message.message = content;
    return message;
}

+ (instancetype)data:(NSDictionary *)data{
    /*
     {
     "nickName": "江仕华",
     "headImage": "http://localhost:8080/zhsqImg//image/user/3913f503-fc7a-4373-844b-a4fd1e1d2129.jpg",
     "messageTime": 1482721816000,
     "messageType": "02",
     "content": "11111"
     }
     */
    
    /** messageType（01:提问 02：回复） */
    FitnessMessage * message = [[FitnessMessage alloc] init];
    message.isRobot = [data[@"messageType"] isEqualToString:@"02"];
    message.message = data[@"content"];
    message.name = data[@"nickName"];
    message.iconImage = data[@"headImage"];
    message.time = data[@"messageTime"];
    return message;
}

@end
