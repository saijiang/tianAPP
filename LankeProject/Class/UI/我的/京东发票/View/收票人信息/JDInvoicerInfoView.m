//
//  JDInvoicerInfoView.m
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDInvoicerInfoView.h"

@implementation JDInvoicerInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        UILabel *titleLab = [UnityLHClass masonryLabel:@"收票人信息" font:16.0 color:BM_BLACK];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
        
        UILabel *phoneTitleLab = [UnityLHClass masonryLabel:@"*收票人手机" font:15.0 color:BM_GRAY];
        [self addSubview:phoneTitleLab];
        [phoneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLab.mas_left);
            make.height.mas_equalTo(titleLab.mas_height);
            make.top.mas_equalTo(titleLab.mas_bottom).offset(1);
        }];
        
        self.phoneNumTf = [UnityLHClass masonryField:@"186****5877" font:15.0 color:BM_BLACK];
        self.phoneNumTf.enabled = NO;
        self.phoneNumTf.text = @"186****5877";
        [self addSubview:self.phoneNumTf];
        [self.phoneNumTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(phoneTitleLab.mas_centerY);
            make.left.mas_equalTo(100);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(phoneTitleLab.mas_height);
        }];
        
        UILabel *emailTitleLab = [UnityLHClass masonryLabel:@"收票人邮箱" font:15.0 color:BM_GRAY];
        [self addSubview:emailTitleLab];
        [emailTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(phoneTitleLab.mas_left);
            make.height.mas_equalTo(titleLab.mas_height);
            make.top.mas_equalTo(phoneTitleLab.mas_bottom).offset(1);
            make.height.mas_equalTo(50);
        }];
        
        self.emailTF = [UnityLHClass masonryField:@"用来接收电子发票邮件，可选填" font:15.0 color:BM_BLACK];
        [self addSubview:self.emailTF];
        [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(emailTitleLab.mas_centerY);
            make.left.mas_equalTo(100);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(50);
        }];
        
        for (int i = 0; i < 2; i++)
        {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = BM_Color_LineColor;
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.top.mas_equalTo(49+50*i);
                make.width.mas_equalTo(DEF_SCREEN_WIDTH-10);
                make.height.mas_equalTo(1);
            }];
        }
        
    }
    return self;
}

@end
