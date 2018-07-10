//
//  ConfirmReserveDishesCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ConfirmReserveDishesCell.h"
#import "LKShoppingCarManager.h"

@interface ConfirmReserveDishesCell ()

@property (nonatomic ,strong) UIImageView * dishesIconImageView;

@property (nonatomic ,strong) UILabel * dishesNameLabel;

@property (nonatomic ,strong) UILabel * dishesCountLabel;

@property (nonatomic ,strong) UILabel * dishesPriceLabel;

@property (nonatomic ,strong) UILabel * dishesCouponPriceLabel;//原价
@property (nonatomic ,strong) UIView * dishesCouponPricelineView;

@property (nonatomic ,strong) UIView * lineView;

@end

@implementation ConfirmReserveDishesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (!_dishesIconImageView) {
            _dishesIconImageView = [[UIImageView alloc] init];
            _dishesIconImageView.contentMode = UIViewContentModeScaleAspectFill;
            _dishesIconImageView.layer.cornerRadius = 5.0f;
            _dishesIconImageView.layer.masksToBounds = YES;
            _dishesIconImageView.image = [UIImage imageNamed:@"default_dishes"];
            [self.contentView addSubview:_dishesIconImageView];
        }
        if (!_dishesNameLabel) {
            _dishesNameLabel = [UnityLHClass masonryLabel:@"三文鱼赤身" font:14 color:BM_Color_BlackColor];
            _dishesNameLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_dishesNameLabel];
        }
        
        if (!_dishesPriceLabel) {
            _dishesPriceLabel = [UnityLHClass masonryLabel:@"￥35.00" font:14 color:[UIColor colorWithHexString:@"#FF9525"]];
            _dishesPriceLabel.textAlignment = NSTextAlignmentRight;
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
        

        if (!_dishesCountLabel) {
            _dishesCountLabel = [UnityLHClass masonryLabel:@"X1" font:12 color:BM_Color_GrayColor];
            [self.contentView addSubview:_dishesCountLabel];
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
    
    [self.dishesIconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(self.dishesIconImageView.mas_height);
    }];
    
    [self.dishesNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.dishesIconImageView.mas_top).mas_offset(5);
        make.left.mas_equalTo(self.dishesIconImageView.mas_right).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.dishesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    
    [self.dishesPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.dishesNameLabel.mas_left);
        make.bottom.mas_equalTo(self.dishesCountLabel.mas_bottom);
        make.right.mas_lessThanOrEqualTo(self.dishesCountLabel.mas_right).mas_offset(-10);
    }];
    [_dishesCouponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesPriceLabel.mas_centerY);
        make.left.mas_equalTo(_dishesPriceLabel.mas_right).mas_offset(5);
    }];
    [_dishesCouponPricelineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesCouponPriceLabel.mas_centerY);
        make.centerX.mas_equalTo(_dishesCouponPriceLabel.mas_centerX);
        make.width.mas_equalTo(_dishesCouponPriceLabel.mas_width);
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
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"ConfirmReserveDishesCell";
}

+ (CGFloat) cellHeight{

    return 80.0f;
}

- (void) configCellWithData:(LKGoodsItem *)data{
    
    [self.dishesIconImageView sd_setImageWithURL:[NSURL URLWithString:data.goodsInfo[@"dishesImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.dishesNameLabel.text = [NSString stringWithFormat:@"%@",data.goodsInfo[@"dishesFoodName"]];
    self.dishesPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[data.goodsInfo[@"couponPrice"] floatValue]];
    self.dishesCouponPriceLabel.text = [NSString stringWithFormat:@"%.2f",[data.goodsInfo[@"dishesPrice"] floatValue]];
    self.dishesCountLabel.text = [NSString stringWithFormat:@"X%ld",(long)data.count];
    
    if ([data.goodsInfo[@"couponPrice"] floatValue]==[data.goodsInfo[@"dishesPrice"] floatValue]) {
        self.dishesCouponPriceLabel.hidden=YES;
    }else{
        self.dishesCouponPriceLabel.hidden=NO;
    }
}

@end
