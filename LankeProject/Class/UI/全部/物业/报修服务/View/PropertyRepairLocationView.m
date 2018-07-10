//
//  PropertyRepairLocationView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairLocationView.h"

@interface PropertyRepairLocationView ()

@property (nonatomic ,strong) UILabel * addressDisplayLabel;
@property (nonatomic ,strong) UIButton * chooseButton;
@property (nonatomic ,strong) UIView * lineView;
@property (nonatomic ,strong) UILabel * contentDisplayLabel;
@end
@implementation PropertyRepairLocationView

-(void)getDistrictInfo
{
    NSString *districtName=[KeychainManager readDistrictAddress];
//    [self.chooseButton setTitle:districtName forState:UIControlStateNormal];
    self.repairAddressView.text=districtName;
//    self.repairAddress=districtName;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.addressDisplayLabel = [UnityLHClass masonryLabel:@"维修地点" font:17 color:[UIColor blackColor]];
        [self addSubview:self.addressDisplayLabel];
        
        self.repairAddressView = [[JYZTextView alloc] init];
        self.repairAddressView.placeholder = @"请填写具体报修地点";
        self.repairAddressView.font = [UIFont systemFontOfSize:17];
        self.contentView.placeholderColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:self.repairAddressView];
        
//        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:17];
//        self.chooseButton.titleLabel.numberOfLines = 0;
//        self.chooseButton.titleLabel.adjustsFontSizeToFitWidth=YES;
//        [self.chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.chooseButton setTitle:@"" forState:UIControlStateNormal];
//        [self addSubview:self.chooseButton];
        
        self.lineView = [UIView lineView];
        [self addSubview:self.lineView];
        
        self.contentDisplayLabel = [UnityLHClass masonryLabel:@"报修内容" font:17 color:[UIColor blackColor]];
        [self addSubview:self.contentDisplayLabel];
        
        self.contentView = [[JYZTextView alloc] init];
        self.contentView.placeholder = @"内容不超过50字";
        self.contentView.font = [UIFont systemFontOfSize:16];
        self.contentView.placeholderColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:self.contentView];
        
        [self getDistrictInfo];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.bounds) / 3;
    
    [self.addressDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(90);
    }];
    
    [self.repairAddressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.left.mas_equalTo(self.addressDisplayLabel.mas_right);
        make.height.mas_equalTo(height);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.addressDisplayLabel.mas_left);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.addressDisplayLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
    [self.contentDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.addressDisplayLabel.mas_bottom);
        make.left.mas_equalTo(self.addressDisplayLabel.mas_left);
        make.height.mas_equalTo(self.addressDisplayLabel.mas_height);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.contentDisplayLabel.mas_top).mas_offset(7);
        make.left.mas_equalTo(self.contentDisplayLabel.mas_right).mas_offset(30);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
}

+ (instancetype)view{

    return [[self alloc] init];
}

@end
