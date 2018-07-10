//
//  OrderInfoCenterView.h
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoCenterView : UIView

-(void)loadViewWithDatasource:(NSDictionary *)dataSource;
-(void)loadViewWithReservationOrderInfo:(NSDictionary *)dataSource;

@end
