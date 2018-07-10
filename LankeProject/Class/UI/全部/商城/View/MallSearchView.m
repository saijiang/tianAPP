//
//  MallSearchView.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSearchView.h"

@implementation MallSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        UIImageView *baseimageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ding_sousuo"] ];
        baseimageView.contentMode=UIViewContentModeScaleAspectFit;
        baseimageView.userInteractionEnabled=YES;
        [self addSubview:baseimageView];
        [baseimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(35);
        }];
        
        LocalhostImageView *leftimageView=[[LocalhostImageView alloc]init];
        leftimageView.image=[UIImage imageNamed:@"ding_sousuoicon"];
        [baseimageView addSubview:leftimageView];
        [leftimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(baseimageView);
        }];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)tapAction
{
    [self sendObject:@"搜索"];
}

@end
