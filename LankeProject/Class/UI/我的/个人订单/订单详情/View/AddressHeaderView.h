//
//  AddressHeaderView.h
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressHeaderView : UIView

- (void)configWithMallViewModel:(id)viewModel;


-(void)loadViewWithDatasource:(NSDictionary *)dataSource;

-(void)loadViewWithMallDatasource:(NSDictionary *)dataSource;

@end
