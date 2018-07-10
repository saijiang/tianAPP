//
//  AfterSalesOrderCell.h
//  LankeProject
//
//  Created by itman on 17/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface AfterSalesOrderCell : BaseTableViewCell

@property(nonatomic,strong)UILabel *merchantName;
@property(nonatomic,strong)UILabel *returnState;
@property(nonatomic,strong)UILabel *order;
@property(nonatomic,strong)NetworkImageView *goodsImage;
@property(nonatomic,strong)UILabel *goodsName;
@property(nonatomic,strong)UILabel *goodsNum;
@property(nonatomic,strong)UILabel *orderRefund;
@property(nonatomic,strong)UIButton *deleteOrder;
@property(nonatomic,strong)UIButton *deleteTwoOrder;

+(CGFloat)getCellWithDataSource:(id)dataSource;

@end
