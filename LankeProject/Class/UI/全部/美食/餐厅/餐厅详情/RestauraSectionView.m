//
//  RestauraSectionView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestauraSectionView.h"

@interface RestauraSectionView ()

@end

@implementation RestauraSectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.iconImageView = [[LocalhostImageView alloc]init];
        self.iconImageView.image = [UIImage imageNamed:@"locationIcon"];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(15);
        }];
        
        
        self.titleLab = [UnityLHClass masonryLabel:@"营业时间：" font:14.0 color:BM_Color_GrayColor];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            
        }];
        
        self.contentLab = [UnityLHClass masonryLabel:@"北京市海淀区南大街31号" font:14.0 color:BM_Color_BlackColor];
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_right).offset(0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(void)loadViewWithImage:(NSString *)image title:(NSString *)title  content:(NSString *)content
{
    self.iconImageView.image = [UIImage imageNamed:image];
    self.titleLab.text = title;
    self.contentLab.text = content;
}

@end
