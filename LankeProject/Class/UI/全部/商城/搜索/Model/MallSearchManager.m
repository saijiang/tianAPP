//
//  SearchManager.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSearchManager.h"

@implementation MallSearchManager

/** 删除搜索记录 */
+(BOOL)saveData:(MallSearchManager *)model
{
    //包含删除
    NSString *sql=[NSString stringWithFormat:@" WHERE searchTitle = \"%@\" ",model.searchTitle];
    if ([MallSearchManager deleteObjectsByCriteria:sql])
    {
        
        //保存
        return [model saveOrUpdate];
    }
    return [MallSearchManager deleteObjectsByCriteria:sql];
}

/** 删除所有的搜索记录 */
+(void)clearAllDataSource
{
    [MallSearchManager clearTable];
}

+ (BOOL) clearAllGoodsData{

    NSString *sql=[NSString stringWithFormat:@" WHERE type = 0"];
    
    return [MallSearchManager deleteObjectsByCriteria:sql];
}

+ (BOOL) clearAllShopData{
    
    NSString *sql=[NSString stringWithFormat:@" WHERE type = 1"];
    
    return [MallSearchManager deleteObjectsByCriteria:sql];
}

+ (NSArray *) goodsData{

    NSString * sql = [NSString stringWithFormat:@" WHERE type = 0 ORDER BY time DESC"];
    return [MallSearchManager findByCriteria:sql];
}

+ (NSArray *) shopData{
    
    NSString * sql = [NSString stringWithFormat:@" WHERE type = 1 ORDER BY time DESC"];
    return [MallSearchManager findByCriteria:sql];
}
@end
