//
//  LogisticsHeaderView.m
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LogisticsHeaderView.h"

@implementation LogisticsHeaderView

-(instancetype)initWithOneShopFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self)
    {
        self.icon=[[NetworkImageView alloc]init];
        self.icon.image=[UIImage imageNamed:@"Mall_1haodian"];
        [self addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(self.icon.mas_height);
        }];
        
        self.num =[UnityLHClass masonryLabel:@"2件商品" font:11.0 color:BM_WHITE];
        self.num.textAlignment=NSTextAlignmentCenter;
        self.num.backgroundColor=[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:0.5];
        [self.icon addSubview:self.num];
        [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
     
        UILabel *source=[UnityLHClass masonryLabel:@"承运来源：" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:source];
        self.source=[UnityLHClass masonryLabel:@"EMS" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:self.source];
        
        UILabel *order=[UnityLHClass masonryLabel:@"运单编号：" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:order];
        self.order=[UnityLHClass masonryLabel:@"11845415666132" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:self.order];
        
        
        [source mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
            make.bottom.mas_equalTo(self.mas_centerY).offset(-3);
        }];
        [self.source mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(source.mas_right).offset(3);
            make.centerY.mas_equalTo(source.mas_centerY);
        }];
        
        [order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
            make.top.mas_equalTo(self.mas_centerY).offset(3);
        }];
        [self.order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(order.mas_right).offset(3);
            make.centerY.mas_equalTo(order.mas_centerY);
        }];
        
    
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self)
    {
        self.icon=[[NetworkImageView alloc]init];
        self.icon.image=[UIImage imageNamed:@"Mall_1haodian"];
        [self addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(self.icon.mas_height);
        }];
        
        self.num =[UnityLHClass masonryLabel:@"2件商品" font:11.0 color:BM_WHITE];
        self.num.textAlignment=NSTextAlignmentCenter;
        self.num.backgroundColor=[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:0.5];
        [self.icon addSubview:self.num];
        [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *state=[UnityLHClass masonryLabel:@"物流状态：" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:state];
        self.state=[UnityLHClass masonryLabel:@"暂无" font:12.0 color:BM_Color_Blue];
        [self addSubview:self.state];
        
        UILabel *source=[UnityLHClass masonryLabel:@"承运来源：" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:source];
        self.source=[UnityLHClass masonryLabel:@"暂无" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:self.source];
        
        UILabel *order=[UnityLHClass masonryLabel:@"运单编号：" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:order];
        self.order=[UnityLHClass masonryLabel:@"暂无" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:self.order];
        
        UILabel *phone=[UnityLHClass masonryLabel:@"官方电话：" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:phone];
        self.phone=[UnityLHClass masonryLabel:@"暂无" font:12.0 color:BM_Color_GrayColor];
        [self addSubview:self.phone];
        
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
            make.bottom.mas_equalTo(source.mas_top).offset(-3);
        }];
        [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(state.mas_right).offset(3);
            make.centerY.mas_equalTo(state.mas_centerY);
        }];
        
        [source mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
            make.bottom.mas_equalTo(self.mas_centerY).offset(-1.5);
        }];
        [self.source mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(source.mas_right).offset(3);
            make.centerY.mas_equalTo(source.mas_centerY);
        }];
        
        [order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
            make.top.mas_equalTo(self.mas_centerY).offset(1.5);
        }];
        [self.order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(order.mas_right).offset(3);
            make.centerY.mas_equalTo(order.mas_centerY);
        }];

        
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
            make.top.mas_equalTo(order.mas_bottom).offset(3);
        }];
        [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(phone.mas_right).offset(3);
            make.centerY.mas_equalTo(phone.mas_centerY);
        }];
        
    
    }
    return self;
}
-(void)loadViewWithDataSource:(id)dataSource
{
    self.order.text=dataSource[@"nu"];
  
    switch ([dataSource[@"state"] intValue])
    {
        case 0:
        {
            self.state.text=@"在途中";

        }
            break;
        case 1:
        {
            self.state.text=@"揽件中";

        }
            break;
        case 2:
        {
            self.state.text=@"疑难件";
 
        }
            break;
        case 3:
        {
            self.state.text=@"已签收";

        }
            break;
        case 4:
        {
            self.state.text=@"已退签";

        }
            break;
        case 5:
        {
            self.state.text=@"派件中";

        }
            break;
        case 6:
        {
            self.state.text=@"已退回";

        }
            break;
            
        default:
            break;
    }
  
    NSDictionary *kuaiDiData=@{@"shunfeng":@{@"name":@"顺丰快递",@"phone":@"95338"},
                               @"ems":@{@"name":@"邮政EMS",@"phone":@"11183"},
                               @"shentong":@{@"name":@"申通快递",@"phone":@"95543"},
                               @"yuantong":@{@"name":@"圆通速递",@"phone":@"95554"},
                               @"zhongtong":@{@"name":@"中通快递",@"phone":@"95311"},
                               @"huitongkuaidi":@{@"name":@"百世汇通",@"phone":@"400-956-5656"},
                               @"yunda":@{@"name":@"韵达快递",@"phone":@"95546"},
                               };
    self.source.text=kuaiDiData[dataSource[@"com"]][@"name"];
    self.phone.text=kuaiDiData[dataSource[@"com"]][@"phone"];

    
}
-(void)loadOneShopViewWithDataSource:(id)dataSource
{
    self.num.hidden = YES;
    self.order.text = dataSource[@"expressNumber"];
    self.source.text =  dataSource[@"distributionSupplier"];
}

@end
