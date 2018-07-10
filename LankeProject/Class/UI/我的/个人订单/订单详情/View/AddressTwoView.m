//
//  AddressTwoView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AddressTwoView.h"

@interface AddressTwoView ()

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *time;


@end

@implementation AddressTwoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        LocalhostImageView *loaction=[[LocalhostImageView alloc]init];
        [self addSubview:loaction];
        loaction.image=[UIImage imageNamed:@"ding_dingwei"];
        [loaction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
        }];
        
        
        self.name=[UnityLHClass masonryLabel:@"预定人：张涛" font:15.0 color:BM_BLACK];
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.phone=[UnityLHClass masonryLabel:@"13022172628" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.phone];
        [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(15);
            
        }];
        
        self.address=[UnityLHClass masonryLabel:@"预定餐厅：很高兴遇见你" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.address];
        self.address.numberOfLines=0;
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(self.name.mas_bottom).offset(10);
            
        }];
        
        self.num=[UnityLHClass masonryLabel:@"就餐人数：6人" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.num];
        [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(self.address.mas_bottom).offset(10);
            
        }];
        
        self.time=[UnityLHClass masonryLabel:@"就餐时间：2015-02-10 18:30" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.time];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(self.num.mas_bottom).offset(10);
            
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
        make.top.mas_equalTo(self.name.mas_top).offset(-15);
        make.bottom.mas_equalTo(self.time.mas_bottom).offset(15);
    }];
}
-(void)loadViewWithDatasource:(NSDictionary *)dataSource
{
    self.name.text=[NSString stringWithFormat:@"预定人：%@",dataSource[@"contactName"]];
    self.phone.text=[NSString stringWithFormat:@"%@",dataSource[@"contactMobile"]];
    self.address.text=[NSString stringWithFormat:@"预定餐厅：%@",dataSource[@"restaurantName"]];
    self.num.text=[NSString stringWithFormat:@"就餐人数：%@人",dataSource[@"dinersNum"]];
    self.time.text=[NSString stringWithFormat:@"就餐时间：%@",dataSource[@"orderTime"]];

}


@end
