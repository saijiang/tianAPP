//
//  DiningDetailCell.h
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DiningDetailCell : UIView

@property (nonatomic,strong)LocalhostImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *contentLab;

-(void)loadDiningDetailCellWithDataSource:(id)dataSource;


-(void)loadViewWithImage:(NSString *)image title:(NSString *)title  content:(NSString *)content;

@end
