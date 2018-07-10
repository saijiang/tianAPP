//
//  LKPickRowTakeOutCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "LKCellProtocol.h"

@interface LKXXXXXSection : NSObject

@property (nonatomic ,strong) id data;

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSArray * items;

+ (instancetype) section:(id)data;
@end

@interface LKXXXXXItem : NSObject

@property (nonatomic ,strong) id data;

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSURL * image;
@property (nonatomic ,strong) NSString * price;//商品打过后的价格
@property (nonatomic ,strong) NSString * couponPrice;//商品原来价格

@property (nonatomic ,assign) NSInteger count;
@property (nonatomic ,assign) BOOL displayMinus;

+ (instancetype) item:(id)data;

@end

@interface LKPickRowTakeOutCell : BaseCollectionCell<LKCellProtocol>

@property (nonatomic ,strong) LKXXXXXItem * item;

@property (nonatomic ,strong) UIButton * minusButton;
@property (nonatomic ,strong) UIButton * buyButton;
@property (nonatomic ,strong) UIButton * countButton;
@property (nonatomic ,strong) UIButton * addButton;

@property (nonatomic ,copy) void (^bMinusDishesHandle)(LKPickRowTakeOutCell * cell);
@property (nonatomic ,copy) void (^bBuyDishesHandle)(LKPickRowTakeOutCell * cell);

- (void) configCellWithData_:(id)data;
@end
