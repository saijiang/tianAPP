//
//  InvoiceHeaderView.m
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "InvoiceHeaderView.h"

@implementation InvoiceHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        
        UILabel *titleLab = [UnityLHClass masonryLabel:@"发票抬头" font:16.0 color:BM_BLACK];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(0);
        }];
        
        self.personBtn = [[LeftImageBtn alloc]init];
        self.personBtn.selected = YES;
        [self.personBtn setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [self.personBtn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [self.personBtn setTitle:@"个人" forState:UIControlStateNormal];
        [self.personBtn setTitleColor:BM_BLACK forState:UIControlStateNormal];
        [self addSubview:self.personBtn];
        [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLab.mas_left);
            make.top.mas_equalTo(titleLab.mas_bottom);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        [self.personBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.personBtn.selected = YES;
            self.companyBtn.selected = NO;
            self.nameTf.hidden = YES;
            self.numberTf.hidden = YES;
            [self sendObject:@"hide"];
        }];
        
        self.companyBtn = [[LeftImageBtn alloc]init];
        [self.companyBtn setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [self.companyBtn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [self.companyBtn setTitle:@"单位" forState:UIControlStateNormal];
        self.companyBtn.hidden=YES;
        [self.companyBtn setTitleColor:BM_BLACK forState:UIControlStateNormal];
        [self addSubview:self.companyBtn];
        [self.companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_personBtn.mas_right).offset(15);
            make.top.mas_equalTo(self.personBtn.mas_top);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        [self.companyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.companyBtn.selected = YES;
            self.personBtn.selected = NO;
            self.nameTf.hidden = NO;
            self.numberTf.hidden = NO;
            [self sendObject:@"show"];
        }];
        
        self.nameTf = [UnityLHClass masonryField:@"请在此填写单位名称" font:15.0 color:BM_BLACK];
        self.nameTf.backgroundColor = BM_Color_LineColor;
        self.nameTf.layer.cornerRadius = 2.0;
        [self addSubview:self.nameTf];
        [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.personBtn.mas_left);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.personBtn.mas_bottom);
        }];
        
        self.numberTf = [UnityLHClass masonryField:@"请在此填写纳税人识别号" font:15.0 color:BM_BLACK];
        self.nameTf.hidden = YES;
        self.numberTf.hidden = YES;
        self.numberTf.layer.cornerRadius = 2.0;
        self.numberTf.backgroundColor = BM_Color_LineColor;
        [self addSubview:self.numberTf];
        [self.numberTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.personBtn.mas_left);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.nameTf.mas_bottom).offset(10);
        }];
        
    }
    return self;
}

-(void)createView
{
    
}

//赋值
-(void)configViewWithData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]] && [data[@"selectedInvoiceTitle"] integerValue] == 4)
    {
        self.personBtn.selected = YES;
        self.companyBtn.selected = NO;
    }
    else if ([data isKindOfClass:[NSDictionary class]] && [data[@"selectedInvoiceTitle"] integerValue] == 5)
    {
        self.personBtn.selected = NO;
        self.companyBtn.selected = YES;
        self.nameTf.text = data[@"companyName"];
        self.numberTf.text = data[@"regcode"];

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
