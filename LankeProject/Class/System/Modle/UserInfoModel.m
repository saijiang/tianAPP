//
//  UserInfoModle.m
//  MHProject
//
//  Created by 董駸 on 16/1/5.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}

@end
