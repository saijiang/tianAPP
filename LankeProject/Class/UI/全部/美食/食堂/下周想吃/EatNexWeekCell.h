//
//  EatNexWeekCell.h
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "LKCellProtocol.h"

@interface EatNexWeekCell : BaseCollectionCell<LKCellProtocol>

@property (nonatomic ,copy) void (^wantEatDishesHandle)();


@end
