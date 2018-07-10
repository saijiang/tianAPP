//
//  LKShelfItemView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKShelfItemView.h"

@interface LKShelfItemView ()

@property (nonatomic ,strong) UIImageView * logoImageView;

@end

@implementation LKShelfItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleAspectFit;
        _logoImageView.image = [[UIImage imageNamed:@"home_page_logo"]tintedGradientImageWithColor:[UIColor whiteColor]];
        [self addSubview:_logoImageView];
        
        _titleLabel = [UnityLHClass masonryLabel:@"社区" font:22 color:[UIColor whiteColor]];
        [self addSubview:_titleLabel];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"home_page_food"];
        [self addSubview:_iconImageView];
        
        _detailLabel = [UnityLHClass masonryLabel:@"智慧圈子，轻松社交" font:12 color:[UIColor colorWithHexString:@"#444444"]];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detailLabel];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-20);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.mas_right);
        }];
        
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat margin = DEF_SCREEN_WIDTH * 0.08;
            make.left.mas_equalTo(margin);
            make.bottom.mas_equalTo(self.detailLabel.mas_top).mas_offset(-15);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.logoImageView.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(self.logoImageView.mas_centerY);
        }];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5);
            make.bottom.mas_equalTo(self.detailLabel.mas_top).mas_offset(-5);
            //make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(shelfItemViewTapHandle:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setTinColorForLogo:(UIColor *)tinColorForLogo{

    _tinColorForLogo = tinColorForLogo;
    if (tinColorForLogo) {
        UIImage * logoImage = _logoImageView.image;
        UIImage * tinLogoImage = [logoImage tintedGradientImageWithColor:tinColorForLogo];
        _logoImageView.image = tinLogoImage;
        
        _titleLabel.textColor = tinColorForLogo;
    }
}

- (void) updateSubViewForSpecialItemView{

    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self.detailLabel.mas_centerX);
    }];

    
    [_logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat margin = DEF_SCREEN_WIDTH * 0.13;
        make.left.mas_equalTo(margin);
    }];
}

//图片问题这里设置固定大小
-(void) updateSubViewForSpecialIconItemView{
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(self.detailLabel.mas_top).mas_offset(-5);
        make.size.mas_equalTo(CGSizeMake(33 * 1.3, 35 * 1.3));
    }];
}
-(void) updateSubViewForSpecialIconShopItemView{
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(self.detailLabel.mas_top).mas_offset(-5);
        make.size.mas_equalTo(CGSizeMake(163/3, 136/3));
    }];
}




- (void) shelfItemViewTapHandle:(UITapGestureRecognizer *)gesture{
    
    if (_bShelfTapHandle) {
        _bShelfTapHandle();
    }
}
@end
