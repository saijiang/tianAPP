//
//  ArchiverManager.h
//  MHProject
//
//  Created by 董駸 on 16/1/7.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

/**
 *  重要!!!
 *  要持久化的实体对象必须调用NSCoding协议才能持久化!!!
 *  详细NSCoding用法 参照UserInfoModle.m文件
 */

#import <Foundation/Foundation.h>

// 保存路径名 可自定义
#define k_FILE_NAME @"objectKey"

@interface ArchiverManager : NSObject

/**
 *  持久化实体对象
 *
 *  @param object 对象
 *  @param key    对应key
 *
 *  @return 是否成功
 */
+ (BOOL)saveObject:(id)object forKey:(NSString *)key;

/**
 *  读取已持久化对象
 *
 *  @param key 对应key
 *
 *  @return 返回实体对象
 */
+ (id)loadObjectForKey:(NSString *)key;

/**
 *  删除某个key下持久化的对象
 *
 *  @param key 对应key
 *
 *  @return 是否成功
 */
+ (BOOL)removeObjectForkey:(NSString *)key;

/**
 *  删除所有已持久化对象
 *
 *  @return 是否成功
 */
+ (BOOL)removeAllObject;


@end
