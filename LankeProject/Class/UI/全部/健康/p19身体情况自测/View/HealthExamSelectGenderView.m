//
//  HealthExamSelectGenderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamSelectGenderView.h"

@interface HealthExamSelectGenderView ()

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) UIButton * maleButton;
@property (nonatomic ,strong) UIButton * femaleButton;

@property (nonatomic ,strong) NSArray  * buttons;
@end

@implementation HealthExamSelectGenderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"性别" font:16 color:BM_Color_BlackColor];
        self.displayLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.displayLabel];
        
        self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.maleButton addTarget:self action:@selector(grenderChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.maleButton setImage:[UIImage imageNamed:@"choose-off"] forState:UIControlStateNormal];
        [self.maleButton setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self.maleButton setTitle:@"  男士" forState:UIControlStateNormal];
        self.maleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.maleButton setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
        [self addSubview:self.maleButton];
        
        self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.femaleButton.tag = 10101;
        [self.femaleButton addTarget:self action:@selector(grenderChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.femaleButton setImage:[UIImage imageNamed:@"choose-off"] forState:UIControlStateNormal];
        [self.femaleButton setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self.femaleButton setTitle:@"  女士" forState:UIControlStateNormal];
        self.femaleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.femaleButton setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
        [self addSubview:self.femaleButton];

        self.buttons = @[self.maleButton,self.femaleButton];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self grenderChoose:self.maleButton];

        });
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.displayLabel.mas_right).mas_offset(50);
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.maleButton.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(10);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) grenderChoose:(UIButton *)button{

    NSString * male = @"01";
    for (UIButton * sender in self.buttons) {
        
        sender.selected = [sender isEqual:button];
        
    }
    if (button.tag == 10101) {
        // 10101
        male = @"02";
    }
    self.male = male;
    if (self.bSelectGenderHandle) {
        self.bSelectGenderHandle(male);
    }
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{

    return [[self alloc] init];
}
@end
