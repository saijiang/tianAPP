//
//  MallOrderConfirmGoodsCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderConfirmGoodsCell.h"

@interface MallOrderConfirmGoodsCell ()

@property (nonatomic ,strong) NetworkImageView * iconImageView;

@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * countLabel;

@property (nonatomic ,strong) UILabel * priceLabel;
@property (nonatomic ,strong) UILabel * goodOriginalPrice;

@property (nonatomic ,strong) UIView * bottmLineView;

@end

@implementation MallOrderConfirmGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = [[NetworkImageView alloc] init];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.image = [UIImage imageNamed:@"default_dishes"];
        [self.contentView addSubview:self.iconImageView];
        
        self.nameLabel = [UnityLHClass masonryLabel:@"*****" font:14 color:[UIColor colorWithHexString:@"#333333"]];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.priceLabel = [UnityLHClass masonryLabel:@"$ 0.00" font:16 color:[UIColor colorWithHexString:@"#FF9525"]];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.priceLabel];

        self.countLabel = [UnityLHClass masonryLabel:@"x1" font:14 color:[UIColor colorWithHexString:@"999999"]];
        self.countLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.countLabel];
        
        self.bottmLineView = [UIView new];
        self.bottmLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.bottmLineView];
        
        self.goodOriginalPrice=[UnityLHClass masonryLabel:@"" font:12.0 color:BM_GRAY];
        [self.contentView addSubview:self.goodOriginalPrice];
        
        
        UIView *goodline=[[UIView alloc]init];
        goodline.backgroundColor=BM_GRAY;
        [self.goodOriginalPrice addSubview:goodline];
        [goodline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.centerY.mas_equalTo(self.goodOriginalPrice.mas_centerY);
        }];

        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 10;
        make.top.mas_equalTo(margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-margin);
        make.left.mas_equalTo(margin);
        make.width.mas_equalTo(self.iconImageView.mas_height);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.iconImageView.mas_top).mas_offset(5);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-40);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImageView).mas_offset(-0);
        make.left.mas_equalTo(self.nameLabel.mas_left);
    }];
    
    [self.goodOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceLabel.mas_centerY);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(5);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.nameLabel.mas_top);
    }];
    
    [self.bottmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

- (void)configCellWithData:(id)data{

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"goodsImageList"]]
                          placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.nameLabel.text = data[@"goodsName"];
    self.countLabel.text = [NSString stringWithFormat:@"x%d",[data[@"goodsNum"] intValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[data[@"couponPrice"] floatValue]];
    self.goodOriginalPrice.text = [NSString stringWithFormat:@"%.2f",[data[@"salePrice"] floatValue]];
    if ([data[@"couponPrice"] floatValue]==[data[@"salePrice"] floatValue]||[data[@"salePrice"] floatValue]==0) {
        self.goodOriginalPrice.hidden=YES;
    }else{
        self.goodOriginalPrice.hidden=NO;
    }

}

- (void)configOneShopCellWithData:(id)data{
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"goodsImageList"]]
                          placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.nameLabel.text = data[@"goodsName"];
    self.countLabel.text = [NSString stringWithFormat:@"x%d",[data[@"goodsNum"] intValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[data[@"marketPrice"] floatValue]];
    self.goodOriginalPrice.hidden=YES;
    
}
- (void)configJDShopCellWithData:(id)data{
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"goodsImageList"]]
                          placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.nameLabel.text = data[@"goodsName"];
    self.countLabel.text = [NSString stringWithFormat:@"x%d",[data[@"goodsNum"] intValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[data[@"marketPrice"] floatValue]];
    self.goodOriginalPrice.hidden=YES;
    
}

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

+ (CGFloat) cellHeight{
    
    return 80;
}

@end
