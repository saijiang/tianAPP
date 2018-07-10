//
//  JDFilterFooterView.m
//  LankeProject
//
//  Created by zhounan on 2017/12/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDFilterFooterView.h"
@interface JDFilterFooterView ()

@property (nonatomic,strong)UILabel *allLab;//全部品牌
@property (nonatomic,strong)LocalhostImageView *arrowImgView;//箭头

@end
@implementation JDFilterFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self  createUI];
        
    }
    return self;
}

-(void)createUI
{
    self.allLab = [UnityLHClass masonryLabel:@"全部品牌" font:15.0 color:[UIColor colorWithHexString:@"#999999"]];
    self.allLab.hidden = YES;
    [self addSubview:self.allLab];
    
    self.arrowImgView = [[LocalhostImageView alloc]initWithImage:[UIImage imageNamed:@"UserCenter-RightArrow"]];
    self.arrowImgView.hidden = YES;
    [self addSubview:self.arrowImgView];
    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_allBtn];
}

-(void)layoutSubviews
{
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(7);
        make.height.offset(15);
    }];
    
    [self.allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-10);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

+ (NSString *)reuseIdentifier{
    
    return @"LKFilterFooterView";
}

- (void) configureFooterViewWithData:(id)data
{
    if ([data isEqualToString:@"header"]) {
        self.allLab.hidden = YES;
        self.arrowImgView.hidden = YES;
        self.allLab.hidden = YES;
    }else{
    self.allLab.hidden = NO;
    self.arrowImgView.hidden = NO;
    self.allLab.text = data;
    }
}


@end
