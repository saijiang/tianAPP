//
//  CacheManager.h
//  LankeProject
//
//  Created by itman on 16/7/28.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHLocalSubstitutionCache.h"

@interface CacheManager : NSObject

singleton_for_header(CacheManager)

//清除沙盒缓存
+(void)myClearCacheAction;

/**
 *  获取沙盒缓存大小
 *
 *  @return 沙盒缓存大小
 */
+(long long)getNSCachesDirectoryCache;


/**
 *  获取缓存文件大小
 *
 *  @param folderPath 文件路径
 *
 *  @return 文件大小
 */
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath;

//清除web缓存
+(void)clearWebCache;

@end
