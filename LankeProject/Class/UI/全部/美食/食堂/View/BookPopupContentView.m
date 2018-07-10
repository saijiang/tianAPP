//
//  BookPopupContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BookPopupContentView.h"
#import "LKBottomButton.h"

@interface BookPopupContentView ()

@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) LocalhostImageView * confirmImageView;

@property (nonatomic ,copy) void (^bLeftHandle)();

@property (nonatomic ,copy) void (^bRightHandle)();

@end

@implementation BookPopupContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UnityLHClass masonryLabel:@"提示" font:17 color:[UIColor whiteColor]];
        _titleLabel.backgroundColor = BM_Color_Blue;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _displayLabel = [UnityLHClass masonryLabel:@"是否点菜" font:16 color:BM_Color_BlackColor];
        _displayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_displayLabel];
        
        
        _iconImageView = [[LocalhostImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@""];
        [self addSubview:_iconImageView];
        
        _confirmImageView = [[LocalhostImageView alloc] init];
        _confirmImageView.image = [UIImage imageNamed:@""];
        _confirmImageView.hidden = YES;
        [self addSubview:_confirmImageView];
        
        _nothingButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _nothingButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nothingButton setTitle:@"提交" forState:UIControlStateNormal];
        _nothingButton.layer.borderColor = BM_Color_Blue.CGColor;
        _nothingButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        [_nothingButton hll_setBackgroundImageWithHexString:@"ffffff" forState:UIControlStateNormal];
        [_nothingButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
        [_nothingButton addTarget:self action:@selector(nothingButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nothingButton];
        
        _commitButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitButton];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.confirmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
        make.right.mas_equalTo(self.iconImageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.titleLabel.mas_height);
    }];
    
    [self.nothingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(self.width*0.4);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-20);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(self.nothingButton.mas_width);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.nothingButton.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-20);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) nothingButtonHandle:(UIButton *)button{
    
    if (self.bLeftHandle) {
        
        self.bLeftHandle();
    }
    
    [self closePopup];
}
- (void) commitButtonHandle:(UIButton *)button{
    
    if (self.bRightHandle) {
        
        self.bRightHandle();
    }
    
    [self closePopup];
}


#pragma mark -
#pragma mark API


- (void) configLeftButton:(NSString *)left handle:(void(^)())handle{

    [self.nothingButton setTitle:left forState:UIControlStateNormal];
    
    self.bLeftHandle = handle;
}

- (void) configRightButton:(NSString *)right handle:(void(^)())handle{
    
    [self.commitButton setTitle:right forState:UIControlStateNormal];
    
    self.bRightHandle = handle;
}

#pragma mark -
#pragma mark PopupContentViewDelegate

- (CGRect)showRect{
    
    CGFloat height = 0.0f;
    height += 50;
    height += 80;
    height += 20.0f;
    height += 50.0f;
    height += 45.0f;
    height += 40;
    
    return CGRectMake(50, (DEF_SCREEN_HEIGHT - height) / 2, DEF_SCREEN_WIDTH - 100, height);
}

// YES：击返回空的区域
- (BOOL)isAlert
{
    return NO;
}


@end
