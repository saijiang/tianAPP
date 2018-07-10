//
//  MallOrderConfirmCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderConfirmCell.h"

@interface MallOrderConfirmCell()

@property (nonatomic ,strong) LocalhostImageView * goodsImageView;
@property (nonatomic ,strong) UILabel * goodsNameLabel;
@property (nonatomic ,strong) UILabel * goodsPriceLabel;
@property (nonatomic ,strong) UILabel * countLabel;
@property (nonatomic ,strong) UIView * lineView;
@end

@implementation MallOrderConfirmCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_goodsImageView) {
            _goodsImageView = [[LocalhostImageView alloc] init];
            _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
            _goodsImageView.layer.cornerRadius = 5.0f;
            _goodsImageView.layer.masksToBounds = YES;
            _goodsImageView.image = [UIImage imageNamed:@"default_dishes"];
            [self.contentView addSubview:_goodsImageView];
        }
        
        if (!_goodsNameLabel) {
            _goodsNameLabel = [UnityLHClass masonryLabel:@"澳龙澳龙澳龙澳龙澳龙澳龙澳龙澳龙澳龙" font:14 color:[UIColor colorWithHexString:@"#333333"]];
            _goodsNameLabel.numberOfLines = 2;
            _goodsNameLabel.textAlignment = NSTextAlignmentLeft;
            _goodsNameLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_goodsNameLabel];
        }
        
        if (!_goodsPriceLabel) {
            _goodsPriceLabel = [UnityLHClass masonryLabel:@"¥ 38.00" font:16 color:[UIColor colorWithHexString:@"#FF9525"]];
            _goodsPriceLabel.textAlignment = NSTextAlignmentLeft;
            _goodsPriceLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_goodsPriceLabel];
        }
        if (!_countLabel)
        {
            _countLabel = [UnityLHClass masonryLabel:@"X2" font:14 color:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.00]];
            _countLabel.textAlignment = NSTextAlignmentRight;
            _countLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_countLabel];
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
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 10;
        make.top.mas_equalTo(margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-margin);
        make.left.mas_equalTo(margin);
        make.width.mas_equalTo(_goodsImageView.mas_height);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(_goodsImageView.mas_top).mas_offset(5);
    }];
    
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_goodsImageView.mas_top).mas_offset(5);
        make.right.mas_equalTo(_countLabel.mas_left).mas_offset(-5);
        make.left.mas_equalTo(_goodsImageView.mas_right).mas_offset(5);
    }];
    
    [_goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_goodsImageView).mas_offset(-5);
        make.left.mas_equalTo(_goodsNameLabel.mas_left);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(id)data{
    
}

+ (CGFloat)cellHeight{

    return 100.0f;
}
@end
