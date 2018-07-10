//
//  LKShoppingCarManager.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKShoppingCarManager.h"

@interface LKShoppingCarManager ()

@property (readwrite) NSMutableArray * goods;
@property (readwrite) NSDictionary * currentShoppingCarInfo;
@end

@implementation LKShoppingCarManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.goods = [NSMutableArray array];
        self.currentShoppingCarInfo = @{@"count":@([self allGoodsCount]),
                                        @"price":@([self allGoodsPrice])};
    }
    return self;
}

- (void) addGoods:(id)goods complete:(void(^)(id data))complete{

    BOOL hasContains = NO;
    NSInteger index = 0;
    NSMutableArray <LKGoodsItem *>* temp = [NSMutableArray arrayWithArray:self.goods];
    
    for (LKGoodsItem * item in self.goods) {
        if (item.goodsInfo == goods) {
            hasContains = YES;
            break;
        }
        index ++;
    }
    if (hasContains) {
        
        [temp replaceObjectAtIndex:index withObject:[self addCountForGoods:goods]];
        
    }else{
        
        LKGoodsItem * newItem = [[LKGoodsItem alloc] init];
        newItem.goodsInfo = goods;
        newItem.count = 1;
        [temp addObject:newItem];
    }
    [self.goods removeAllObjects];
    [self.goods addObjectsFromArray:temp];
    
    [self configCurrentShoppingInfo];
    if (complete) {
        complete(self.currentShoppingCarInfo);
    }
}

- (void) minusGoods:(id)goods complete:(void(^)(id data))complete{
    
    BOOL hasContains = NO;
    NSInteger index = 0;
    NSMutableArray <LKGoodsItem *>* temp = [NSMutableArray arrayWithArray:self.goods];
    
    for (LKGoodsItem * item in self.goods) {
        if (item.goodsInfo == goods) {
            hasContains = YES;
            break;
        }
        index ++;
    }
    if (hasContains) {
        
        LKGoodsItem * item = [self minusCountForGoods:goods];
        [temp replaceObjectAtIndex:index withObject:item];
        if (!item.count) {
            
            [temp removeObjectAtIndex:index];
        }
    }else{
        
        LKGoodsItem * newItem = [[LKGoodsItem alloc] init];
        newItem.goodsInfo = goods;
        newItem.count = 0;
        [temp addObject:newItem];
    }
    [self.goods removeAllObjects];
    [self.goods addObjectsFromArray:temp];
    
    [self configCurrentShoppingInfo];
    if (complete) {
        complete(self.currentShoppingCarInfo);
    }
}

- (void) deleteGoods:(id)goods complete:(void(^)(id data))complete{
    
    NSInteger index = NSNotFound;
    
    for (LKGoodsItem * item in self.goods) {
        
        if (item.goodsInfo == goods) {
            
            index = [self.goods indexOfObject:item];
        }
    }
    
    if (index == NSNotFound) {
    
        NSAssert(1, @"购物车中没有商品");
        
        return;
    }
    [self.goods removeObjectAtIndex:index];
    
    [self configCurrentShoppingInfo];
    if (complete) {
        complete(self.currentShoppingCarInfo);
    }
}

- (LKGoodsItem *) addCountForGoods:(id)goods{
 
    LKGoodsItem * tempItem = [[LKGoodsItem alloc] init];
    
    for (LKGoodsItem * item in self.goods) {
        
        if (item.goodsInfo == goods) {
            
            tempItem.count = ++ item.count;
            tempItem.goodsInfo = item.goodsInfo;
            break;
        }
    }
    [self configCurrentShoppingInfo];

    return tempItem;
}

- (LKGoodsItem *) minusCountForGoods:(id)goods{

    LKGoodsItem * tempItem = [[LKGoodsItem alloc] init];
    
    for (LKGoodsItem * item in self.goods) {
        
        if (item.goodsInfo == goods) {
            
            tempItem.count = -- item.count;
            tempItem.goodsInfo = item.goodsInfo;
            break;
        }
    }
    
    [self configCurrentShoppingInfo];
    return tempItem;
}

- (NSArray *) allGoods{

    return self.goods;
}
- (id) parseShoppingCarInfo{

    NSMutableArray * temp = [NSMutableArray array];
    
    for (LKGoodsItem * item in self.goods) {
        
        NSDictionary * data = @{@"dishesId":[NSString stringWithFormat:@"%@",item.goodsInfo[@"dishesId"]],
                                @"dishesFoodName":[NSString stringWithFormat:@"%@",item.goodsInfo[@"dishesFoodName"]],
                                @"dishesNum":[NSString stringWithFormat:@"%ld",(long)item.count]};
        [temp addObject:data];
    }
    
    return [JsonManager jsonWithDict:temp];
}

- (void) configShoppingCarInfo:(NSArray *)datas{

    if (datas.count) {
     
        NSMutableArray <LKGoodsItem *>* temp = [NSMutableArray array];
        
        for (NSDictionary * sectionObject in datas) {
            
            NSArray * dishesArray = sectionObject[@"dishes"];
            
            for (NSDictionary * goodsInfo in dishesArray) {
            
                NSInteger count = [goodsInfo[@"dishesNum"] intValue];
                if (count) {
                    
                    LKGoodsItem * newItem = [[LKGoodsItem alloc] init];
                    newItem.goodsInfo = goodsInfo;
                    newItem.count = count;
                    [temp addObject:newItem];
                }
            }
        }
        [self.goods removeAllObjects];
        [self.goods addObjectsFromArray:temp];
    }
    [self configCurrentShoppingInfo];
}

- (id) shoppingCarOrderInfo{

    NSMutableArray * temp = [NSMutableArray arrayWithArray:self.goods];
    
    NSDictionary * data = @{@"price":@([self allGoodsPrice]),
                            @"goodsArray":temp};
    return data;
}

#pragma mark -
#pragma mark Private M

- (void) configCurrentShoppingInfo{
    
    self.currentShoppingCarInfo = @{@"count":@([self allGoodsCount]),
                                    @"price":@([self allGoodsPrice])};
}
- (NSInteger) allGoodsCount{
    
    NSInteger count = 0;
    for (LKGoodsItem * item in self.goods) {
        
        count += item.count;
    }
    return count;
}

- (CGFloat) allGoodsPrice{

    CGFloat price = 0.0f;
    for (LKGoodsItem * item in self.goods) {
        
        price += ([item.goodsInfo[@"couponPrice"] floatValue] * item.count);
    }
    return price;
}

@end

@implementation LKGoodsItem

@end
