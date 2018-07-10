//
//  MallOrderInfoFooterView.h
//  LankeProject
//
//  Created by itman on 17/1/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderStatusViewModel.h"

@interface MallOrderInfoFooterView : UIView

-(void)configMallWithViewModel:(id)viewModel;

/** 自营商品用 */
-(void)loadViewWithDatasource:(NSDictionary *)dataSource;
/** 一号店用 */
-(void)loadViewWithMallDatasource:(NSDictionary *)dataSource;

/** 团购用 */
-(void)loadViewWithGroupDatasource:(NSDictionary *)dataSource;

@end
