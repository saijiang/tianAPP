
//
//  HealthLivingCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthLivingCell.h"

@interface HealthLivingCell ()

@property (nonatomic ,strong) LKNetworkImageView * bannerImageView;
@property (nonatomic ,strong) LocalhostImageView * playImageView;
@property (nonatomic ,strong) UIButton * statusButton;
@property (nonatomic ,strong) UILabel * livingTitleLabel;
@property (nonatomic ,strong) UILabel * livingAuthorLabel;
@property (nonatomic ,strong) UILabel * livingTimeLabel;
@property (nonatomic ,strong) UILabel * livingDesLabel;

@end

@implementation HealthLivingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = BM_WHITE;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // banner
        self.bannerImageView = [[LKNetworkImageView alloc] init];
        self.bannerImageView.placeholderImage = [UIImage imageNamed:@"default_restaurant"];
        [self.contentView addSubview:self.bannerImageView];
        
        // play imageview
        self.playImageView = [[LocalhostImageView alloc] init];
        self.playImageView.image = [UIImage imageNamed:@"health_living_play"];
        [self.bannerImageView addSubview:self.playImageView];
        
        self.statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.statusButton setTitle:@"直播中" forState:UIControlStateNormal];
        self.statusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.statusButton.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.statusButton];
        
        self.livingTitleLabel = [UnityLHClass masonryLabel:@"《巧用田七破血》" font:15 color:[UIColor blackColor]];
        [self.contentView addSubview:self.livingTitleLabel];
        
        self.livingAuthorLabel = [UnityLHClass masonryLabel:@"主播:波教授" font:14 color:BM_Color_Blue];
        [self.contentView addSubview:self.livingAuthorLabel];
        
        self.livingTimeLabel = [UnityLHClass masonryLabel:@"2016-11-03 12:00-15:00" font:13 color:[UIColor colorWithHexString:@"#9A9A9A"]];
        [self.contentView addSubview:self.livingTimeLabel];
        
        self.livingDesLabel = [UnityLHClass masonryLabel:@"讲座简介：盛世嫡妃是大神的发生但是大范围" font:14 color:[UIColor colorWithHexString:@"#9A9A9A"]];
        self.livingDesLabel.numberOfLines = 0;
        [self.contentView addSubview:self.livingDesLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.and.left.mas_equalTo(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.height.mas_equalTo((DEF_SCREEN_WIDTH-20)/2.0);
    }];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.bannerImageView.mas_right);
        make.top.mas_equalTo(self.bannerImageView.mas_top).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.livingAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(self.bannerImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.livingTitleLabel.mas_right).mas_offset(10);
    }];
    [self.livingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.bannerImageView.mas_left);
        make.top.mas_equalTo(self.bannerImageView.mas_bottom).mas_offset(10);
    }];
    [self.livingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.livingTitleLabel.mas_left);
        make.top.mas_equalTo(self.livingTitleLabel.mas_bottom).mas_offset(5);
    }];
    [self.livingDesLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.livingTimeLabel.mas_left);
        make.top.mas_equalTo(self.livingTimeLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.bannerImageView.mas_right);
        make.bottom.mas_lessThanOrEqualTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"HealthLivingCell";
}

- (void) configCellWithData:(id)data{
    
    self.livingTitleLabel.text = NSStringWithNunull(data[@"title"]);
    self.livingAuthorLabel.text = [NSString stringWithFormat:@"%@%@",@"主播:",data[@"speaker"]];
    self.livingTimeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",data[@"liveDate"],data[@"startTime"],data[@"endTime"]];
    self.livingDesLabel.text = [NSString stringWithFormat:@"%@%@",@"讲座简介:",data[@"introduction"]];
    
    LKWeakSelf
    [self.bannerImageView setImageURL:[NSURL URLWithString:NSStringWithNunull(data[@"liveImage"])] complete:^(UIImage *image) {
        
//        LKStrongSelf
//        _self.bannerImageView.image = [image applyBlurWithRadius:2 tintColor:[UIColor colorWithWhite:0.1 alpha:.75] saturationDeltaFactor:1.4 maskImage:nil];
    }];
    
    if ([data[@"isStart"]  isEqual: @"01"])
    {
        [self.statusButton setTitle:@"未开始" forState:UIControlStateNormal];
        [self.statusButton setBackgroundImage:[UIImage imageNamed:@"health_weilkaishi"] forState:UIControlStateNormal];

    }
    else if ([data[@"isStart"]  isEqual: @"02"])
    {
        [self.statusButton setTitle:@"直播中" forState:UIControlStateNormal];
        [self.statusButton setBackgroundImage:[UIImage imageNamed:@"health_living_status_living"] forState:UIControlStateNormal];
    }
    else
    {
        [self.statusButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.statusButton setBackgroundImage:[UIImage imageNamed:@"health_living_status_none"] forState:UIControlStateNormal];
    }
}


+ (CGFloat) cellHeight{
    
    return 120;
}

+ (CGFloat)cellHeightWithData:(id)data{
    
    CGFloat height = 0.0f;
    height += 10;
    height += ((DEF_SCREEN_WIDTH-20)/2.0 + 10 + 20 + 5 + 20 + 5 + 5);
    height += [UnityLHClass getHeight:[NSString stringWithFormat:@"%@%@",@"讲座简介:",data[@"introduction"]] wid:DEF_SCREEN_WIDTH - 20 font:14.0];
    return height;
}
@end
