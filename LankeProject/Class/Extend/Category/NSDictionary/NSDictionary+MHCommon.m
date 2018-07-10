//
//  NSDictionary+MHCommon.m
//  MHProject
//
//  Created by MengHuan on 15/5/14.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "NSDictionary+MHCommon.h"

@implementation NSDictionary (MHCommon)

#pragma mark - 代替原NSDictionary里的objectForKey方法
/**
 *  代替原NSDictionary里的objectForKey方法
 *
 *  @param aKey 传入key
 *
 *  @return 返回key对应的value
 */
- (id)objectForMHKey:(id)aKey
{
    if (![[self allKeys] containsObject:aKey])
    {
        DEF_DEBUG(@"[字典对应的key:\"%@\"不存在]", aKey);
        
        // 如果aKay不存在，则返回空字符串
        return @"";
    }
    
    // 返回原本key对应的value
    return [self objectForKey:aKey];
}

@end
