//
//  LogisticsHeaderView.h
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsHeaderView : UIView

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *state;
@property(nonatomic,strong)UILabel *source;
@property(nonatomic,strong)UILabel *order;
@property(nonatomic,strong)UILabel *phone;

-(instancetype)initWithOneShopFrame:(CGRect)frame;

-(void)loadViewWithDataSource:(id)dataSource;
-(void)loadOneShopViewWithDataSource:(id)dataSource;

@end
