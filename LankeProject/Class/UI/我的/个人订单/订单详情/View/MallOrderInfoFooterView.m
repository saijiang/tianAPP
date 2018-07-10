//
//  MallOrderInfoFooterView.m
//  LankeProject
//
//  Created by itman on 17/1/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderInfoFooterView.h"

@interface MallOrderInfoFooterView ()

@property(nonatomic,strong)UIView *orderNoteView;
@property(nonatomic,strong)UILabel *orderNote;
@property(nonatomic,strong)UILabel *orderPrice;
@property(nonatomic,strong)UILabel *freightPrice;
@property(nonatomic,strong)UILabel *totalPrice;

@property (nonatomic ,strong) UILabel * totalDisplayLabel;
@end

@implementation MallOrderInfoFooterView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        
        self.orderNoteView=[[UIView alloc]init];
        self.orderNoteView.clipsToBounds=YES;
        [self addSubview:self.orderNoteView];
        [self.orderNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(0);
            
        }];
        
        
        self.orderNote=[UnityLHClass masonryLabel:@"尽快送尽快送" font:15.0 color:BM_Color_GrayColor];
        self.orderNote.numberOfLines=0;
        self.orderNote.textAlignment=NSTextAlignmentRight;
        [self.orderNoteView addSubview:self.orderNote];
        [self.orderNote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.orderNoteView.mas_centerY);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        
        UILabel *orderNote=[UnityLHClass masonryLabel:@"备注" font:15.0 color:BM_Color_GrayColor];
        [self.orderNoteView addSubview:orderNote];
        [orderNote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.orderNote.mas_top);
            
        }];
        
        [self.orderNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.orderNote.mas_top).offset(-10);
            make.bottom.mas_equalTo(self.orderNote.mas_bottom).offset(10);
            
        }];
        UIView *lineOne=[[UIView alloc]init];
        [self.orderNoteView addSubview:lineOne];
        lineOne.backgroundColor=BM_Color_SeparatorColor;
        [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(self.orderNoteView.mas_bottom);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *orderPrice=[UnityLHClass masonryLabel:@"商品总价" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:orderPrice];
        [orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.orderNoteView.mas_bottom).offset(15);
            
        }];
        
        self.orderPrice=[UnityLHClass masonryLabel:@"¥190.00" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.orderPrice];
        [self.orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(orderPrice.mas_centerY);
            
        }];
        
        
        UILabel *freightPrice=[UnityLHClass masonryLabel:@"运费" font:15.0 color:BM_Color_GrayColor];
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
        self.totalDisplayLabel = totalPrice;
        
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
        make.top.mas_equalTo(self.orderNoteView.mas_top);
        make.bottom.mas_equalTo(self.totalPrice.mas_bottom).offset(15);
    }];
    
}
-(void)configMallWithViewModel:(GoodsOrderStatusViewModel *)viewModel
{
    if (viewModel.isJDShop)
    {
        [self loadViewWithJDMallDatasource:viewModel.orderData];
        
    }
    else if (viewModel.isGroupGoods)
    {
        [self loadViewWithGroupDatasource:viewModel.orderData];
        
    }
    else if (viewModel.isOneNumberShop)
    {
        [self loadViewWithMallDatasource:viewModel.orderData];
        
    }
    else
    {
        [self loadViewWithDatasource:viewModel.orderData];
        
    }
}
//
-(void)loadViewWithDatasource:(NSDictionary *)dataSource
{

    self.orderNote.text=[NSString stringWithFormat:@"%@",dataSource[@"orderNote"]];
    
    // comment for some loop bug 20170329: 团购的订单详情
    //self.orderPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"goodsSum"] floatValue]];
    //self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"orderSum"] floatValue]];
    
    self.orderPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"goodsAmount"] floatValue]];
    self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"shippingFee"] floatValue]];
    self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"orderAmount"] floatValue]];
    
    float couponOrderAmount =[dataSource[@"couponOrderAmount"] floatValue];
    if (couponOrderAmount>0)
    {
        self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f(已优惠¥%.2f)",[dataSource[@"orderAmount"] floatValue],couponOrderAmount];

    }
}
//
-(void)loadViewWithMallDatasource:(NSDictionary *)dataSource
{
    [self.orderNoteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    self.orderPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"goodsAmount"] floatValue]];
    self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"postfee"] floatValue]];
    if ([dataSource.allKeys containsObject:@"postfee"]) {
        self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"postfee"] floatValue]];//自营详情shippingFee  一号店详情postfee
    }
    if ([dataSource.allKeys containsObject:@"shippingFee"])
    {
        
        self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"shippingFee"] floatValue]];//自营详情shippingFee  一号店详情postfee
    }
    self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"orderAmount"] floatValue]];

}
-(void)loadViewWithJDMallDatasource:(NSDictionary *)dataSource
{
    [self.orderNoteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    self.orderPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"priceWithOutFreight"] floatValue]];
    self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"freight"] floatValue]];
//    if ([dataSource.allKeys containsObject:@"postfee"]) {
//        self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"postfee"] floatValue]];//自营详情shippingFee  一号店详情postfee
//    }
//    if ([dataSource.allKeys containsObject:@"shippingFee"])
//    {
//        
//        self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"shippingFee"] floatValue]];//自营详情shippingFee  一号店详情postfee
//    }
    self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"zkOrderPrice"] floatValue]];
    
}
/** 团购用 */
-(void)loadViewWithGroupDatasource:(NSDictionary *)dataSource
{
    self.totalDisplayLabel.text = @"订单总额";
    self.orderNote.text=[NSString stringWithFormat:@"%@",dataSource[@"orderNote"]];
    self.orderPrice.text=[NSString stringWithFormat:@"¥%.2f",([dataSource[@"goodsPrice"] floatValue] * [dataSource[@"goodsNum"] integerValue])];
    self.freightPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"shippingFee"] floatValue]];
    self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"orderAmount"] floatValue]];
    float couponOrderAmount =[dataSource[@"couponOrderAmount"] floatValue];
    if (couponOrderAmount>0)
    {
        self.totalPrice.text=[NSString stringWithFormat:@"¥%.2f(已优惠¥%.2f)",[dataSource[@"orderAmount"] floatValue],couponOrderAmount];
        
    }

}

@end
