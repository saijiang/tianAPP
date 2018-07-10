//
//  BaseTableViewCell.h
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic,strong)id data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHightWithDataSource:(id)dataSource;
+ (CGFloat)getCellHeight;

-(void)createCell;
-(void)loadCellWithDataSource:(id)dataSource;

//加载的疗养券
-(void)loadThearyCellWithDataSource:(id)dataSource;
//疗养券消费
-(void)loadThearyCellUserDetailsWithDataSource:(id)dataSource;
@end
