//
//  ArchiverManager.m
//  MHProject
//
//  Created by 董駸 on 16/1/7.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "ArchiverManager.h"

@implementation ArchiverManager : NSObject 

+ (BOOL)saveObject:(id)object forKey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    BOOL success = [data writeToFile:[ArchiverManager getPath] atomically:YES];
    
    return success;
}

+ (id)loadObjectForKey:(NSString *)key
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[ArchiverManager getPath]];
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unArchiver decodeObjectForKey:key];
}

+ (BOOL)removeObjectForkey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:nil forKey:key];
    [archiver finishEncoding];
    BOOL success = [data writeToFile:[ArchiverManager getPath] atomically:YES];
    
    return success;
}

+ (BOOL)removeAllObject
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL hasFile = [fileManager fileExistsAtPath:[ArchiverManager getPath]];
    if (!hasFile) {
        return NO;
    } else {
        [fileManager removeItemAtPath:[ArchiverManager getPath] error:&error];
        if (error) {
            return NO;
        } else {
            return YES;
        }
    }
//    return NO;
}

/**
 *  找本地路径
 *
 *  @return 返回路径
 */
+ (NSString *)getPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:k_FILE_NAME];
    return filePath;
}

@end
