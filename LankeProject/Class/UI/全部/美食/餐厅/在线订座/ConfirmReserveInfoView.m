//
//  ConfirmReserveInfoView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ConfirmReserveInfoView.h"
#import "ReservationInfo.h"

@interface ConfirmReserveInfoView ()

@property (nonatomic ,strong) UILabel * reserveNameDisplayLabel;
@property (nonatomic ,strong) UILabel * reserveNameLabel;

@property (nonatomic ,strong) UILabel * reserveDateDisplayLabel;
@property (nonatomic ,strong) UILabel * reserveDateLabel;

@property (nonatomic ,strong) UILabel * reserveCountDisplayLabel;
@property (nonatomic ,strong) UILabel * reserveCountLabel;

@end

@implementation ConfirmReserveInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat fontSize = 15.0f;
        
        self.reserveNameDisplayLabel = [UnityLHClass masonryLabel:@"预订人:" font:fontSize color:BM_Color_GrayColor];
        [self addSubview:self.reserveNameDisplayLabel];
        
        self.reserveNameLabel = [UnityLHClass masonryLabel:@"Wally" font:fontSize color:BM_Color_BlackColor];
        [self addSubview:self.reserveNameLabel];
        
        self.reserveDateDisplayLabel = [UnityLHClass masonryLabel:@"预定时间:" font:fontSize color:BM_Color_GrayColor];
        [self addSubview:self.reserveDateDisplayLabel];
        
        self.reserveDateLabel = [UnityLHClass masonryLabel:@"2016-11-04 13:45" font:fontSize color:BM_Color_BlackColor];
        [self addSubview:self.reserveDateLabel];
        
        self.reserveCountDisplayLabel = [UnityLHClass masonryLabel:@"预定人数:" font:fontSize color:BM_Color_GrayColor];
        [self addSubview:self.reserveCountDisplayLabel];
        
        self.reserveCountLabel = [UnityLHClass masonryLabel:@"6人" font:fontSize color:BM_Color_BlackColor];
        [self addSubview:self.reserveCountLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.reserveNameDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    [self.reserveNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.reserveNameDisplayLabel.mas_centerY);
        make.left.mas_equalTo(self.reserveNameDisplayLabel.mas_right).mas_offset(5);
    }];
    
    [self.reserveDateDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.reserveNameDisplayLabel.mas_bottom);
        make.left.mas_equalTo(self.reserveNameDisplayLabel.mas_left);
        make.width.mas_equalTo(self.reserveNameDisplayLabel.mas_width);
        make.height.mas_equalTo(self.reserveNameDisplayLabel.mas_height);
    }];
    [self.reserveDateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.reserveDateDisplayLabel.mas_centerY);
        make.left.mas_equalTo(self.reserveNameLabel.mas_left);
    }];
    
    [self.reserveCountDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.reserveDateDisplayLabel.mas_bottom);
        make.left.mas_equalTo(self.reserveNameDisplayLabel.mas_left);
        make.width.mas_equalTo(self.reserveNameDisplayLabel.mas_width);
        make.height.mas_equalTo(self.reserveNameDisplayLabel.mas_height);
    }];
    [self.reserveCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.reserveCountDisplayLabel.mas_centerY);
        make.left.mas_equalTo(self.reserveDateLabel.mas_left);
    }];
}


- (void) configInfoViewWithData:(ReservationInfo *)info{

    self.reserveNameLabel.text = info.name;
    self.reserveDateLabel.text = [info.date stringForNormalDataFormatter:@"YYYY-MM-dd HH:mm"];
    self.reserveCountLabel.text = [NSString stringWithFormat:@"%ld人",(long)info.count];
}

@end
