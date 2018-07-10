//
//  LogisticsCell.h
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LogisticsCell : BaseTableViewCell

@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UIImageView *topLine;
@property(nonatomic,strong)UIImageView *centerDian;
@property(nonatomic,strong)UIImageView *bottomLine;

@property(nonatomic,strong)UILabel *personLab;//经办人（ 京东审核进度页面 ）

-(void)loadOneShopCellWithDataSource:(id)dataSource;

//京东服务单进度cell赋值
-(void)loadJDCellWithDataSource:(id)dataSource;
//京东物流cell
-(void)loadJDshopCellWithDataSource:(id)dataSource;

+(float)getCellHightWithDatasource:(id)dataSource;
+(float)getOneShopCellHightWithDatasource:(id)dataSource;
//京东物流cell高度
+(float)getJDshopCellHightWithDatasource:(id)dataSource;

@end
