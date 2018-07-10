//
//  LKEmptyView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/20.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LKEmptyView.h"
#import "LKBottomButton.h"

@interface LKEmptyView ()

@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) LKBottomButton * retryButton;

@end
@implementation LKEmptyView

+ (instancetype)view{

    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel = [UnityLHClass masonryLabel:@"You did't connect network!" font:19 color:[UIColor colorWithHexString:@"555555"]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.retryButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        self.retryButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
        [self.retryButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bRetryHandle) {
                self.bRetryHandle();
            }
        }];
        [self addSubview:self.retryButton];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-40);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.centerX.mas_equalTo(self.titleLabel.mas_centerX);
    }];
}
- (void)setTitle:(NSString *)title{

    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
    }
}
@end
