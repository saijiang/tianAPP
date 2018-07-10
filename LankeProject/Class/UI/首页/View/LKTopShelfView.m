//
//  LKTopShelfView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKTopShelfView.h"
#import "LKShelfItemView.h"

@interface LKTopShelfView ()

@end
@implementation LKTopShelfView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = BM_Color_GrayColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.3;
        
        _shoppingItemView = [[LKShelfItemView alloc] init];
        _shoppingItemView.tinColorForLogo = [UIColor colorWithHexString:@"#D62BAE"];
        _shoppingItemView.titleLabel.text = @"购物";
        _shoppingItemView.detailLabel.text = @"动动手指，好货到家";
        _shoppingItemView.iconImageView.image = [UIImage imageNamed:@"home_page_shopping"];
        [self addSubview:_shoppingItemView];
        
//        _TherapyItemView
        _TherapyItemView = [[LKShelfItemView alloc] init];
        _TherapyItemView.tinColorForLogo = [UIColor colorWithHexString:@"#31bc59"];
        _TherapyItemView.titleLabel.text = @"疗休养";
        _TherapyItemView.detailLabel.text = @"提前规划，轻松度假";
        _TherapyItemView.iconImageView.image = [UIImage imageNamed:@"nurse_beizi"];
        [self addSubview: _TherapyItemView];
        
        
        
        _healthItemView = [[LKShelfItemView alloc] init];
        _healthItemView.tinColorForLogo = [UIColor colorWithHexString:@"#53B1D9"];
        _healthItemView.titleLabel.text = @"健身";
        _healthItemView.detailLabel.text = @"健康运动，闪电瘦身";
        _healthItemView.iconImageView.image = [UIImage imageNamed:@"home_page_health"];
        [self addSubview: _healthItemView];
        
        
        _foodItemView = [[LKShelfItemView alloc] init];
        _foodItemView.tinColorForLogo = [UIColor colorWithHexString:@"#EAB04B"];
        _foodItemView.titleLabel.text = @"美食";
        _foodItemView.detailLabel.text = @"在线点餐，火速送达";
        _foodItemView.iconImageView.image = [UIImage imageNamed:@"home_page_food"];
        [self addSubview: _foodItemView];
        
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_shoppingItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
//        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    
    [_TherapyItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.shoppingItemView.mas_right);
        make.top.mas_equalTo(self.shoppingItemView.mas_bottom);
        make.width.mas_equalTo(self.shoppingItemView.mas_width);
        make.height.mas_equalTo(self.shoppingItemView.mas_height);
    }];
    
    
    [_foodItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(_shoppingItemView.mas_top);
        make.width.mas_equalTo(self.shoppingItemView.mas_width);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [_healthItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.foodItemView.mas_right);
        make.top.mas_equalTo(self.foodItemView.mas_bottom);
        make.width.mas_equalTo(self.foodItemView.mas_width);
        make.height.mas_equalTo(self.foodItemView.mas_height);
    }];
    
    [self.TherapyItemView updateSubViewForSpecialIconItemView];
    [self.shoppingItemView updateSubViewForSpecialIconShopItemView];
//    [self.shoppingItemView updateSubViewForSpecialItemView];
    
}

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat margin_v = 15;
    CGFloat margin_h = 15;
    
    CGPoint startPoint_v = CGPointMake(CGRectGetWidth(rect)/2 ,margin_v);
    CGPoint stopPoint_v = CGPointMake(CGRectGetWidth(rect)/2 ,CGRectGetHeight(rect) - margin_v);
    
    CGPoint startPoint_h = CGPointMake(CGRectGetWidth(rect)/2 + margin_h, CGRectGetHeight(rect)/2);
    CGPoint stopPoint_h = CGPointMake(CGRectGetWidth(rect) - margin_h,CGRectGetHeight(rect)/2);
    
    CGPoint startPoint_fh = CGPointMake(margin_h, CGRectGetHeight(rect)/2);
    CGPoint stopPoint_fh = CGPointMake(CGRectGetWidth(rect)/2 - margin_h,CGRectGetHeight(rect)/2);
    
    hll_drawLineWithContext(context, startPoint_v, stopPoint_v);
    hll_drawLineWithContext(context, startPoint_h, stopPoint_h);
    hll_drawLineWithContext(context, startPoint_fh, stopPoint_fh);
    
}

void hll_drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
    
    CGPoint lines[] = {
        start_point,
        stop_point
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    CGContextStrokePath(context);
};

@end
