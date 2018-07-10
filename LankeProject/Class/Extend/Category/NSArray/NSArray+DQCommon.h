//
//  NSArray+Common.h
//  MHProject
//
//  Created by 董駸 on 16/1/22.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DQCommon)

/**
 *  NSArray 添加
 *
 *  @param object 数据
 *
 *  @return 返回修改后的NSArray
 */
- (NSArray *)DQAddObject:(id)object;

/**
 *  NSArray 插入数据
 *
 *  @param object 数据
 *  @param index  插入下标
 *
 *  @return 返回修改后数组
 */
- (NSArray *)DQInsertObject:(id)object atIndex:(NSUInteger)index;

/**
 *  NSArray 删除某一个数据
 *
 *  @param object 数据
 *
 *  @return 返回修改后数组
 */
- (NSArray *)DQRemoveObject:(id)object;

/**
 *  NSArray 删除下标的数据
 *
 *  @param index 下标
 *
 *  @return 返回修改后数组
 */
- (NSArray *)DQRemoveObjectAtIndex:(NSUInteger)index;

/**
 *  NSArray 删除最后一个数据
 *
 *  @return 修改后的数组
 */
- (NSArray *)DQMoveLastObject;

/**
 *  NSArray 替换某个下标下的数据
 *
 *  @param index  下标
 *  @param object 数据
 *
 *  @return 返回修改后的数据
 */
- (NSArray *)DQReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object;

/**
 *  NSArray 移动数组内两个下标下的数据
 *
 *  @param fromIndex 想移动的下标
 *  @param toIndex   移动到的下标
 *
 *  @return 返回修改后的数据
 */
- (NSArray *)DQMoveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/**
 *  NSArray 移动某个数据到一个下标下
 *
 *  @param object  数据
 *  @param toIndex 移动到的下标
 *
 *  @return 返回修改后的数据
 */
- (NSArray *)DQMoveObject:(id)object toIndex:(NSUInteger)toIndex;

@end

@interface NSMutableArray (DQCommon)

/**
 *  NSMutableArray 移动数组内两个下标下的数据
 *
 *  @param fromIndex 想移动的下标
 *  @param toIndex   移动到的下标
 */
- (void)DQMoveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/**
 *  NSMutableArray
 *
 *  @param object  移动的数据
 *  @param toIndex 移动到的下标
 */
- (void)DQMoveObject:(id)object toIndex:(NSUInteger)toIndex;

@end