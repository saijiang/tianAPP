//
//  OrderInfoFooterView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "OrderInfoFooterView.h"

@interface OrderInfoFooterView ()

@property(nonatomic,strong)UILabel *orderNote;
@property(nonatomic,strong)UILabel *orderPrice;
@property(nonatomic,strong)UILabel *freightPrice;
@property(nonatomic,strong)UILabel *totalPrice;

@end

@implementation OrderInfoFooterView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        
        UILabel *orderNote=[UnityLHClass masonryLabel:@"备注" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:orderNote];
        [orderNote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.orderNote=[UnityLHClass masonryLabel:@"尽快送尽快送" font:15.0 color:BM_Color_GrayColor];
        self.orderNote.numberOfLines=0;
        self.orderNote.textAlignment=NSTextAlignmentRight;
        [self addSubview:self.orderNote];
        [self.orderNote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(orderNote.mas_top);
            make.height.mas_greaterThanOrEqualTo(10);
        }];
        
        UIView *lineOne=[[UIView alloc]init];
        [self addSubview:lineOne];
        lineOne.backgroundColor=BM_Color_SeparatorColor;
        [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.orderNote.mas_bottom).offset(15);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *orderPrice=[UnityLHClass masonryLabel:@"订单明细" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:orderPrice];
        [orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(lineOne.mas_bottom).offset(15);
            
        }];
        
        self.orderPrice=[UnityLHClass masonryLabel:@"¥190.00" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.orderPrice];
        [self.orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(orderPrice.mas_centerY);
            
        }];
        
        
        UILabel *freightPrice=[UnityLHClass masonryLabel:@"配送费" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:freightPrice];
        [freightPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(orderPrice.mas_bottom).offset(15);
            
        }];
        
        self.freightPrice=[UnityLHClass masonryLabel:@"¥0.00" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.freightPrice];
        [self.freightPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(freightPrice.mas_centerY);
            
        }];
        
        UIView *linetwo=[[UIView alloc]init];
        [self addSubview:linetwo];
        linetwo.backgroundColor=BM_Color_SeparatorColor;
        [linetwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(freightPrice.mas_bottom).offset(15);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *totalPrice=[UnityLHClass masonryLabel:@"合计" font:15.0 color:BM_BLACK];
        [self addSubview:totalPrice];
        [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(linetwo.mas_bottom).offset(15);
            
        }];
        
        self.totalPrice=[UnityLHClass masonryLabel:@"¥190.00" font:15.0 color:BM_ORANGE];
        [self addSubview:self.totalPrice];
        [self.totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(totalPrice.mas_centerY);
            
        }];
        
       
 
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.orderNote.mas_top).offset(-15);
        make.bottom.mas_equalTo(self.totalPrice.mas_bottom).offset(15);
    }];
    
}
-(void)loadViewWithDatasource:(NSDictionary *)dataSource
{
    self.orderNote.text=[NSString stringWithFormat:@"%@",dataSource[@"orderNote"]];
    self.orderPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"goodsSum"] floatValue]];
    self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"shippingFee"] floatValue]];
    self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"orderSum"] floatValue]];
    float preferential=[dataSource[@"couponOrderSum"] floatValue];
    if (preferential>0)
    {
        self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f(已优惠¥%.2f)",[dataSource[@"orderSum"] floatValue],preferential];

    }
}

@end
