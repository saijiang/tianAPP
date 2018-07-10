//
//  AddressHeaderView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AddressHeaderView.h"
#import "GoodsOrderStatusViewModel.h"

@interface AddressHeaderView ()

@property(nonatomic,strong)UIView *shopNameView;
@property(nonatomic,strong)UILabel *shopName;

@property(nonatomic,strong)UIView *addressView;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *address;


@end

@implementation AddressHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.shopNameView=[[UIView alloc]init];
        self.shopNameView.clipsToBounds=YES;
        [self addSubview:self.shopNameView];
        [self.shopNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.mas_equalTo(0);
            make.height.mas_equalTo(0);

        }];
        
        LocalhostImageView *shopIcon=[[LocalhostImageView alloc]init];
        [self.shopNameView addSubview:shopIcon];
        shopIcon.image=[UIImage imageNamed:@"mall_shop"];
        [shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.shopNameView.mas_centerY);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
        }];
        
        
        self.shopName=[UnityLHClass masonryLabel:@"成品果业旗舰店" font:15.0 color:BM_BLACK];
        [self.shopNameView addSubview:self.shopName];
        [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(shopIcon.mas_right).offset(10);
            make.centerY.mas_equalTo(self.shopNameView.mas_centerY);
        }];

        self.addressView=[[UIView alloc]init];
        self.addressView.clipsToBounds=YES;
        self.addressView.toplineWithColor=BM_Color_SeparatorColor;
        [self addSubview:self.addressView];
     

        
        LocalhostImageView *loaction=[[LocalhostImageView alloc]init];
        [self.addressView addSubview:loaction];
        loaction.image=[UIImage imageNamed:@"ding_dingwei"];
        [loaction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.addressView.mas_centerY);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
        }];
        
        
        self.name=[UnityLHClass masonryLabel:@"收货人：" font:15.0 color:BM_BLACK];
        [self.addressView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(15);
        }];
        
        self.phone=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_Color_GrayColor];
        [self.addressView addSubview:self.phone];
        [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.addressView.mas_right).offset(-10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.address=[UnityLHClass masonryLabel:@" " font:15.0 color:BM_BLACK];
        [self.addressView addSubview:self.address];
        self.address.numberOfLines=0;
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.addressView.mas_right).offset(-10);
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(self.name.mas_bottom).offset(10);
            
        }];
        
        [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(self.shopNameView.mas_bottom);
            make.bottom.mas_equalTo(self.address.mas_bottom).offset(10);

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
        make.top.mas_equalTo(self.shopNameView.mas_top);
        make.bottom.mas_equalTo(self.addressView.mas_bottom);
    }];
}
-(void)loadViewWithDatasource:(NSDictionary *)dataSource
{
    //takeOutType 	string 	外卖订单类型，01、自提，02、送货上门
    if ([dataSource[@"takeOutType"] integerValue]==2)
    {
        self.name.text=[NSString stringWithFormat:@"收货人：%@",dataSource[@"contactName"]];
        self.phone.text=[NSString stringWithFormat:@"%@",dataSource[@"contactMobile"]];
        self.address.text=[NSString stringWithFormat:@"收货地址：%@",dataSource[@"deliveryAddress"]];
    }
    else
    {
        self.name.text=[NSString stringWithFormat:@"收货人：%@",dataSource[@"contactName"]];
        self.phone.text=[NSString stringWithFormat:@"%@",dataSource[@"contactMobile"]];
        self.address.text=[NSString stringWithFormat:@"自提地址：%@",dataSource[@"deliveryAddress"]];
//        [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.mas_centerY);
//            
//        }];
    }

}
- (void)configWithMallViewModel:(GoodsOrderStatusViewModel *)viewModel;
{
   
    if (viewModel.isJDShop) {
        [self loadViewWithJDMallDatasource:viewModel.orderData];

    }else{
    [self loadViewWithMallDatasource:viewModel.orderData];
    if (viewModel.isGroupGoods)
    {
        self.shopName.text=viewModel.orderData[@"merchantName"];
        [self.shopNameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
    }
    }
    
}
-(void)loadViewWithMallDatasource:(NSDictionary *)dataSource
{
   // shippingName 	String 	配送方式（01：客户自提， 02：自家配送， 03：快递配送）
    if ([dataSource[@"shippingName"] integerValue]==1)
    {
   
        self.name.text=[NSString stringWithFormat:@"自提人：%@",dataSource[@"contactName"]];
        self.phone.text=[NSString stringWithFormat:@"%@",dataSource[@"contactMobile"]];
        self.address.text=[NSString stringWithFormat:@"自提地址：%@",dataSource[@"ownDeliveryAddress"]];
    }
    else
    {
        self.name.text=[NSString stringWithFormat:@"收货人：%@",dataSource[@"contactName"]];
        self.phone.text=[NSString stringWithFormat:@"%@",dataSource[@"contactMobile"]];
        self.address.text=[NSString stringWithFormat:@"收货地址：%@",dataSource[@"deliveryAddress"]];
    }

}
//添加京东收货地址
-(void)loadViewWithJDMallDatasource:(NSDictionary *)dataSource
{
 
        self.name.text=[NSString stringWithFormat:@"收货人：%@",dataSource[@"name"]];
        self.phone.text=[NSString stringWithFormat:@"%@",dataSource[@"mobile"]];
        self.address.text=[NSString stringWithFormat:@"收货地址：%@%@%@%@%@",dataSource[@"provinceName"],dataSource[@"cityName"],dataSource[@"countyName"],dataSource[@"townName"],dataSource[@"address"]];
    
}
@end
