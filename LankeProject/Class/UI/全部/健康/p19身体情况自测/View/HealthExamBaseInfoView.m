//
//  HealthExamBaseInfoView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamBaseInfoView.h"

@interface HealthExamBaseInfoView ()

@property (nonatomic ,strong) UILabel * typeNameLabel;
@property (nonatomic ,strong) UILabel * typeUnitLabel;
@property (nonatomic ,strong) UILabel * currentValueLabel;
@property (nonatomic ,strong) CRRulerControl * ruleView;

@end
@implementation HealthExamBaseInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.typeNameLabel = [UnityLHClass masonryLabel:@"身高" font:16 color:BM_Color_BlackColor];
        self.typeNameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.typeNameLabel];
        
        self.typeUnitLabel = [UnityLHClass masonryLabel:@"（cm）" font:15 color:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:self.typeUnitLabel];
        
        self.currentValueLabel = [UnityLHClass masonryLabel:@"177" font:30 color:BM_Color_Blue];
        self.currentValueLabel.font = [UIFont boldSystemFontOfSize:27];
        [self addSubview:self.currentValueLabel];
        
        self.ruleView = [[CRRulerControl alloc] init];
        self.ruleView.tintColor = BM_Color_BlackColor;
        self.ruleView.layer.cornerRadius = 5.0f;
        self.ruleView.layer.masksToBounds = YES;
        self.ruleView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.ruleView.layer.borderColor = BM_Color_SeparatorColor.CGColor;
        self.ruleView.spacingBetweenMarks = 3;
        [self.ruleView setColor:[UIColor colorWithHexString:@"999999"] forMarkType:CRRulerMarkTypeMinor];
        [self.ruleView setSize:CGSizeMake(2/[UIScreen mainScreen].scale, 30) forMarkType:CRRulerMarkTypeMajor];
        [self.ruleView setSize:CGSizeMake(1/[UIScreen mainScreen].scale, 25) forMarkType:CRRulerMarkTypeMiddle];
        [self.ruleView setSize:CGSizeMake(1/[UIScreen mainScreen].scale, 18) forMarkType:CRRulerMarkTypeMinor];
        [self.ruleView setOffset:CGPointMake(0, -10) forMarkType:CRRulerMarkTypeAll];
        [self.ruleView setAlignment:CRRulerMarkAlignmentTop forMarkType:CRRulerMarkTypeAll];
        [self.ruleView setTextOffset:CGPointMake(0, -5) forMarkType:CRRulerMarkTypeAll];
        [self.ruleView setTextColor:[UIColor clearColor] forMarkType:CRRulerMarkTypeMiddle];
        self.ruleView.pointerImageView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"#FF696E"]];
        [self.ruleView addTarget:self action:@selector(ruleViewDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.ruleView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.typeUnitLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.typeNameLabel.mas_right);
        make.top.mas_equalTo(self.typeNameLabel.mas_top);
    }];
    
    [self.currentValueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.typeNameLabel.mas_left);
        make.bottom.offset(-10);
    }];
    
    [self.ruleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(self.typeNameLabel.mas_top);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{

    return [[self alloc] init];
}

- (void)config:(HealthBaseInfo *)baseInfo{

    self.ruleView.rangeFrom = baseInfo.minValue;
    self.ruleView.rangeLength = baseInfo.maxValue - baseInfo.minValue;
    CGFloat width = (baseInfo.maxValue - baseInfo.minValue) / (2.0);
    self.ruleView.rulerWidth = (width) * 10.0;
//    self.ruleView.
    [self.ruleView setValue:baseInfo.currentValue animated:YES];
    
    self.typeNameLabel.text = baseInfo.name;
    self.typeUnitLabel.text = [NSString stringWithFormat:@"（%@）",baseInfo.unit];
    self.currentValueLabel.text = [NSString stringWithFormat:@"%ld",(long)baseInfo.currentValue];
    self.baseInfo = baseInfo;
}

#pragma mark -
#pragma mark Action M

- (void) ruleViewDidChangeValue:(CRRulerControl *)ruleView{
    
    DEF_DEBUG(@"%f",ruleView.value);
    self.baseInfo.currentValue = (NSInteger)ruleView.value;
    self.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",ruleView.value];
}

@end

@implementation HealthBaseInfo

+ (instancetype) infoWithName:(NSString *)name unit:(NSString *)unit valur:(NSInteger)value{

    HealthBaseInfo * baseInfo = [[HealthBaseInfo alloc] init];
    baseInfo.name = name;
    baseInfo.unit = unit;
    baseInfo.currentValue = value;
    baseInfo.minValue = 10;
    baseInfo.maxValue = 300;
    baseInfo.minUnit = 1;
    return baseInfo;
}

@end
