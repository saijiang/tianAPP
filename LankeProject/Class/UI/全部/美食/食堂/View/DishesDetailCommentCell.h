//
//  DishesDetailCommentCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface DishesDetailCommentCell : BaseTableViewCell<LKCellProtocol>

- (void) configForRepair:(id)data;
@end
