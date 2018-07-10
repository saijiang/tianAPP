//
//  SearchManager.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "DBAPIManager.h"

@interface SearchManager : DBAPIManager

@property(nonatomic,copy)NSString *search;
@property(nonatomic,copy)NSString *time;

+(void)saveData:(SearchManager *)model;

+(void)clearAllDataSource;


@end
