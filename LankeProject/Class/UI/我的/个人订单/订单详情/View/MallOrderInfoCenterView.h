//
//  MallOrderInfoCenterView.h
//  LankeProject
//
//  Created by itman on 17/1/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderStatusViewModel.h"

@interface MallOrderInfoCenterView : UIView

-(void)configWithMallViewModel:(id )viewModel;


@end

@interface MallOrderInfoCenterCell : BaseTableViewCell

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UIButton *refund;

-(void)loadOneShopViewWithDatasource:(NSDictionary *)dataSource;
-(void)loadCellWithGroupDataSource:(NSDictionary *)dataSource;
- (void) configForGroupBuyPay:(id)data;
-(void)loadJDShopViewWithDatasource:(NSDictionary *)dataSource;

@end
