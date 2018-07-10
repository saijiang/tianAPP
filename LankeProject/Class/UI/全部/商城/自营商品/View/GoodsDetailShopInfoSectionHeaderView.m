//
//  GoodsDetailShopInfoSectionHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GoodsDetailShopInfoSectionHeaderView.h"

@interface GoodsDetailShopInfoSectionHeaderView ()

@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) UIImageView * shopIconImageView;
@property (nonatomic ,strong) UILabel * shopNameLabel;
@property (nonatomic ,strong) UILabel * shopDesLabel;

@property (nonatomic ,strong) UIView * lineView;

@property (nonatomic ,strong) UIButton * gotoShopButton;
@end

@implementation GoodsDetailShopInfoSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds=YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.shopIconImageView = [[UIImageView alloc] init];
        self.shopIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.shopIconImageView.image = [UIImage imageNamed:@"temp_logo"];
        self.shopIconImageView.layer.masksToBounds = YES;
        self.shopIconImageView.layer.cornerRadius = 20;
        self.shopIconImageView.layer.borderColor = BM_Color_Blue.CGColor;
        self.shopIconImageView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:self.shopIconImageView];
        
        self.shopNameLabel = [UnityLHClass masonryLabel:@"ZARA官方旗舰店" font:16 color:BM_Color_BlackColor];
        self.shopNameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.shopNameLabel];
        
        self.shopDesLabel = [UnityLHClass masonryLabel:@"简介" font:15 color:[UIColor colorWithHexString:@"999999"]];
        self.shopDesLabel.numberOfLines = 0;
        [self.contentView addSubview:self.shopDesLabel];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.lineView];
        
        self.gotoShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.gotoShopButton setTitle:@"进店" forState:UIControlStateNormal];
        [self.gotoShopButton setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
        self.gotoShopButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.gotoShopButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bGotoShopHandle) {
                self.bGotoShopHandle();
            }
        }];
        [self.contentView addSubview:self.gotoShopButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
    
    [self.shopIconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.shopIconImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.shopDesLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.shopNameLabel.mas_left);
        make.top.mas_equalTo(self.shopNameLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    CGFloat buttonHeight = 40.0f;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.shopDesLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    [self.gotoShopButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(buttonHeight);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

-(void)hideViewGotoButton
{
    self.gotoShopButton.hidden=YES;
    self.lineView.hidden=YES;
}

- (void)config:(id)data{
 
    self.shopNameLabel.text = data[@"merchantName"];
    self.shopDesLabel.text = data[@"merchantIntroduction"];
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"merchantLogo"]]
                              placeholderImage:[UIImage imageNamed:@"temp_logo"]];
}

+ (CGFloat)height:(id)data{

    NSString * des = data[@"merchantIntroduction"];
    CGFloat width = DEF_SCREEN_WIDTH - 15 - 40 - 15 - 10;
    CGFloat textHeight = [UnityLHClass getHeight:des wid:width font:15];
    
    CGFloat height = 0.0f;
    height += 10;
    height += 10;

    
    height += 15;
    height += 20;
    height += 5;
    height += des ? textHeight : 40;// 简介的高度，有可能需要替换成图片的高度
    height += 10;
    height += 1/[UIScreen mainScreen].scale;
    height += 40.0f;
    
    height += 10;
    return height;
}
@end
