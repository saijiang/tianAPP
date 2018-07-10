//
//  JDServiceApplyCell.h
//  LankeProject
//
//  Created by fud on 2017/12/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDServiceApplyCell : BaseTableViewCell

#pragma mark --- 京东售后cell赋值
- (void) configJDServiceCellWithData:(id)data;

@end


@interface JDServiceApplyHeaderView : UIView

@property (nonatomic ,strong) UILabel * orderNumberLabel;
@property (nonatomic ,strong) UILabel * orderDateLabel;

#pragma mark --- 京东售后headerview赋值
- (void) configJDServiceApplyHeaderViewWithData:(id)data;

@end
