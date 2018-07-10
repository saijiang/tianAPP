//
//  JsonHandler.m
//  BlueMobiProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "JsonHandler.h"
#import "JSON.h"
#import "NSString+MHCommon.h"

@implementation JsonHandler

+ (id)JSONValue:(NSString *)string
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
#else
    return [string JSONValue];
#endif
}

@end
