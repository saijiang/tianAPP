//
//  LKShyNavigationBar.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKShyNavigationBar.h"

@interface LKShyNavigationBar ()

@property (nonatomic ,strong) LocalhostImageView * backgroundImageView;

@property (nonatomic ,strong) UILabel * cartCountLabel;
@end

@implementation LKShyNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.hasRightButton = NO;
        
        self.offset = 64.0f;
        
        _backgroundImageView = [[LocalhostImageView alloc] init];
        _backgroundImageView.image = [UIImage imageWithColorHexString:@"ffffff"];
        _backgroundImageView.alpha = .0f;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundImageView];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage * selectImage = [UIImage imageNamed:@"navBar_back"];
        UIImage * normalImage = [selectImage tintedGradientImageWithColor:[UIColor whiteColor]];
        [_backButton setImage:normalImage forState:UIControlStateNormal];
        [_backButton setImage:selectImage forState:UIControlStateSelected];
        
        UIImage *nomalBackgroundImage = [UIImage imageOutlineWithCornerRadius:40
                                                                  strokeColor:nil
                                                                    fillColor:[UIColor colorWithRed:0.59 green:0.58 blue:0.57 alpha:.51]
                                                                         rect:CGRectMake(0, 0, 40, 40)];
        UIImage * selectBackgroundImage = [UIImage imageOutlineWithCornerRadius:40
                                                                    strokeColor:nil
                                                                      fillColor:BM_CLEAR
                                                                           rect:CGRectMake(0, 0, 40, 40)];
        
        [_backButton setBackgroundImage:nomalBackgroundImage forState:UIControlStateNormal];
        [_backButton setBackgroundImage:selectBackgroundImage forState:UIControlStateSelected];
        
        [_backButton addTarget:self action:@selector(backButtonTapHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _titleLabel = [UnityLHClass masonryLabel:@"" font:19 color:BM_Color_NaviBarTitleColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundImageView addSubview:_titleLabel];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightButtonTapHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setBackgroundImage:nomalBackgroundImage forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:selectBackgroundImage forState:UIControlStateSelected];
        
        [self addSubview:_rightButton];
        
        self.rightButton.hidden = !self.hasRightButton;
        
        self.cartCountLabel = [UnityLHClass masonryLabel:@"0" font:10 color:[UIColor whiteColor]];
        self.cartCountLabel.backgroundColor = [UIColor redColor];
        self.cartCountLabel.layer.cornerRadius = 15.0f/2;
        self.cartCountLabel.layer.masksToBounds = YES;
        [self.rightButton addSubview:self.cartCountLabel];
        self.cartCountLabel.hidden = !self.cartCount;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.cartCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.rightButton.mas_top).mas_offset(-5);
        make.right.mas_equalTo(self.rightButton.mas_right).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    return __tmpView;
}

- (void)setHasRightButton:(BOOL)hasRightButton{

    _hasRightButton = hasRightButton;
    
    self.rightButton.hidden = !self.hasRightButton;
}

- (void) backButtonTapHandle:(UIButton *)button{
    
    if (self.bBackButtonHandle) {
        
        self.bBackButtonHandle();
    }
}

- (void) rightButtonTapHandle:(UIButton *)button{
    
    if (self.bRightButtonHandle) {
        
        self.bRightButtonHandle();
    }
}

- (void) shyNavigationBarStatus:(BOOL)hide animation:(BOOL)animation{
    
    CGFloat alpha = 0.0f;
    if (!hide){
        alpha = 1.0f;
    }
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundImageView.alpha = alpha;
        }];
    }else{
        self.backgroundImageView.alpha = alpha;
    }
}

- (void) linearShyNavigationBarWithOffset:(CGFloat)offset{
    
    BOOL hide = NO;
    CGFloat ratio = ABS(self.offset - ABS(offset))/self.offset;
    
    hide = offset <= self.offset;// 小于64隐藏
    if (hide) {
        ratio = 0.0f;
    }
    ratio = ratio >= 1 ? 1 : ratio;
    
    self.backgroundImageView.alpha = ratio;
    
    self.backButton.selected = ratio;
    self.rightButton.selected = ratio;
}

- (void) cleanBackButtonImage{

    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setImage:nil forState:UIControlStateSelected];
    
    [self.backButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:nil forState:UIControlStateSelected];
}
- (void)setCartCount:(NSInteger)cartCount{

    _cartCount = cartCount;
    self.cartCountLabel.hidden = !cartCount;
    self.cartCountLabel.text = [NSString stringWithFormat:@" %ld ",(long)cartCount];
}

@end

