//
//  LKPickSectionCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface LKPickSectionCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic ,strong) UILabel * sectionNameLabel;
- (void) config:(id)data;
@end
