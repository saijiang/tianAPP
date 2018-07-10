//
//  NSArray+Common.m
//  MHProject
//
//  Created by 董駸 on 16/1/22.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "NSArray+DQCommon.h"

@interface NSArray ()

@end

@implementation NSArray (DQCommon)

- (NSArray *)DQAddObject:(id)object
{
    NSMutableArray *array = [self mutableCopy];
    [array addObject:object];
    return [array copy];
}

- (NSArray *)DQInsertObject:(id)object atIndex:(NSUInteger)index
{
    NSMutableArray *array = [self mutableCopy];
    [array insertObject:object atIndex:index];
    return [array copy];
}

- (NSArray *)DQRemoveObject:(id)object
{
    NSMutableArray *array = [self mutableCopy];
    [array removeObject:object];
    return [array copy];
}

- (NSArray *)DQRemoveObjectAtIndex:(NSUInteger)index
{
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectAtIndex:index];
    
    return [array copy];
}

- (NSArray *)DQMoveLastObject
{
    NSMutableArray *array = [self mutableCopy];
    [array removeLastObject];
    return [array copy];
}

- (NSArray *)DQReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    NSMutableArray *array = [self mutableCopy];
    [array replaceObjectAtIndex:index withObject:object];
    return [array copy];
}

- (NSArray *)DQMoveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return self;
    }
    NSMutableArray *array = [self mutableCopy];
    if (toIndex != fromIndex && fromIndex < [array count] && toIndex< [array count])
    {
        id obj = [self objectAtIndex:fromIndex];
        [array removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count])
        {
            [array addObject:obj];
        } else {
            [array insertObject:obj atIndex:toIndex];
        }
    }
    return [array copy];
}

- (NSArray *)DQMoveObject:(id)object toIndex:(NSUInteger)toIndex
{
    NSUInteger fromIndex = [self indexOfObject:object];
    return [self DQMoveObjectFromIndex:fromIndex toIndex:toIndex];
}

@end

@implementation NSMutableArray (DQCommon)

- (void)DQMoveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    
    if (fromIndex == toIndex) {
        return;
    }
    if (toIndex != fromIndex && fromIndex < [self count] && toIndex< [self count])
    {
        id obj = [self objectAtIndex:fromIndex];
        [self removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count])
        {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:toIndex];
        }
    }
}

- (void)DQMoveObject:(id)object toIndex:(NSUInteger)toIndex
{
    NSUInteger fromIndex = [self indexOfObject:object];
    [self DQMoveObjectFromIndex:fromIndex toIndex:toIndex];
}

@end
