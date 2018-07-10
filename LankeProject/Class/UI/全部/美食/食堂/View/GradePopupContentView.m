//
//  GradePopupContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "GradePopupContentView.h"

#import "LKBottomButton.h"

@interface GradePopupContentView ()

@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) LKBottomButton * commitButton;

@property (nonatomic ,strong) LKBottomButton * cancelButton;
@end

@implementation GradePopupContentView


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
        
        _displayLabel = [UnityLHClass masonryLabel:@"评分" font:16 color:BM_Color_BlackColor];
        [self addSubview:_displayLabel];
        
        _ratingView = [[AXRatingView alloc] init];
        _ratingView.baseColor = [UIColor colorWithHexString:@"#999999"];
        _ratingView.stepInterval = 1;
        _ratingView.value = 5;
        _ratingView.markFont = [UIFont systemFontOfSize:25];
        _ratingView.highlightColor = [UIColor colorWithHexString:@"#FDCD63"];
        [self addSubview:_ratingView];
        
        _contentTextView = [[JYZTextView alloc] init];
        _contentTextView.placeholder = @"请输入评价内容...";
        _contentTextView.placeHolderLabel.font = [UIFont systemFontOfSize:14];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.layer.cornerRadius = 5.0f;
        _contentTextView.layer.borderColor = [UIColor colorWithHexString:@"#EFEFEF"].CGColor;
        _contentTextView.layer.borderWidth = 2 / [UIScreen mainScreen].scale;
        _contentTextView.placeholderColor = [UIColor colorWithHexString:@"cccccc"];
        [self addSubview:_contentTextView];
        
        _commitButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitButton];
        
        _cancelButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self closePopup];
        }];
        [_cancelButton hll_setBackgroundImageWithHexString:@"cbcbcb" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        
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
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(self.titleLabel.mas_height);
    }];
    [self.ratingView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY).mas_offset(-5);
        make.left.mas_equalTo(self.displayLabel.mas_right).mas_offset(10);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.displayLabel.mas_left);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(150);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH / 4);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH / 4);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
    }];
}

- (void) commitButtonHandle:(UIButton *)button{
    
    if (!self.contentTextView.text.length) {
        
        [UnityLHClass showHUDWithStringAndTime:@"请输入评价内容"];
        
        return;
    }
    
    if (self.bCommitButtonHandle) {
    
        self.bCommitButtonHandle(self.contentTextView.text,self.ratingView.value,self);
    }
    
    //[self closePopup];
}

#pragma mark -
#pragma mark PopupContentViewDelegate

- (CGRect)showRect{
    
    CGFloat height = 0.0f;
    height += 50;
    height += 40;
    height += 20.0f;
    height += 150.0f;
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
