//
//  MallFooterView.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallFooterView.h"


@implementation MallFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
     
        UIButton *scanAll= [UnityLHClass masonryButton:@"查看全部" font:14.0 color:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00]];
        [self addSubview:scanAll];
        [scanAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        [scanAll handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"click"];
        }];

    }
    return self;
}

@end
