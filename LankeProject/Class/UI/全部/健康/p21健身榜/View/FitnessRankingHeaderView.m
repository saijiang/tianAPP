//
//  FitnessRankingHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessRankingHeaderView.h"

@interface FitnessRankingHeaderView ()

@property (nonatomic ,strong) UIImageView * bannerImageView;

@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) UILabel * rankLabel;
@property (nonatomic ,strong) NetworkImageView * iconImageView;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * calorieLabel;

@property (nonatomic ,strong) UIButton * goodButton;// 点赞
@property (nonatomic ,strong) UIButton * shareButton;// 分享

@end

@implementation FitnessRankingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.bannerImageView = [[UIImageView alloc] init];
        self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bannerImageView.image = [UIImage imageNamed:@"health_header_fitness_detail"];
        [self addSubview:self.bannerImageView];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        //
        self.rankLabel = [UnityLHClass masonryLabel:@"1" font:17 color:BM_BLACK];
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.rankLabel];
        
        //
        self.iconImageView = [[NetworkImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"detault_user_icon"];
        self.iconImageView.layer.cornerRadius = 45/2;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.borderColor = BM_Color_Blue.CGColor;
        self.iconImageView.layer.borderWidth = 1;
        [self.contentView addSubview:self.iconImageView];
        
        //
        self.nameLabel = [UnityLHClass masonryLabel:@"我" font:15 color:BM_BLACK];
        [self.contentView addSubview:self.nameLabel];
        
        //
        self.calorieLabel = [UnityLHClass masonryLabel:@"224 千卡" font:14 color:[UIColor orangeColor]];
        self.calorieLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.calorieLabel];
        
        UIImage * nZanImage = [UIImage imageNamed:@"health_ranking_didnt_zan"];
        UIImage * zanImage = [UIImage imageNamed:@"health_ranking_did_zan"];
        
        //
        self.goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.goodButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.goodButton setImage:nZanImage forState:UIControlStateNormal];
        [self.goodButton setImage:zanImage forState:UIControlStateSelected];
        [self.goodButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.goodButton setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
        [self.goodButton setTitle:@" 9" forState:UIControlStateNormal];
        [self.contentView addSubview:self.goodButton];
        [self.goodButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bZanMySelfHandle) {
                self.bZanMySelfHandle();
            }
        }];
        
        //
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton setImage:[UIImage imageNamed:@"health_ranking_share"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.shareButton];
        self.shareButton.hidden=YES;
        [self.shareButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bShareMineRankingHandle) {
                self.bShareMineRankingHandle();
            }
        }];
        
    }
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
//        make.bottom.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(100);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(80);
        make.top.mas_equalTo(self.bannerImageView.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.iconImageView.mas_left);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(45,45));
        make.centerY.mas_equalTo(self.rankLabel.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.rankLabel.mas_top);
        make.height.mas_equalTo(self.rankLabel.mas_height);
        make.right.mas_lessThanOrEqualTo(self.calorieLabel.mas_left).mas_offset(-5);
    }];
    
    [self.calorieLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(2);
    }];
    
    [self.goodButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.rankLabel.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_right).mas_offset(-120);
        make.height.mas_equalTo(25);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.rankLabel.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
    }];

}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void) config:(id)data{

    
    self.contentView.hidden = [data[@"rowNum"] integerValue] == 0;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"headImage"]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    self.rankLabel.text = data[@"rowNum"];
    self.calorieLabel.text = [NSString stringWithFormat:@"%@千卡",data[@"consumeCalories"]];
    [self.goodButton setTitle:[NSString stringWithFormat:@" %@",data[@"praiseNum"]] forState:UIControlStateNormal];
    if ([data[@"praiseNum"] integerValue]>0) {
        self.goodButton.selected=YES;
    }
}

@end
