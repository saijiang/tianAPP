//
//  MallOrderConfirmGoodsCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface MallOrderConfirmGoodsCell : BaseTableViewCell<LKCellProtocol>
- (void)configOneShopCellWithData:(id)data;
- (void)configJDShopCellWithData:(id)data;

@end
