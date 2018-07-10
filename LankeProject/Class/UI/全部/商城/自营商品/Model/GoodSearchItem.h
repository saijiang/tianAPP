//
//  GoodSearchItem.h
//  LankeProject
//
//  Created by itman on 17/1/12.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodSearchItem : NSObject

//goodsName 	否 	string 	商品名称
//goodsSales 	否 	string 	销量（0降序 1升序）
//isPrice 	否 	string 	价格（0降序 1升序）
//goodsComment 	否 	string 	好评（0降序 1升序）
//brandId 	否 	string 	品牌id
//marketPrice 	否 	string 	价格区间（0：0-50，1：50-100，2：100-200，3：200-500，4：500以上）
//classOneId 	否 	string 	一级分类Id
//classTwoId 	否 	string 	二级分类Id
//classThridId 	String 	三级分类id
//classNameThird 	String 	三级分类名称
//pageIndex 	是 	string 	当前页
//pageSize 	是 	string 	每页条数

@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsSales;
@property(nonatomic,copy)NSString *isPrice;
@property(nonatomic,copy)NSString *goodsComment;
@property(nonatomic,copy)NSString *brandId;
@property(nonatomic,copy)NSString *marketPrice;

@property(nonatomic,copy)NSString *classOneName;
@property(nonatomic,copy)NSString *classOneId;
@property(nonatomic,copy)NSString *classTwoName;
@property(nonatomic,copy)NSString *classTwoId;
@property(nonatomic,copy)NSString *classNameThird;
@property(nonatomic,copy)NSString *classThridId;

@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,assign)NSInteger pageSize;

@end
