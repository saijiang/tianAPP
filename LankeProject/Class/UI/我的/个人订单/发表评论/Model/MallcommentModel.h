//
//  MallcommentModel.h
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBAPIManager.h"
@interface MallcommentModel : DBAPIManager

//"goodsId": "1",
//"goodsName": "1111",
//"evalScores": "1"
//"evalContent": "1"

@property(nonatomic,strong)NSString *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *evalScores;
@property(nonatomic,strong)NSString *evalContent;
@property(nonatomic,strong)NSString *goodImage;

+(instancetype)initModelwithDataSource:(id)data;
+(instancetype)initOneShopModelwithDataSource:(id)data;
//京东评价
+(instancetype)initJDShopModelwithDataSource:(id)data;

@end
