//
//  TCMResultItemView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "TCMResultItemView.h"

@interface TCMResultItemView ()

@property (nonatomic ,strong) UILabel * resultTitleLabel;

@property (nonatomic ,strong) UILabel * resultContentLabel;

@end
@implementation TCMResultItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.resultTitleLabel = [UnityLHClass masonryLabel:@"" font:16 color:BM_Color_Blue];
        [self addSubview:self.resultTitleLabel];
        
        self.resultContentLabel = [UnityLHClass masonryLabel:@"" font:13 color:[UIColor colorWithHexString:@"999999"]];
        self.resultContentLabel.numberOfLines = 0;
        [self addSubview:self.resultContentLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.resultTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
    [self.resultContentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.resultTitleLabel.mas_left);
        make.top.mas_equalTo(self.resultTitleLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.resultTitleLabel.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void) configForTop:(id)data{

    self.resultTitleLabel.text = data[@"selfTestResult"];
    self.resultContentLabel.text = data[@"calmPoint"];
}

- (void) configForCenter:(id)data{

    self.resultTitleLabel.text = @"结果评析";
    self.resultContentLabel.text = data[@"resultAnalyse"];
}

- (void) configForBottom:(id)data{

    self.resultTitleLabel.text = @"健康指导";
    self.resultContentLabel.text = data[@"healthGuidance"];
}

@end
