//
//  SqliteManager.h
//  MHProject
//
//  Created by 董駸 on 16/1/15.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"   // 单例模板
#import <UIKit/UIKit.h>

#define DEF_DOUBLE   @"double"
#define DEF_TEXT     @"text"
#define DEF_INTEGER  @"integer"

@interface SqliteManager : NSObject

singleton_for_header(SqliteManager)

- (BOOL)creatTableByTableName:(NSString *)tableName param:(NSDictionary *)param;

- (BOOL)insertDataByTableName:(NSString *)tableName data:(NSMutableArray *)data;

- (BOOL)deleteDateByTableName:(NSString *)tableName keyWord:(NSString *)keyWord value:(id)value;

@end
