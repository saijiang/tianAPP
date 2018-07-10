//
//  PropertyPayContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayContentView.h"

@interface PropertyPayContentView ()

@property (nonatomic ,strong) NSMutableArray * items;

@end

@implementation PropertyPayContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.items = [NSMutableArray array];
        NSArray * titles = @[@"水费",@"网费/电话费",@"停车费",@"供暖费",@"物业费",@"生活热水费",@"燃气费"];
        NSArray * images = @[[UIImage imageNamed:@"property_pay_home_shuifei"],
                             [UIImage imageNamed:@"property_pay_home_wangfei"],
                             [UIImage imageNamed:@"property_pay_home_tingchefei"],
                             [UIImage imageNamed:@"property_pay_home_gongnuan"],
                             [UIImage imageNamed:@"property_pay_home_wuyefei"],
                             [UIImage imageNamed:@"property_pay_home_shenghuoreshuifei"],
                             [UIImage imageNamed:@"property_pay_home_ranqifei"]];
        for (NSInteger index = 0; index < 7 ; index ++) {
            
            TopImageButton * itemButton = [[TopImageButton alloc] init];
            itemButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [itemButton setTitleColor:[UIColor colorWithHexString:@"555555"] forState:UIControlStateNormal];
            itemButton.tag = 1010 + index;
            [itemButton setTitle:titles[index] forState:UIControlStateNormal];
            [itemButton setImage:images[index] forState:UIControlStateNormal];
            [itemButton addTarget:self action:@selector(itemButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemButton];
            [self.items addObject:itemButton];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds)/4;
    CGFloat margin = 30.0f;
    CGFloat margin_v = 20.0f;
    CGFloat height = (CGRectGetHeight(self.bounds) - 2 * margin - margin_v)/2;
    
    NSInteger index = 0;
    for (UIView * item in self.items) {
        
        [item mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.left.mas_equalTo((index % 4) * width);
            make.top.mas_equalTo((index / 4) * (height + margin_v) + margin);
        }];
        index ++;
    }
}

- (void) itemButtonHandle:(UIButton *)button{
    
    if (self.bSelectHandle) {
        self.bSelectHandle(button.tag - 1010);
    }
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    
}

@end
