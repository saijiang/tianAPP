//
//  LKToolView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKToolView.h"

@interface LKToolView ()


@end

@implementation LKToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F8"];
        
        self.titleLabel = [UnityLHClass masonryLabel:@"购物车" font:17 color:BM_Color_BlackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:BM_Color_GrayColor forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancelButton addTarget:self action:@selector(cancelButtonHandle) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.hidden=YES;
        [self addSubview:self.cancelButton];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.sureButton addTarget:self action:@selector(sureButtonHandle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sureButton];
        
    }
    return self;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(self.mas_height);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(self.cancelButton.mas_height);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.cancelButton.mas_top);
    }];
    
}


#pragma mark -
#pragma mark Action M

- (void) cancelButtonHandle{
    
    if (self.bCancelHandle) {
        self.bCancelHandle();
    }
}

- (void) sureButtonHandle{
    
    if (self.bSureHandle) {
        self.bSureHandle();
    }
}

@end
