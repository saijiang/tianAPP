//
//  ShoppingCarCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface ShoppingCarCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic ,copy) void (^bCountChangeHandle)(BOOL add);

@property (nonatomic ,copy) void (^bDeleteHandle)();
@end
