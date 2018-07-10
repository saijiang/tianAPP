//
//  JDShopScreeningView.h
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDShopSearchItem;
@interface JDShopScreeningView : UIView

@property (nonatomic ,strong) JDShopSearchItem * item;
@property (nonatomic ,copy) void (^bSelectFilterHandle)();

- (void) clearFilterState;

@end

@interface JDShopSearchItem : NSObject

//productCname 	否 	string 	商品名称
//categorySearchCode 	否 	string 	分类id
//sort 	否 	string 	排序：1、价格升序，2、价格降序
//goodsSales 	否 	string 	排序：1、销量升序，2、销量降序
//priceRange 	否 	string 	价格筛选：0、0-50,1、50-100,2、100-200,3、200-500,4、大于500
@property (nonatomic ,strong) NSString * sales; // 销量
@property (nonatomic ,strong) NSString * productCname; // 商品名称
@property (nonatomic ,strong) NSString * sort;// 排序：价格排序（desc降序 asc升序）

@property (nonatomic ,strong) NSString * typeName;
@property (nonatomic ,strong) NSString * priceFilter;
@property (nonatomic ,strong) NSString * categorySearchCode;

@property (nonatomic ,strong) NSString * typeId;


- (void) clearFilter;
@end
