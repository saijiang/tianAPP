//
//  OrderNumView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "OrderNumView.h"
#import "FoodOrderStatusViewModel.h"
#import "GoodsOrderStatusViewModel.h"

@interface OrderNumView ()

@property(nonatomic,strong)UILabel *order;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *status;


@end

@implementation OrderNumView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
     
        self.backgroundColor=BM_WHITE;

        self.order=[UnityLHClass masonryLabel:@"订单号：12345678900" font:15.0 color:BM_BLACK];
        [self addSubview:self.order];
        [self.order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.status=[UnityLHClass masonryLabel:@"已完成" font:15.0 color:[UIColor colorWithRed:0.33 green:0.69 blue:0.85 alpha:1.00]];
        [self addSubview:self.status];
        [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.time=[UnityLHClass masonryLabel:@"下单时间：2016.12.19 08:30:59" font:15.0 color:[UIColor colorWithHexString:@"#999999"]];
        [self addSubview:self.time];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.order.mas_bottom).offset(10);
            
        }];
        
       
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.order.mas_top).offset(-15);
        make.bottom.mas_equalTo(self.time.mas_bottom).offset(15);
    }];
}

- (void)configWithViewModel:(FoodOrderStatusViewModel *)viewModel
{

    NSDictionary * dataSource = viewModel.data;
    NSString *orderTime= [UnityLHClass getCurrentTimeWithType:@"YYYY-MM-dd HH:mm:ss" andTimeString:dataSource[@"orderTime"]];
    self.order.text=[NSString stringWithFormat:@"订单号：%@",dataSource[@"id"]];
    self.time.text=[NSString stringWithFormat:@"下单时间：%@",orderTime];
    self.status.text = viewModel.orderStatus[@"title"];
    self.status.textColor = viewModel.orderStatus[@"color"];
}

- (void)configWithMallViewModel:(GoodsOrderStatusViewModel *)viewModel
{

    NSDictionary * dataSource = viewModel.orderData;
    if (viewModel.isJDShop)
    {
        self.order.text=[NSString stringWithFormat:@"订单号：%@",dataSource[@"jdOrderId"]];

        NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd HH:mm" andTimeString:dataSource[@"createDate"]];
        self.time.text=[NSString stringWithFormat:@"下单时间：%@",time];

    }
    else
    {
        self.order.text=[NSString stringWithFormat:@"订单号：%@",dataSource[@"orderCode"]];
        NSString *time=[NSString stringWithFormat:@"%@",dataSource[@"addTime"]] ;
        self.time.text=[NSString stringWithFormat:@"下单时间：%@",[time stringformatterDate:@"yyyy.MM.dd HH:mm:ss"]];

    }
    self.status.text = viewModel.orderStatus;
    self.status.textColor = viewModel.orderStatusColor;
}
@end
