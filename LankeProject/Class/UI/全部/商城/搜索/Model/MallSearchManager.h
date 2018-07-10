//
//  SearchManager.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "DBAPIManager.h"

@interface MallSearchManager : DBAPIManager

@property(nonatomic,assign)NSTimeInterval time;//搜索时间
@property(nonatomic,assign)NSInteger type;//搜索类型0 商品  1店铺
@property(nonatomic,copy)NSString *searchTitle;//搜索关键词

+(BOOL)saveData:(MallSearchManager *)model;

+(void)clearAllDataSource;

+(BOOL)clearAllGoodsData;
+(BOOL)clearAllShopData;

+ (NSArray *) goodsData;
+ (NSArray *) shopData;
@end
