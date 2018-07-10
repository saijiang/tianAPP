//
//  DBHelperManger.h
//  LankeProject
//
//  Created by itman on 16/10/20.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBHelperManager : NSObject


@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (DBHelperManager *)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;


@end
