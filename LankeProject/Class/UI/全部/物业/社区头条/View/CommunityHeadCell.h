//
//  CommunityHeadCell.h
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CommunityHeadCell : BaseTableViewCell

@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *info;

+(float)getCellHightWithDataSource:(NSDictionary *)dataSource tableView:(UITableView *)tableView;

@end
