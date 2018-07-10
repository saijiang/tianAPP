//
//  EatNexWeekCell.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "EatNexWeekCell.h"
#import "EatNextWeekManager.h"

@interface EatNexWeekCell ()

@property (nonatomic ,strong) LocalhostImageView * dishesImageView;

@property (nonatomic ,strong) UILabel * dishesNameLabel;

@property (nonatomic ,strong) UILabel * dishesPriceLabel;

@property (nonatomic ,strong) UILabel * dishesCouponPriceLabel;
@property (nonatomic ,strong) UIView *  dishesCouponPricelineView;

@property (nonatomic ,strong) UIButton * buyButton;

@property (nonatomic ,strong) UILabel * wantNum;

@property (nonatomic ,strong) UIView * lineView;
@end

@implementation EatNexWeekCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (!_dishesImageView) {
            _dishesImageView = [[LocalhostImageView alloc] init];
            _dishesImageView.contentMode = UIViewContentModeScaleAspectFill;
            _dishesImageView.layer.cornerRadius = 5.0f;
            _dishesImageView.layer.masksToBounds = YES;
            _dishesImageView.image = [UIImage imageNamed:@"default_dishes"];
            [self.contentView addSubview:_dishesImageView];
            
        }
        if (!_buyButton)
        {
            _buyButton = [UnityLHClass masonryButton:@"想吃" imageStr:nil font:13 color:[UIColor colorWithRed:0.33 green:0.69 blue:0.85 alpha:1.00]];
            [_buyButton setBackgroundImage:[UIImage imageNamed:@"want_btn"] forState:UIControlStateNormal];
            [_buyButton setBackgroundImage:[UIImage imageNamed:@"want_btn2"] forState:UIControlStateSelected];
            [_buyButton setTitleColor:BM_WHITE forState:UIControlStateSelected];
            [_buyButton setTitle:@"已选" forState:UIControlStateSelected];
            [_buyButton addTarget:self action:@selector(buyButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_buyButton];
            
        }
        if (!_dishesNameLabel) {
            _dishesNameLabel = [UnityLHClass masonryLabel:@"澳龙澳龙澳龙澳龙澳龙澳龙澳龙澳龙澳龙" font:14 color:[UIColor colorWithHexString:@"#333333"]];
            _dishesPriceLabel.numberOfLines = 2;
            _dishesNameLabel.textAlignment = NSTextAlignmentLeft;
            _dishesNameLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_dishesNameLabel];
        }
        
        if (!_dishesPriceLabel) {
            _dishesPriceLabel = [UnityLHClass masonryLabel:@"¥ 38.00" font:16 color:[UIColor colorWithHexString:@"#FF9525"]];
            _dishesPriceLabel.textAlignment = NSTextAlignmentLeft;
            _dishesPriceLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_dishesPriceLabel];
        }
        
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

        if (!_wantNum)
        {
            _wantNum = [UnityLHClass masonryLabel:@"10人想吃" font:14 color:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.00]];
            _wantNum.textAlignment = NSTextAlignmentLeft;
            _wantNum.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_wantNum];
        }
        if (!_lineView) {
            _lineView = [UIView new];
            _lineView.backgroundColor = BM_Color_SeparatorColor;
            [self.contentView addSubview:_lineView];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_dishesImageView mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 10;
        make.top.mas_equalTo(margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-margin);
        make.left.mas_equalTo(margin);
        make.width.mas_equalTo(_dishesImageView.mas_height);
    }];
    
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.dishesNameLabel.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    
    [_dishesNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_dishesImageView.mas_top).mas_offset(5);
        make.right.mas_equalTo(_buyButton.mas_left).mas_offset(-5);
        make.left.mas_equalTo(_dishesImageView.mas_right).mas_offset(5);
    }];
    
    [_wantNum mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.dishesPriceLabel.mas_centerY);
    }];
    
    [_dishesPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_dishesImageView).mas_offset(-5);
//        make.right.mas_equalTo(self.wantNum.mas_left).mas_offset(-10);
        make.left.mas_equalTo(_dishesNameLabel.mas_left);
    }];
    
    [_dishesCouponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_dishesPriceLabel.mas_centerY);
        make.left.mas_equalTo(_dishesPriceLabel.mas_right).offset(5);
    }];
  
    [_dishesCouponPricelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_dishesCouponPriceLabel.mas_width);
        make.centerY.mas_equalTo(_dishesCouponPriceLabel.mas_centerY);
        make.centerX.mas_equalTo(_dishesCouponPriceLabel.mas_centerX);
        make.height.mas_equalTo(1);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) buyButtonDidPress:(UIButton *)button{
    
    if (self.wantEatDishesHandle) {
        button.selected=!button.selected;
        self.wantEatDishesHandle();
    }
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"EatNexWeekCell";
}

- (void) configCellWithData:(EatNextWeekRow *)row{
    
    NSDictionary * data = row.originalData;
    
    self.dishesNameLabel.text = [NSString stringWithFormat:@"%@",data[@"dishesFoodName"]];
    self.dishesPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[data[@"couponPrice"] floatValue]];
    self.dishesCouponPriceLabel.text = [NSString stringWithFormat:@"%.2f",[data[@"dishesPrice"] floatValue]];
    if ([data[@"couponPrice"] floatValue]==[data[@"dishesPrice"] floatValue]) {
        self.dishesCouponPriceLabel.hidden=YES;
    }else{
        self.dishesCouponPriceLabel.hidden=NO;
    }

    [self.dishesImageView sd_setImageWithURL:[NSURL URLWithString:data[@"dishesImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.wantNum.text = [NSString stringWithFormat:@"%ld人想吃",(long)row.count];
    
    self.buyButton.selected = row.isWant;
    self.buyButton.userInteractionEnabled = !self.buyButton.isSelected;
}

@end
