//
//  LKOrderDishesContentCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKOrderDishesContentCell.h"
#import "LKShoppingCarManager.h"

@interface LKOrderDishesContentCell ()

@property (nonatomic ,strong) UILabel * dishesNameLabel;

@property (nonatomic ,strong) UILabel * dishesCountLabel;

@property (nonatomic ,strong) UILabel * dishesPriceLabel;

@property (nonatomic ,strong) UILabel * dishesCouponPriceLabel;

@property (nonatomic ,strong) UIView * dishesCouponPricelineView;


@end

@implementation LKOrderDishesContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
            _dishesCountLabel = [UnityLHClass masonryLabel:@"*10" font:14 color:BM_Color_BlackColor];
            [self.contentView addSubview:_dishesCountLabel];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.dishesNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.dishesCountLabel.mas_left).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.4);
    }];
    
    [self.dishesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dishesNameLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.dishesNameLabel.mas_centerY);
    }];
    
    [self.dishesPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(self.dishesNameLabel.mas_centerY);
    }];
    [self.dishesCouponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesNameLabel.mas_centerY);
        make.right.mas_equalTo(_dishesPriceLabel.mas_left).mas_offset(-5);
    }];
    [self.dishesCouponPricelineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesCouponPriceLabel.mas_centerY);
        make.centerX.mas_equalTo(_dishesCouponPriceLabel.mas_centerX);
        make.width.mas_equalTo(_dishesCouponPriceLabel.mas_width);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"LKOrderDishesContentCell";
}

- (void) configCellWithData:(LKGoodsItem *)data{
    
    self.dishesNameLabel.text = [NSString stringWithFormat:@"%@",data.goodsInfo[@"dishesFoodName"]];
    self.dishesCouponPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data.goodsInfo[@"dishesPrice"] floatValue]];
    self.dishesPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data.goodsInfo[@"couponPrice"] floatValue]];
    if ([data.goodsInfo[@"couponPrice"] floatValue]==[data.goodsInfo[@"dishesPrice"] floatValue]) {
        self.dishesCouponPriceLabel.hidden=YES;
    }else{
        self.dishesCouponPriceLabel.hidden=NO;
    }
    self.dishesCountLabel.text = [NSString stringWithFormat:@"*%ld",(long)data.count];
}

@end
