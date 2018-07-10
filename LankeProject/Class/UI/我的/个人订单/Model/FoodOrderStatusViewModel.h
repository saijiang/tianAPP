//
//  FoodOrderStatusViewModel.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodOrderStatusViewModel : NSObject

@property (nonatomic ,strong) id data;

@property (nonatomic ,strong) NSDictionary * orderStatus;
@property (nonatomic ,strong) NSArray * orderHandles;

@property (nonatomic ,assign ,getter=isTakeOut) BOOL takeOut;

+ (instancetype) viewModelWithData:(id)data;
+ (instancetype) viewModelWithTakeOutData:(id)takeOut;
@end

/** 使用一个ViewModel将订单的状态以及对应的操作集中处理
 不仅方便逻辑的处理，还简化了`订单列表`->`订单详情`的数据传递
 */

/** 订座订菜订单/外卖订单
 
 | 01|待付款  | `去付款`和`取消订单`|红色（FF6655）|
 | 02|已付款  |  none|绿色（7BE0A1）|
 | 03|商家确认 | none|绿色（7BE0A1）|
 | 04|未成功  |  none|灰色（999999)|
 | 05|已完成  | `删除订单`|灰色（999999)|
 | 06|无效    | `删除订单`|灰色（999999)|
 */

/** 订座订单
 
 | 订单编号 | 订单状态 | 对应操作 |
 | 01|待确定 |`取消订单`|红色（FF6655）
 | 02|商家确认  |none|绿色（7BE0A1）
 | 03|未成功 |  none|灰色（999999）
 | 04|已完成  |`删除订单`|灰色（999999）
 | 05|无效  | `删除订单`|灰色（999999）
 */
