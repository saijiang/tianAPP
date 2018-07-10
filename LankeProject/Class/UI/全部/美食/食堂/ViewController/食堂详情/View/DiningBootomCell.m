//
//  DiningBootomCell.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningBootomCell.h"

#define topHeight 10
#define imageWidth 60

@implementation DiningBootomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        float width = (DEF_SCREEN_WIDTH-2)/3.0;
        self.oneBtn = [[CustomBtn alloc]init];
        self.oneBtn.userInteractionEnabled = YES;
        [self addSubview:self.oneBtn];
        [self.oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(width);
        }];
        
        
        UIButton *one = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.oneBtn addSubview:one];
        [one mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.oneBtn);
            make.width.mas_equalTo(self.oneBtn.mas_width);
            make.height.mas_equalTo(self.oneBtn.mas_height);
        }];
        [one handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"0"];
        }];
        
        
        UIView *lineOne = [[UIView alloc]init];
        lineOne.backgroundColor = BM_Color_LineColor;
        [self addSubview:lineOne];
        [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(topHeight);
            make.left.mas_equalTo(self.oneBtn.mas_right).offset(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(imageWidth);
        }];
        
        self.twoBtn = [[CustomBtn alloc]init];
        self.twoBtn.userInteractionEnabled = YES;
        [self addSubview:self.twoBtn];
        [self.twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(lineOne.mas_right).offset(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(width);
        }];
        [self.twoBtn sendObject:@"0" withIdentifier:@"twoBtn"];
        
        UIButton *two = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.twoBtn addSubview:two];
        [two mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.twoBtn);
            make.width.mas_equalTo(self.twoBtn.mas_width);
            make.height.mas_equalTo(self.twoBtn.mas_height);
        }];
        [two handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"1"];
        }];
        
        UIView *lineTwo = [[UIView alloc]init];
        lineTwo.backgroundColor = BM_Color_LineColor;
        [self addSubview:lineTwo];
        [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(topHeight);
            make.left.mas_equalTo(self.twoBtn.mas_right).offset(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(imageWidth);
        }];
        
        self.threeBtn = [[CustomBtn alloc]init];
        self.threeBtn.userInteractionEnabled = YES;
        [self addSubview:self.threeBtn];
        [self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(lineTwo.mas_right).offset(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(width);
        }];
        
        UIButton *three = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.threeBtn addSubview:three];
        [three mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.threeBtn);
            make.width.mas_equalTo(self.threeBtn.mas_width);
            make.height.mas_equalTo(self.threeBtn.mas_height);
        }];
        [three handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"2"];
        }];
      
        
        self.oneBtn.iconImageView.image = [UIImage imageNamed:@"shitang-1"];
        self.oneBtn.titleLab.text = @"每周菜单";
        
        self.twoBtn.iconImageView.image = [UIImage imageNamed:@"shitang-2"];
        self.twoBtn.titleLab.text = @"下周想吃";
        
        self.threeBtn.iconImageView.image = [UIImage imageNamed:@"shitang-3"];
        self.threeBtn.titleLab.text = @"外卖";
        
    }
    return self;
}


//-(void)initButton:(UIButton*)btn
//{
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [btn setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
//    btn.titleLabel.font = BM_FONTSIZE15;
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width-5)];//图片距离右边框距离减少图片的宽度，其它不边
//}

@end

@implementation CustomBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.iconImageView = [[LocalhostImageView alloc]init];
        self.iconImageView.layer.cornerRadius = 30;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.image = [UIImage imageNamed:@"shitang-1"];
        self.iconImageView.userInteractionEnabled = YES;
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(10);
            make.height.and.width.mas_equalTo(60);
        }];
        
        self.titleLab = [UnityLHClass masonryLabel:@"每周菜单" font:15.0 color:BM_Color_BlackColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
            make.width.mas_equalTo(self.mas_width);
        }];
        
    }
    return self;
}

-(void)loadCustomDataWithData:(id)dataSource
{
    self.iconImageView.image = [UIImage imageNamed:dataSource[@"img"]];
    self.titleLab.text = dataSource[@"title"];
}


@end
