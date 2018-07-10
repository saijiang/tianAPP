//
//  DishesDetailHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DishesDetailHeaderView.h"
#import "AXRatingView.h"
#import "LKBannerView.h"

@interface DishesDetailHeaderView ()

@property (nonatomic ,strong) LKBannerView * bannerView;

@property (nonatomic ,strong) UILabel * dishesNameLabel;

@property (nonatomic ,strong) AXRatingView * ratingView;

@property (nonatomic ,strong) UILabel * dishesGradeLabel;
@property (nonatomic ,strong) UILabel * dishesPriceLabel;//优惠折后的价格
@property (nonatomic ,strong) UILabel * dishesCouponPriceLabel;//原价
@property (nonatomic ,strong) UIView * dishesCouponPricelineView;
@property (nonatomic ,strong) UIView * lineView;
@end

@implementation DishesDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _bannerView = [[LKBannerView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH)];
        _bannerView.myPageView.duration = 3.0f;
        //[_bannerView configureBannerViewWithBannerList:@[@"temp_tu",@"temp_tu",@"temp_tu",@"temp_tu"]];
        [self addSubview:_bannerView];
        
        _dishesNameLabel = [UnityLHClass masonryLabel:@"虾仁炒粉" font:16 color:BM_Color_BlackColor];
        [self addSubview:_dishesNameLabel];
        
        _dishesPriceLabel = [UnityLHClass masonryLabel:@"￥0.00" font:16 color:[UIColor colorWithHexString:@"#FF8B00"]];
        [self addSubview:_dishesPriceLabel];
        if (!_dishesCouponPriceLabel) {
            _dishesCouponPriceLabel = [UnityLHClass masonryLabel:@"0.00" font:12 color:BM_GRAY];
            _dishesCouponPriceLabel.textAlignment = NSTextAlignmentLeft;
            _dishesCouponPriceLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_dishesCouponPriceLabel];
        }
        if (!_dishesCouponPricelineView) {
            _dishesCouponPricelineView = [UIView new];
            _dishesCouponPricelineView.backgroundColor = BM_GRAY;
            [_dishesCouponPriceLabel addSubview:_dishesCouponPricelineView];
        }

        
        _ratingView = [[AXRatingView alloc] init];
        _ratingView.numberOfStar = 5;
        _ratingView.value = 3;
        _ratingView.markImage = [UIImage imageNamed:@"dishes_detail_big_star_normal"];
        _ratingView.markFont = [UIFont systemFontOfSize:25];
        _ratingView.baseColor = [UIColor colorWithHexString:@"#CCCCCC"];
        _ratingView.highlightColor = [UIColor colorWithHexString:@"#FDCD63"];
        [_ratingView setStepInterval:1.0];
        _ratingView.userInteractionEnabled = NO;
        [self addSubview:_ratingView];
        _ratingView.hidden=YES;
        
        _dishesGradeLabel = [UnityLHClass masonryLabel:@"0.0分" font:14 color:BM_Color_BlackColor];
        _dishesGradeLabel.hidden=YES;
        [self addSubview:_dishesGradeLabel];
        
        _wantGradeButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _wantGradeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_wantGradeButton addTarget:self action:@selector(wantGradeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_wantGradeButton setTitle:@"我要评分" forState:UIControlStateNormal];
        _wantGradeButton.hidden=YES;
        [self addSubview:_wantGradeButton];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BM_Color_SeparatorColor;
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    [_dishesNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_bannerView.mas_bottom).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(self.dishesPriceLabel.mas_left).mas_offset(-10);
    }];
    [_dishesPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_dishesNameLabel.mas_top);
        make.right.mas_equalTo(_dishesCouponPriceLabel.mas_left).offset(-5);
    }];
    [_dishesCouponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesNameLabel.mas_centerY);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
    [_dishesCouponPricelineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesCouponPriceLabel.mas_centerY);
        make.centerX.mas_equalTo(_dishesCouponPriceLabel.mas_centerX);
        make.width.mas_equalTo(_dishesCouponPriceLabel.mas_width);
        make.height.mas_equalTo(1);
    }];
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_dishesNameLabel.mas_left);
        make.top.mas_equalTo(_dishesNameLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    [_dishesGradeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_ratingView.mas_centerY);
        make.left.mas_equalTo(_ratingView.mas_right).mas_offset(15);
    }];
    [_wantGradeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_ratingView.mas_centerY);
        make.right.mas_equalTo(_dishesCouponPriceLabel.mas_right);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void) configDetailHeaderViewWithData:(id)data{

    CGFloat value = [data[@"evalScores"] floatValue];
    self.dishesNameLabel.text = [NSString stringWithFormat:@"%@",data[@"dishesName"]];
    self.ratingView.value = (NSInteger)value;
    self.dishesGradeLabel.text = [NSString stringWithFormat:@"%.1f分",value];
    self.dishesPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data[@"couponPrice"] floatValue]];
    self.dishesCouponPriceLabel.text = [NSString stringWithFormat:@"%.2f",[data[@"dishesPrice"] floatValue]];
    if ([data[@"couponPrice"] floatValue]==[data[@"dishesPrice"] floatValue]) {
        self.dishesCouponPriceLabel.hidden=YES;
        self.dishesCouponPriceLabel.text=nil;
    }else{
        self.dishesCouponPriceLabel.hidden=NO;
    }
    
    NSMutableArray * bannerArray = [NSMutableArray arrayWithCapacity:3];
    if (data[@"dishesImageDetail1"]) {
        [bannerArray addObject:data[@"dishesImageDetail1"]];
    }
    if (data[@"dishesImageDetail2"]) {
        [bannerArray addObject:data[@"dishesImageDetail2"]];
    }
    if (data[@"dishesImageDetail3"]) {
        [bannerArray addObject:data[@"dishesImageDetail3"]];
    }
    
    [self.bannerView configureBannerViewWithBannerList:bannerArray];
}

#pragma mark -
#pragma mark Action M

- (void) wantGradeButtonHandle:(UIButton *)button{
    
    if (self.bGradeButtonHandle) {
        
        self.bGradeButtonHandle();
    }
}

@end
