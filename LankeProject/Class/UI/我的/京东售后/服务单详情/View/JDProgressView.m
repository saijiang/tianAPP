//
//  JDProgressView.m
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDProgressView.h"

static CGFloat width = 45;
static CGFloat btnWidth = 25;

@implementation JDProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        
        UILabel *titleLab = [UnityLHClass masonryLabel:@"售后服务" font:15.0 color:BM_BLACK];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(0);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BM_Color_LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLab.mas_bottom);
            make.left.mas_equalTo(titleLab.mas_left);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH-15);
            make.height.mas_equalTo(1);
        }];
        
        self.line2 = [[UIView alloc]init];
        self.line2.backgroundColor = BM_Color_LineColor;
        [self addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(1);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        }];
        
        self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button2.selected = YES;
        [self.button2 setImage:[UIImage imageNamed:@"jd_choose_off"] forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"jd_choose_on"] forState:UIControlStateSelected];
        [self addSubview:self.button2];
        [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.line2.mas_centerY);
//            make.width.and.height.mas_equalTo(btnWidth);
            make.right.mas_equalTo(self.line2.mas_left);
        }];
        
        self.line1 = [[UIView alloc]init];
        self.line1.backgroundColor = BM_GREEN;
        [self addSubview:self.line1];
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.line2.mas_centerY);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(self.button2.mas_left);
        }];
        
        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button1 setImage:[UIImage imageNamed:@"jd_choose_off"] forState:UIControlStateNormal];
        [self.button1 setImage:[UIImage imageNamed:@"jd_choose_on"] forState:UIControlStateSelected];
        self.button1.selected = YES;
        [self addSubview:self.button1];
        [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.line2.mas_centerY);
//            make.width.and.height.mas_equalTo(btnWidth);
            make.right.mas_equalTo(self.line1.mas_left);
        }];
        
        self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button3 setImage:[UIImage imageNamed:@"jd_choose_off"] forState:UIControlStateNormal];
        [self.button3 setImage:[UIImage imageNamed:@"jd_choose_on"] forState:UIControlStateSelected];
        [self addSubview:self.button3];
        [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.line2.mas_centerY);
//            make.width.and.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(self.line2.mas_right);
        }];
        
        self.line3 = [[UIView alloc]init];
        self.line3.backgroundColor = BM_Color_LineColor;
        [self addSubview:self.line3];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.line2.mas_centerY);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(self.button3.mas_right);
        }];
        
        self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button4 setImage:[UIImage imageNamed:@"jd_choose_off"] forState:UIControlStateNormal];
        [self.button4 setImage:[UIImage imageNamed:@"jd_choose_on"] forState:UIControlStateSelected];
        [self addSubview:self.button4];
        [self.button4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.line2.mas_centerY);
//            make.width.and.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(self.line3.mas_right);
        }];
        
        self.lable1 = [UnityLHClass masonryLabel:@"提交申请" font:14.0 color:BM_GRAY];
        self.lable1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lable1];
        [self.lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.button1.mas_centerX);
            make.top.mas_equalTo(self.button1.mas_bottom);
        }];
        
        self.lable2 = [UnityLHClass masonryLabel:@"客户审核" font:14.0 color:BM_GRAY];
        self.lable2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lable2];
        [self.lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.button2.mas_centerX);
            make.top.mas_equalTo(self.button2.mas_bottom);
        }];
        
        self.lable3 = [UnityLHClass masonryLabel:@"上门换新" font:14.0 color:BM_GRAY];
        self.lable3.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lable3];
        [self.lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.button3.mas_centerX);
            make.top.mas_equalTo(self.button3.mas_bottom);
        }];
        
        self.lable4 = [UnityLHClass masonryLabel:@"完成" font:14.0 color:BM_GRAY];
        self.lable4.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lable4];
        [self.lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.button4.mas_centerX);
            make.top.mas_equalTo(self.button4.mas_bottom);
        }];
        
        self.progressLab = [UnityLHClass masonryLabel:@"您的服务单2344324343已返厂维修中" font:14.0 color:BM_GRAY];
        [self addSubview:self.progressLab];
        [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLab.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
        }];
        
        self.detailBtn = [UnityLHClass masonryButton:@"进度详情" font:14.0 color:BM_BLACK];
        self.detailBtn.layer.cornerRadius = 2.0;
        self.detailBtn.layer.borderColor = BM_Color_LineColor.CGColor;
        self.detailBtn.layer.borderWidth = 1.0;
        [self addSubview:self.detailBtn];
        [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.progressLab.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(80);
        }];
        
    }
    return self;
}

-(void)loadViewWithData:(id)data
{
    self.button1.selected = YES;
    self.button2.selected = YES;
    self.line1.backgroundColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.42 alpha:1.00];
    self.lable1.textColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.42 alpha:1.00];
    self.lable2.textColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.42 alpha:1.00];
}


@end
