//
//  JDServiceInfoView.m
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDServiceInfoView.h"

@implementation JDServiceInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        
        self.titleLab = [UnityLHClass masonryLabel:@"客户发货信息" font:15.0 color:BM_BLACK];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BM_Color_LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLab.mas_bottom);
            make.left.mas_equalTo(self.titleLab.mas_left);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH-15);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *typeTitleLab = [UnityLHClass masonryLabel:@"服务单号：" font:14.0 color:BM_GRAY];
        [self addSubview:typeTitleLab];
        [typeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_left);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(line.mas_bottom);
        }];
       
        self.typeLab = [UnityLHClass masonryLabel:@"换货" font:14.0 color:BM_BLACK];
        [self addSubview:self.typeLab];
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(typeTitleLab.mas_right).offset(45);
            make.height.mas_equalTo(typeTitleLab.mas_height);
            make.centerY.mas_equalTo(typeTitleLab.mas_centerY);
        }];
        
        UILabel *contactTitleLab = [UnityLHClass masonryLabel:@"运费：" font:14.0 color:BM_GRAY];
        [self addSubview:contactTitleLab];
        [contactTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_left);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(typeTitleLab.mas_bottom);
        }];
        
        self.contactLab = [UnityLHClass masonryLabel:@"30" font:14.0 color:BM_BLACK];
        [self addSubview:_contactLab];
        [_contactLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeLab.mas_left);
            make.height.mas_equalTo(contactTitleLab.mas_height);
            make.centerY.mas_equalTo(contactTitleLab.mas_centerY);
        }];
        
        UILabel *phoneTitleLab = [UnityLHClass masonryLabel:@"客户发货日期：" font:14.0 color:BM_GRAY];
        [self addSubview:phoneTitleLab];
        [phoneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_left);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(contactTitleLab.mas_bottom);
        }];
        
        self.phoneNumberLab = [UnityLHClass masonryLabel:@"2017-12-12" font:14.0 color:BM_BLACK];
        [self addSubview:_phoneNumberLab];
        [_phoneNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeLab.mas_left);
            make.height.mas_equalTo(phoneTitleLab.mas_height);
            make.centerY.mas_equalTo(phoneTitleLab.mas_centerY);
        }];
        
        UILabel *addressTitleLab = [UnityLHClass masonryLabel:@"快递公司名称：" font:14.0 color:BM_GRAY];
        [self addSubview:addressTitleLab];
        [addressTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_left);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(phoneTitleLab.mas_bottom);
        }];
        
        self.addressLab = [UnityLHClass masonryLabel:@"中通快递" font:14.0 color:BM_BLACK];
        [self addSubview:_addressLab];
        [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeLab.mas_left);
            make.height.mas_equalTo(addressTitleLab.mas_height);
            make.centerY.mas_equalTo(addressTitleLab.mas_centerY);
        }];
        
        //快递单号
        UILabel *numberTitleLab = [UnityLHClass masonryLabel:@"快递单号：" font:14.0 color:BM_GRAY];
        [self addSubview:numberTitleLab];
        [numberTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_left);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(addressTitleLab.mas_bottom);
        }];
        
        self.numberLab = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
        [self addSubview:_numberLab];
        [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeLab.mas_left);
            make.height.mas_equalTo(numberTitleLab.mas_height);
            make.centerY.mas_equalTo(numberTitleLab.mas_centerY);
        }];
    }
    return self;
}

//赋值
-(void)loadViewWithData:(id)dataSource
{
    
    
    //服务单号
    self.typeLab.text = dataSource[@"afsServiceId"];
    //运费
    self.contactLab.text = dataSource[@"freightMoney"];
    //客户发货日期
    self.phoneNumberLab.text = [UnityLHClass getCurrentTimeWithType:@"YYYY-MM-dd" andTimeString:dataSource[@"deliverDate"]];
    //快递公司名称
    self.addressLab.text = dataSource[@"expressCompany"];
    //快递单号
    self.numberLab.text = dataSource[@"expressCode"];
}

@end
