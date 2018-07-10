//
//  HeadlthInqurylCategoryCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/16.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface HeadlthInqurylCategoryCell : BaseTableViewCell<LKCellProtocol>

- (void) configHRCellWithData:(id)data index:(NSInteger)index;
@end
