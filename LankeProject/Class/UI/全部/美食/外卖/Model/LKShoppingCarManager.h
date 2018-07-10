//
//  LKShoppingCarManager.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKGoodsItem;
@interface LKShoppingCarManager : NSObject

@property (nonatomic ,strong ,readonly) NSMutableArray <LKGoodsItem *>* goods;
@property (nonatomic ,strong ,readonly) NSDictionary * currentShoppingCarInfo;

- (void) addGoods:(id)goods complete:(void(^)(id data))complete;
- (void) minusGoods:(id)goods complete:(void(^)(id data))complete;
- (void) deleteGoods:(id)goods complete:(void(^)(id data))complete;

- (LKGoodsItem *) addCountForGoods:(id)goods;
- (LKGoodsItem *) minusCountForGoods:(id)goods;

- (NSArray *) allGoods;
- (id) parseShoppingCarInfo;

- (void) configShoppingCarInfo:(id)data;

- (id) shoppingCarOrderInfo;

@end

@interface LKGoodsItem : NSObject

@property (nonatomic ,strong) id goodsInfo;

@property (nonatomic ,assign) NSInteger count;

@end
