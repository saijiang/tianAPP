//
//  ExpenseCell.h
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ExpenseCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *nameLB;

@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) UILabel *priceLB;

@property (nonatomic, strong) UIView *line;
@end
