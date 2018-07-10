//
//  SqliteManager.m
//  MHProject
//
//  Created by 董駸 on 16/1/15.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "SqliteManager.h"
#import <sqlite3.h>

NSMutableDictionary *dataDictionary;

@interface SqliteManager ()
{
    sqlite3 *mySql;
}

@end

@implementation SqliteManager

//singleton_for_class(SqliteManager)

+ (SqliteManager *)sharedSqliteManager {
    static SqliteManager *sharedSqliteManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSqliteManager = [[self alloc] init];
        dataDictionary = [NSMutableDictionary dictionary];
    });
    return sharedSqliteManager;
}

- (NSString *)getDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
//    NSString *path = [myPath stringByAppendingPathComponent:@"MyData.sql"];
    return myPath;
}

- (NSString *)getSqlPath
{
    return [[self getDocPath] stringByAppendingPathComponent:@"MyData.sql"];
}

- (BOOL)fileExistByPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

- (BOOL)openData
{
    NSString *pathForData = [self getSqlPath];
    /*
     1,sqlite3_open(数据库文件路径，数据库);打开数据库
     2,sqlite3_close(数据库);关闭数据库
     3,SQLITE_OK(可操作状态 OK)
     */
    if (sqlite3_open([pathForData UTF8String],&mySql) != SQLITE_OK) {
        sqlite3_close(mySql);
        return NO;
    }
    return YES;
}

- (BOOL)creatTableByTableName:(NSString *)tableName param:(NSDictionary *)param
{
    if (!param || !tableName) {
        return NO;
    }
    if (!mySql) {
        [self openData];
    }
    sqlite3_stmt *stmt;
    //声明结构语句 保存结果对象
//    NSString *creatSQL = @"create table if not exists dishName (name text,bigImg text,tip text,introduction text,smallImg text)";
    [dataDictionary setValue:[param allKeys] forKey:tableName];
    [dataDictionary writeToFile:[NSString stringWithFormat:@"%@/%@keyword.plist",[self getDocPath],tableName] atomically:YES];
    
    NSString *creatSQL = [NSString stringWithFormat:@"create table if not exists %@ (",tableName];

    for (int i = 0; i < param.count; i++) {
        if (i == param.count - 1) {
            creatSQL = [NSString stringWithFormat:@"%@%@ %@)",creatSQL,[[param allKeys] objectAtIndex:i],[[param allValues] objectAtIndex:i]];
        } else {
            creatSQL = [NSString stringWithFormat:@"%@%@ %@,",creatSQL,[[param allKeys] objectAtIndex:i],[[param allValues] objectAtIndex:i]];
        }
    }
    
    //create table if not exists 表名(字段1 类型,字段2 类型,字段3 类型)
    //创建SQL语句
    if (sqlite3_prepare_v2(mySql, [creatSQL UTF8String], -1, &stmt, nil) != SQLITE_OK) {
        return NO;
    }
    //准备当前数据库
    sqlite3_step(stmt);
    //执行结构语句命令
    sqlite3_finalize(stmt);
    //释放结构语句命令
    return YES;
}

- (BOOL)insertDataByTableName:(NSString *)tableName data:(NSMutableArray *)data
{
    if (!data || !tableName) {
        return NO;
    }
    if (!mySql) {
        [self openData];
    }
    sqlite3_stmt *myStmt;
    
    if (![self getKeywordByTableName:tableName]) {
        return NO;
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into %@ (",tableName];
    NSString *valueStr = @"(";
    
    for (int i = 0; i < data.count; i++) {
        if (i == data.count - 1) {
            insertSQL = [NSString stringWithFormat:@"%@%@)",insertSQL,[[dataDictionary objectForKey:tableName] objectAtIndex:i]];
            valueStr = [NSString stringWithFormat:@"%@?)",valueStr];
        } else {
            insertSQL = [NSString stringWithFormat:@"%@%@,",insertSQL,[[dataDictionary objectForKey:tableName] objectAtIndex:i]];
            valueStr = [NSString stringWithFormat:@"%@?,",valueStr];
        }
    }
    insertSQL = [NSString stringWithFormat:@"%@ values %@",insertSQL,valueStr];
    
//    insertSQL = [NSString stringWithFormat:@"insert into dishName (name,bigImg,tip,introduction,smallImg) values (?,?,?,?,?)"];
    if (sqlite3_prepare_v2(mySql, [insertSQL UTF8String], -1, &myStmt, nil) != SQLITE_OK) {
        return NO;
    }
    
    for (int i = 0; i < data.count; i++)
    {
        if ([[data objectAtIndex:i] isKindOfClass:[NSString class]])
        {
            sqlite3_bind_text(myStmt, i + 1, [[data objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
        }
        else if ([[data objectAtIndex:i] isKindOfClass:[NSNumber class]])
        {
            NSNumber *value = [data objectAtIndex:i];
            if (strcmp([value objCType], @encode(int8_t)) == 0)
            {
                sqlite3_bind_text(myStmt, i + 1, [[data objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else if (strcmp([value objCType], @encode(int)) == 0)
            {
                sqlite3_bind_int(myStmt, i + 1, [value intValue]);
            }
            else if (strcmp([value objCType], @encode(double)) == 0)
            {
                sqlite3_bind_double(myStmt, i + 1, [value doubleValue]);
            }
        }
    }

    sqlite3_step(myStmt);
    sqlite3_finalize(myStmt);
    return YES;
}

- (BOOL)deleteDateByTableName:(NSString *)tableName keyWord:(NSString *)keyWord value:(id)value
{
    sqlite3_stmt *myStmt;
    if (!keyWord || !tableName) {
        return NO;
    }
    if (!mySql) {
        [self openData];
    }
    if (![self getKeywordByTableName:tableName]) {
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?",tableName,keyWord];
    if (sqlite3_prepare_v2(mySql, [sql UTF8String], -1, &myStmt, nil) != SQLITE_OK) {
        return NO;
    }
    
    //判断绑定数据
    if ([value isKindOfClass:[NSString class]])
    {
        sqlite3_bind_text(myStmt, 1, [value UTF8String], -1, SQLITE_TRANSIENT);
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        NSNumber *valueNum = value;
        if (strcmp([value objCType], @encode(int)) == 0)
        {
            sqlite3_bind_int(myStmt, 1, [valueNum intValue]);
        }
        else if (strcmp([value objCType], @encode(double)) == 0)
        {
            sqlite3_bind_double(myStmt,1, [valueNum doubleValue]);
        }
    }
    
    sqlite3_step(myStmt);
    sqlite3_finalize(myStmt);
    return YES;
}

- (BOOL)getKeywordByTableName:(NSString *)tableName
{
    if (dataDictionary.count != 0) {
        return YES;
    }
    if ([self fileExistByPath:[NSString stringWithFormat:@"%@/%@keyword.plist",[self getDocPath],tableName]]) {
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@keyword.plist",[self getDocPath],tableName]];
        return YES;
    } else {
        return NO;
    }
}

@end
