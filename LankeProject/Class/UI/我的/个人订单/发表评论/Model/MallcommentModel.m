//
//  MallcommentModel.m
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallcommentModel.h"

@implementation MallcommentModel

+(instancetype)initModelwithDataSource:(id)data
{
    MallcommentModel *model=[[MallcommentModel alloc]init];
    model.goodsId=data[@"goodsId"];
    model.goodsName=data[@"goodsName"];
    model.goodImage=data[@"goodsImageList"];
    model.evalScores=@"5";
    return model;
}
+(instancetype)initOneShopModelwithDataSource:(id)data
{
    MallcommentModel *model=[[MallcommentModel alloc]init];
    model.goodsId=data[@"productId"];
    model.goodsName=data[@"productCname"];
    model.goodImage=data[@"defaultImage"];
    model.evalScores=@"5";
    return model;
}

//京东评价
+(instancetype)initJDShopModelwithDataSource:(id)data
{
    MallcommentModel *model=[[MallcommentModel alloc]init];
    model.goodsId=data[@"id"];
    model.goodsName=data[@"name"];
    model.goodImage=data[@"imagePath"];
    model.evalScores=@"5";
    return model;
}

@end
