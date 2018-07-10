//
//  ErCodePayResultViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ErCodePayResultViewController.h"
#import "LKBottomButton.h"

@interface ErCodePayResultViewController ()

@property (nonatomic ,strong) LocalhostImageView * successImageView;
@property (nonatomic ,strong) UILabel * successDisplayLabel;

@property (nonatomic ,strong) UILabel * successPayPriceLabel;

@property (nonatomic ,strong) UIView * topLineView;
@property (nonatomic ,strong) UILabel * payDisplayLabel;
@property (nonatomic ,strong) UILabel * payDesLabel;
@property (nonatomic ,strong) UIView * bottomLineView;

@property (nonatomic ,strong) LKBottomButton * finishButton;
@end

@implementation ErCodePayResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"交易详情";
}

- (void)createUI{

    self.successImageView = [[LocalhostImageView alloc] init];
    self.successImageView.image = [UIImage imageNamed:@"alert_icon_pay"];
    [self addSubview:self.successImageView];
    
    self.successDisplayLabel = [UnityLHClass masonryLabel:@"支付成功" font:20 color:BM_Color_Blue];
    self.successDisplayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.successDisplayLabel];
    
    self.successPayPriceLabel = [UnityLHClass masonryLabel:[NSString stringWithFormat:@"%.2f",[self.resultData[@"price"] floatValue]] font:35 color:BM_BLACK];
    self.successPayPriceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.successPayPriceLabel];
    
    self.topLineView = [UIView new];
    self.topLineView.backgroundColor = BM_Color_SeparatorColor;
    [self addSubview:self.topLineView];
    
    self.payDisplayLabel = [UnityLHClass masonryLabel:@"收款商家" font:14 color:[UIColor colorWithHexString:@"888888"]];
    [self addSubview:self.payDisplayLabel];
    
    self.payDesLabel = [UnityLHClass masonryLabel:self.resultData[@"name"] font:14 color:[UIColor colorWithHexString:@"888888"]];
    self.payDesLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.payDesLabel];
    
    self.bottomLineView = [UIView new];
    self.bottomLineView.backgroundColor = BM_Color_SeparatorColor;
    [self addSubview: self.bottomLineView];
    
    self.finishButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton addTarget:self action:@selector(finishButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self addSubview:self.finishButton];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.successDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
    
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.mas_equalTo(self.successDisplayLabel.centerY);
    }];
    
    [self.successPayPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.successDisplayLabel.mas_left);
        make.right.mas_equalTo(self.successDisplayLabel.mas_right);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.successDisplayLabel.mas_bottom).mas_offset(10);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.top.mas_equalTo(self.successPayPriceLabel.mas_bottom).mas_offset(10);
    }];
    [self.payDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topLineView.mas_left);
        make.top.mas_equalTo(self.topLineView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(25);
    }];
    [self.payDesLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.payDisplayLabel.mas_top);
        make.height.mas_equalTo(self.payDisplayLabel.mas_height);
        make.right.mas_equalTo(self.topLineView.mas_right);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.topLineView.mas_left);
        make.right.mas_equalTo(self.topLineView.mas_right);
        make.height.mas_equalTo(self.topLineView.mas_height);
        make.top.mas_equalTo(self.payDisplayLabel.mas_bottom).mas_offset(10);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.bottomLineView.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.bottomLineView.mas_left);
        make.right.mas_equalTo(self.bottomLineView.mas_right);
        make.height.mas_equalTo(45);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) finishButtonHandle:(id)button{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
