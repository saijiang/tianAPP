//
//  RestauraFooterView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestauraFooterView.h"

@implementation RestauraFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;

        UIButton *dingzuo=[UnityLHClass masonryButton:@"订座订餐" imageStr:@"ding_dingzuo-1" font:14.0 color:BM_BLACK];
        [self addSubview:dingzuo];
        [self setButtonEdgeInsets:dingzuo];
        [dingzuo handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"0"];
        }];
        UIButton *diancan=[UnityLHClass masonryButton:@"外卖" imageStr:@"ding_diancan" font:14.0 color:BM_BLACK];
        [self addSubview:diancan];
        [self setButtonEdgeInsets:diancan];
        [diancan handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"1"];

        }];
        [dingzuo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.and.top.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        }];
        
        [diancan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.and.top.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        }];
    }
    return self;
}

-(void)setButtonEdgeInsets:(UIButton *)button
{
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    CGSize titleSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font] ;
    CGSize imageSize = button.imageView.image.size;
    CGFloat space = 5.0;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + space, -titleSize.width)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + space, -imageSize.width, 0, 0)];
}

@end
