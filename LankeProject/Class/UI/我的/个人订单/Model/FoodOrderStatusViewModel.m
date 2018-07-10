//
//  FoodOrderStatusViewModel.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FoodOrderStatusViewModel.h"

@implementation FoodOrderStatusViewModel

+ (instancetype) viewModelWithData:(id)data{
    
    FoodOrderStatusViewModel * viewModel = [[FoodOrderStatusViewModel alloc] init];
    
    viewModel.data = data;
    
    [viewModel configOrderCellWithData:data];
    
    return viewModel;
}

+ (instancetype)viewModelWithTakeOutData:(id)takeOut{
    
    FoodOrderStatusViewModel * viewModel = [[FoodOrderStatusViewModel alloc] init];
    
    viewModel.data = takeOut;
    
    [viewModel configTakeOutCellWithData:takeOut];
    
    return viewModel;
}

// 订座，订座里面又分订座、订座订餐
- (void)configOrderCellWithData:(id)data{
    
    NSInteger reservationType = [data[@"reservationType"] intValue];
    
    if (reservationType == 1) {
        
        [self orderStateForOrderWithOrderState:[data[@"orderState"] integerValue]];
    }else if (reservationType == 2){// 订座定菜
        
        [self orderStateForTakeOutOrOrderDishesWithOrderState:[data[@"orderState"] integerValue] isTakeout:NO];
    }
}

// 外卖
- (void)configTakeOutCellWithData:(id)data{
    
    [self orderStateForTakeOutOrOrderDishesWithOrderState:[data[@"orderState"] integerValue] isTakeout:YES];
}

/** 订座订菜订单/外卖订单
 
 | 01|待付款  | `去付款`和`取消订单`|红色（FF6655）|
 | 02|已付款  |  none|绿色（7BE0A1）|
 | 03|商家确认 | none|绿色（7BE0A1）|
 | 04|未成功  |  none|灰色（999999)|
 | 05|已完成  | `删除订单`|灰色（999999)|
 | 06|无效    | `删除订单`|灰色（999999)|
 */
- (void) orderStateForTakeOutOrOrderDishesWithOrderState:(NSInteger)orderState isTakeout:(BOOL)takeOut{
    
    self.takeOut = takeOut;
    
    NSString * status;
    UIColor * statusColor;
    
    NSArray * orderHandles;
    if (orderState == 1) {
        
        status = @"待付款";
        statusColor = [UIColor colorWithHexString:@"#FF6655"];
        
        NSString * leftHandleTitle = @"取消订单";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"去付款";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"53B1D9"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@0},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@0}];
        
    }else if (orderState == 2){
        
        status = @"已付款待确认";
        statusColor = [UIColor colorWithHexString:@"#7BE0A1"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"53B1D9"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@1}];
        
    }else if (orderState == 3) {
        
        status = @"商家确认";
        statusColor = [UIColor colorWithHexString:@"#7BE0A1"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"53B1D9"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@1}];
        
    }else if (orderState == 4) {
        
        status = @"未成功";
        statusColor = [UIColor colorWithHexString:@"#999999"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"53B1D9"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@1}];
        
    }else if (orderState == 5) {
        
        status = @"已完成";
        statusColor = [UIColor colorWithHexString:@"#999999"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"删除订单";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@0}];
        
    }else if (orderState == 6) {
        
        status = @"无效";
        statusColor = [UIColor colorWithHexString:@"#999999"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"删除订单";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@0}];
    }
    
    self.orderStatus = @{@"title":status,
                         @"color":statusColor};
    
    self.orderHandles = orderHandles;
}

/** 订座订单
 
 | 订单编号 | 订单状态 | 对应操作 |
 | 01|待确定 |`取消订单`|红色（FF6655）
 | 02|商家确认  |none|绿色（7BE0A1）
 | 03|未成功 |  none|灰色（999999）
 | 04|已完成  |`删除订单`|灰色（999999）
 | 05|无效  | `删除订单`|灰色（999999）
 */
- (void) orderStateForOrderWithOrderState:(NSInteger)orderState{
    
    self.takeOut = NO;
    
    NSString * status;
    UIColor * statusColor;
    
    NSArray * orderHandles;
    
    if (orderState == 1) {
        
        status = @"待确定";
        statusColor = [UIColor colorWithHexString:@"#FF6655"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"取消订单";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@0}];
    }else if (orderState == 2){
        
        status = @"商家确认";
        statusColor = [UIColor colorWithHexString:@"#7BE0A1"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@1}];
        
    }else if (orderState == 3) {
        
        status = @"未成功";
        statusColor = [UIColor colorWithHexString:@"#999999"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@1}];
        
    }else if (orderState == 4) {
        
        status = @"已完成";
        statusColor = [UIColor colorWithHexString:@"#999999"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"删除订单";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@0}];
        
    }else if (orderState == 5) {
        
        status = @"无效";
        statusColor = [UIColor colorWithHexString:@"#999999"];
        
        NSString * leftHandleTitle = @"";
        UIColor * leftHandleColor = [UIColor colorWithHexString:@"cccccc"];
        
        NSString * rightHandleTitle = @"删除订单";
        UIColor * rightHandleColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        orderHandles = @[@{@"title":leftHandleTitle,
                           @"color":leftHandleColor,
                           @"hiden":@1},
                         @{@"title":rightHandleTitle,
                           @"color":rightHandleColor,
                           @"hiden":@0}];
    }
    
    self.orderStatus = @{@"title":status,
                         @"color":statusColor};
    
    self.orderHandles = orderHandles;
}


@end
