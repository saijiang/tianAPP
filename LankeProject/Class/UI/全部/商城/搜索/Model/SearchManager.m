//
//  SearchManager.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SearchManager.h"

@implementation SearchManager

+(void)saveData:(SearchManager *)model
{
    //包含删除
    NSString *sql=[NSString stringWithFormat:@"where search = %@",model.search];
    [SearchManager deleteObjectsByCriteria:sql];
    //保存
    [model saveOrUpdate];

}
+(void)clearAllDataSource
{
    [SearchManager clearTable];
}

@end
