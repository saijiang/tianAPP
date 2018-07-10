//
//  MyGoodsOrderCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"
#import "GoodsOrderStatusViewModel.h"

@interface MyGoodsOrderCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic ,strong) GoodsOrderStatusViewModel * viewModel;

- (void) configOneNumberShopCellWithData:(GoodsOrderStatusViewModel *)viewModel;
- (void) configGroupCellWithData:(GoodsOrderStatusViewModel *)viewModel;
//京东订单cell赋值
- (void) configJDShopCellWithData:(GoodsOrderStatusViewModel *)viewModel;





@end
