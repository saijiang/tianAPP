//
//  RingItemView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "RingItemView.h"

@interface RingItemView ()

@property (nonatomic ,strong) LocalhostImageView * iconImageView;
@property (nonatomic ,strong) UILabel * nameLabel;

@end
@implementation RingItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[LocalhostImageView alloc] init];
        [self addSubview:self.iconImageView];
        
        self.nameLabel = [UnityLHClass masonryLabel:@"xx" font:16 color:[UIColor blackColor]];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
        self.contentLabel = [UnityLHClass masonryLabel:@"xxxxx" font:16 color:[UIColor blackColor]];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(5);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.nameLabel.mas_centerX);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(0);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)Distance{

    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_ring_juli"];
    itemView.nameLabel.text = @"距离";
    itemView.contentLabel.text = @"0公里";
    return itemView;
}

+ (instancetype)SleepTime{
    
    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_ring_shuimianshijian"];
    itemView.nameLabel.text = @"睡眠时间";
    itemView.contentLabel.text = @"0小时0分钟";
    return itemView;
}

+ (instancetype)SportTime{
    
    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_ring_shijian"];
    itemView.nameLabel.text = @"运动时长";
    itemView.contentLabel.text = @"0小时0分钟";
    return itemView;
}

+ (instancetype)DeepSleepTime{
    
    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_ring_shendu"];
    itemView.nameLabel.text = @"深度睡眠";
    itemView.contentLabel.text = @"0小时0分钟";
    return itemView;
}

+ (instancetype)Calorie{
    
    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_ring_kaluli"];
    itemView.nameLabel.text = @"卡路里消耗";
    itemView.contentLabel.text = @"0千卡";
    return itemView;
}

+ (instancetype)ShallowSleepTime{
    
    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_ring_qianshui"];
    itemView.nameLabel.text = @"浅睡眠";
    itemView.contentLabel.text = @"0小时0分钟";
    return itemView;
}

+ (instancetype)HeartbeatRate{
    
    RingItemView * itemView = [RingItemView view];
    itemView.iconImageView.image = [UIImage imageNamed:@"health_heart"];
    itemView.nameLabel.text = @"心率";
    itemView.contentLabel.text = @"0";
    return itemView;
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    
}
@end
