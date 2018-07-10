//
//  OrderInfoFooterTwoView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "OrderInfoFooterTwoView.h"

@interface OrderInfoFooterTwoView ()

@property(nonatomic,strong)UILabel *orderNote;
@property(nonatomic,strong)UILabel *totalPrice;

@end

@implementation OrderInfoFooterTwoView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        
        UILabel *orderNote=[UnityLHClass masonryLabel:@"已预定菜品" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:orderNote];
        [orderNote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.orderNote=[UnityLHClass masonryLabel:@"¥190.00" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.orderNote];
        [self.orderNote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(orderNote.mas_centerY);
            
        }];
        
        UIView *lineOne=[[UIView alloc]init];
        [self addSubview:lineOne];
        lineOne.backgroundColor=BM_Color_SeparatorColor;
        [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(orderNote.mas_bottom).offset(15);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *totalPrice=[UnityLHClass masonryLabel:@"合计" font:15.0 color:BM_BLACK];
        [self addSubview:totalPrice];
        [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(lineOne.mas_bottom).offset(15);
            
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
    float couponOrderSum=[dataSource[@"couponOrderSum"] floatValue];//订单优惠
    float orderSum=[dataSource[@"orderSum"] floatValue];//订单实际支付总价
    float goodsSum=[dataSource[@"goodsSum"] floatValue];//订单总价
    self.orderNote.text=[NSString stringWithFormat:@"¥%.2f",goodsSum];
    self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",orderSum];
    if (couponOrderSum>0)
    {
        self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f(已优惠¥%.2f)",orderSum,couponOrderSum];

    }

}

@end
