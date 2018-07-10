//
//  HealthExamResultView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamResultView.h"

@interface HealthExamResultView ()

@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UILabel * BMILabel;
@property (nonatomic ,strong) UILabel * resultLabel;
@property (nonatomic ,strong) UIView * lineView;

@end

@implementation HealthExamResultView

+ (instancetype)view{

    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"您的自测结果" font:15 color:BM_Color_BlackColor];
        self.displayLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.displayLabel];
        
        self.resultLabel = [UnityLHClass masonryLabel:@"偏胖" font:25 color:BM_Color_Blue];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.resultLabel];
        
        self.BMILabel = [UnityLHClass masonryLabel:@"BMI指数是身体质量指数，是用体重公斤数除以身高米数平方得出的数字，是目前国际上常用的衡量人体胖瘦程度以及是否健康的一个标准。其正常范围BMI为18.5~23.9 之间。" font:16 color:BM_Color_Blue];
        self.BMILabel.numberOfLines=0;
        [self addSubview:self.BMILabel];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
  
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.displayLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(30);
    
    }];
    [self.BMILabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.resultLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.height.mas_equalTo(100);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.mas_equalTo(self.mas_bottom);    
    }];
}

- (void) config:(id)data{

    self.resultLabel.text=[NSString stringWithFormat:@"%@(BMI:%@)",data[@"result"],data[@"bmiIndex"]];
}
@end
