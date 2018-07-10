//
//  HLLValuationBottomView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLValuationBottomView.h"

@interface HLLValuationBottomView ()

/** 到时候替换个控件吧，暂时使用这个 */
//@property (nonatomic ,strong) UILabel * countLabel;

@property (nonatomic ,strong) UILabel * displayLabel;

@end

@implementation HLLValuationBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        self.whiteViewForMargin = [UIView new];
        self.whiteViewForMargin.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteViewForMargin];
        
        //
        self.settleAccountsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.settleAccountsButton hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];
        self.settleAccountsButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.settleAccountsButton setTitle:@"去结算" forState:UIControlStateNormal];
        [self.settleAccountsButton addTarget:self action:@selector(settleAccountsHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.settleAccountsButton];
        
        UIView*baseView=[[UIView alloc]init];
        baseView.backgroundColor=BM_WHITE;
        baseView.layer.cornerRadius=20.0;
        baseView.tag = 101010;
        baseView.layer.masksToBounds=YES;
        [self addSubview:baseView];
        //
        self.shoppingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shoppingCartButton setBackgroundImage:[UIImage imageNamed:@"shopping_car"] forState:UIControlStateNormal];
        [self.shoppingCartButton addTarget:self action:@selector(shoppingCarButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shoppingCartButton];
        
    
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shoppingCartButton.mas_width);
            make.height.mas_equalTo(self.shoppingCartButton.mas_height);
            make.centerX.mas_equalTo(self.shoppingCartButton.mas_centerX);
            make.top.mas_equalTo(-10);
        }];
    
        //
        self.countLabel = [UnityLHClass masonryLabel:@"0" font:13 color:[UIColor whiteColor]];
        self.countLabel.adjustsFontSizeToFitWidth=YES;
        self.countLabel.layer.cornerRadius = 7.5;
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.layer.masksToBounds = YES;
        self.countLabel.backgroundColor = [UIColor colorWithHexString:@"FF9525"];
        [self addSubview:self.countLabel];
        
        //
        self.displayLabel = [UnityLHClass masonryLabel:@"总价" font:15 color:BM_Color_BlackColor];
        [self addSubview:self.displayLabel];
        
        //
        self.priceLabel = [UnityLHClass masonryLabel:@"￥0.00" font:16 color:[UIColor colorWithHexString:@"#FF9525"]];
        [self addSubview:self.priceLabel];
        
        self.couponLabel = [UnityLHClass masonryLabel:@"" font:13 color:BM_RED];
        [self addSubview:self.couponLabel];
        
        self.whiteViewForMargin.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    [self.settleAccountsButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(120);
    }];
 
    [self.shoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.shoppingCartButton.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.shoppingCartButton.mas_top).mas_offset(10);
        NSString * count = self.countLabel.text;
        CGFloat width = [UnityLHClass getWidth:count wid:15 font:13];
        make.width.mas_equalTo(width < 15 ? 15 : width + 10);
        make.height.mas_equalTo(15);
    }];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.settleAccountsButton.mas_centerY);
        make.left.mas_equalTo(self.shoppingCartButton.mas_right).mas_offset(20);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.settleAccountsButton.mas_centerY);
        make.left.mas_equalTo(self.displayLabel.mas_right).mas_offset(5);
    }];
    
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.settleAccountsButton.mas_centerY);
        make.left.mas_equalTo(self.priceLabel.mas_right).mas_offset(5);
    }];
    
    [self.whiteViewForMargin mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(-20, 0, 0, 0));
    }];
}

//- (void)drawRect:(CGRect)rect{
//
//    [super drawRect:rect];
//    
//    [self addLine:CGRectMake(0, 0, CGRectGetWidth(rect), 0)];
//}

- (void) updateValuationBottomViewWithData:(id)data{

    /**
     @{@"count":@([self allGoodsCount]),
     @"price":@([self allGoodsPrice])};
    */
    
    NSInteger count = [data[@"count"] integerValue];
    self.shoppingCartButton.enabled =
    self.settleAccountsButton.enabled = count != 0;
    self.countLabel.hidden = !count != 0;
    self.countLabel.text = [NSString stringWithFormat:@"%@",data[@"count"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data[@"price"] floatValue]];
   
    self.price = [data[@"price"] floatValue];
   
    [self layoutSubviews];
}

- (void) updateBottomViewForHideShopingView{

    self.shoppingCartButton.hidden = YES;
    self.countLabel.hidden = YES;
    self.whiteViewForMargin.hidden = YES;
    [[self viewWithTag:101010] setHidden:YES];
    
    [self.displayLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
    }];
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Action M

- (void) settleAccountsHandle:(UIButton *)button{
   
    if (self.bSettleAccountsHandle)
    {
        self.bSettleAccountsHandle();
    }
}

- (void) shoppingCarButtonHandle:(UIButton *)button{
    
    if (self.bShoppingCarHandle) {
        self.bShoppingCarHandle();
    }
}
@end
