//
//  HistorySearchCell.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HistorySearchCell : BaseTableViewCell

@property(nonatomic,strong)UILabel *searceTitle;

@property (nonatomic ,copy) void (^bSearchHistoryDeleteHandle)();
@end
