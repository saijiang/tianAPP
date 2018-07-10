//
//  GoodsDetailBottomView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GoodsDetailBottomView.h"

@interface GoodsDetailBottomView ()

@end
@implementation GoodsDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.addToShopCartButton = [UnityLHClass masonryButton:@"加入购物车" font:15 color:[UIColor whiteColor]];
        [self.addToShopCartButton hll_setBackgroundImageWithHexString:@"#F2BB5A" forState:UIControlStateNormal];
        [self.addToShopCartButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            if (self.bAddToShopCartHandle) {
                self.bAddToShopCartHandle();
            }
        }];
        [self addSubview:self.addToShopCartButton];
        
        self.ImmediatelyBuyButton = [UnityLHClass masonryButton:@"立即购买" font:15 color:[UIColor whiteColor]];
        [self.ImmediatelyBuyButton hll_setBackgroundImageWithHexString:@"#67B0D9" forState:UIControlStateNormal];
        [self.ImmediatelyBuyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            if (self.bImmediatelyBuyHandle) {
                self.bImmediatelyBuyHandle();
            }
        }];
        [self addSubview:self.ImmediatelyBuyButton];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.addToShopCartButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [self.ImmediatelyBuyButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.addToShopCartButton.mas_right);
        make.width.mas_equalTo(self.addToShopCartButton.mas_width);
        make.height.mas_equalTo(self.addToShopCartButton.mas_height);
        make.top.mas_equalTo(self.addToShopCartButton.mas_top);
    }];
}

- (void)enableButton:(BOOL)enable{

    self.addToShopCartButton.enabled = enable;
    self.ImmediatelyBuyButton.enabled = enable;
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

@end
