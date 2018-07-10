//
//  ClearingCarBottomView.m
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ClearingCarBottomView.h"

@implementation ClearingCarBottomView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.allChooseBtn setImage:[UIImage imageNamed:@"choose-off"] forState:UIControlStateNormal];
        [self.allChooseBtn setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self.allChooseBtn addTarget:self action:@selector(allChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.allChooseBtn];
        
        
        self.titleLB = [UnityLHClass masonryLabel:@"全选" font:14.0 color:BM_BLACK];
        [self addSubview:self.titleLB];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"ShopCar_Delete"] forState:UIControlStateNormal];
        self.deleteBtn.enabled = NO;
        [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        
        //总价
        self.priceTitle = [UnityLHClass masonryLabel:@"总价" font:15 color:BM_Color_BlackColor];
        [self addSubview:self.priceTitle];
        
        //数值
        self.priceValue = [UnityLHClass masonryLabel:@"0.00" font:16 color:[UIColor colorWithHexString:@"#FF9525"]];
        [self addSubview:self.priceValue];
        
        
        self.goClearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.goClearBtn hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];
        self.goClearBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.goClearBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [self.goClearBtn addTarget:self action:@selector(goClearaction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.goClearBtn];
        self.goClearBtn.enabled = NO;

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.allChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.6);
        make.width.mas_equalTo(self.allChooseBtn.mas_height).multipliedBy(0.9);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.allChooseBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(30);
    }];

    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLB.mas_right).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.and.height.mas_equalTo(self.allChooseBtn.mas_width);
    }];
    
    [self.goClearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    //数值
    [self.priceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goClearBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.priceTitle.mas_right).offset(10);
    }];
    
    //总价
    [self.priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.goClearBtn.mas_centerY);
        make.left.mas_equalTo(self.deleteBtn.mas_right).offset(10);
//        make.width.offset(40);
    }];
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    [self addLine:CGRectMake(0, 0, CGRectGetWidth(rect), 0)];
}

#pragma mark -  =================== 逻辑处理 ===================
- (void)allChooseAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.CShoppingCarChooseAllHandle)
    {
        self.CShoppingCarChooseAllHandle(sender.isSelected);
    }
}

- (void)deleteAction:(UIButton *)sender
{
    if (self.CShoppingCarDeleteHandle)
    {
        self.CShoppingCarDeleteHandle();
    }
}

- (void)goClearaction:(UIButton *)sender
{
    if (self.CShoppingCarClearHandle)
    {
        self.CShoppingCarClearHandle();
    }
   
}
- (void) disEnable:(BOOL)disEnable{

    self.deleteBtn.enabled =
    self.goClearBtn.enabled = disEnable;
}
@end
