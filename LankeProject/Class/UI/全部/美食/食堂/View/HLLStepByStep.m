//
//  HLLStepByStep.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLStepByStep.h"

@interface HLLStepByStep ()

@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) IBOutlet UITextField *currentCountTextField;

@property (nonatomic ,assign ,readwrite) NSInteger minCount;
@property (nonatomic ,assign ,readwrite) NSInteger currentCount;
@property (nonatomic ,assign ,readwrite) NSInteger maxCount;

@end

@implementation HLLStepByStep

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentCount = 0;
        _minCount = 0;
        _maxCount = NSNotFound;
        
        _limitStep = YES;
    
        self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.minusButton setTitle:@"-" forState:UIControlStateNormal];
        [self.minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.minusButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.minusButton hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];
        [self.minusButton addTarget:self action:@selector(minusCountHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.minusButton];
        
        self.currentCountTextField = [UnityLHClass masonryField:nil font:15 color:[UIColor blackColor]];
        self.currentCountTextField.text = [NSString stringWithFormat:@"%ld",(long)_currentCount];
        self.currentCountTextField.textAlignment = NSTextAlignmentCenter;
        self.currentCountTextField.userInteractionEnabled = NO;
        self.currentCountTextField.backgroundColor = [UIColor colorWithHexString:@"#F1F8FB"];
        [self addSubview:self.currentCountTextField];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.addButton hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addCountHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
    }
    return self;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(CGRectGetWidth(self.frame)/3);
    }];
    [self.currentCountTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.minusButton.mas_top);
        make.left.mas_equalTo(self.minusButton.mas_right);
        make.bottom.mas_equalTo(self.minusButton.mas_bottom);
        make.width.mas_equalTo(self.minusButton.mas_width);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.minusButton.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.minusButton.mas_bottom);
        make.width.mas_equalTo(self.minusButton.mas_width);
    }];
}

#pragma mark - API

- (void) configureMinCount:(NSInteger)minCount
              currentCount:(NSInteger)currentCount
                  maxCount:(NSInteger)maxCount{
    
    _minCount = minCount;
    _currentCount = currentCount;
    _maxCount = maxCount;
    
    [self changeCountWithButtonHandle];
}

#pragma mark - Method

- (void) currentCountDidChage:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
    
    NSInteger inputCount = textField.text.integerValue;
    if (inputCount > self.maxCount ) {
        inputCount = self.maxCount;
        NSLog(@"一种情况是输入数据超过最大数量");
    }
    self.currentCount = textField.text.integerValue;
}

- (void) changeCountWithButtonHandle{
    
    if (self.limitStep) {
        
        self.addButton.enabled = self.currentCount != self.maxCount;
    }
    self.minusButton.enabled = self.currentCount > self.minCount;
    
    self.currentCountTextField.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
}

#pragma mark - Action

- (IBAction)addCountHandle:(UIButton *)sender {
    
    self.currentCount += 1;
    
    if (self.handle) {
        self.handle(self.currentCount,YES);
    }
    [self changeCountWithButtonHandle];
    
    NSLog(@"current:%ld",(long)self.currentCount);
}

- (IBAction)minusCountHandle:(UIButton *)sender {
    
    self.currentCount -= 1;
    
    if (self.handle) {
        self.handle(self.currentCount,NO);
    }
    
    [self changeCountWithButtonHandle];
    
    NSLog(@"current:%ld",(long)self.currentCount);
}

@end

