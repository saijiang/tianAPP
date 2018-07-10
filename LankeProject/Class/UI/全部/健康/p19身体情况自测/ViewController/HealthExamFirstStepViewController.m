//
//  HealthExamFirstStepViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamFirstStepViewController.h"
#import "HealthExamSelectGenderView.h"
#import "HealthExamBaseInfoView.h"
#import "LKBottomButton.h"
#import "HealthExamSecondViewController.h"

@interface HealthExamFirstStepViewController ()

@property (nonatomic ,strong) HealthExamSelectGenderView * selectGrenderView;

@property (nonatomic ,strong) HealthExamBaseInfoView * heightInfoView;
@property (nonatomic ,strong) HealthExamBaseInfoView * ageInfoView;
@property (nonatomic ,strong) HealthExamBaseInfoView * weightInfoView;

@property (nonatomic ,strong) LKBottomButton * nextStepButton;

@end

@implementation HealthExamFirstStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"身体情况自测";
    
    [self creatUI];
}

- (void) creatUI{
    
    LKWeakSelf
    self.selectGrenderView = [HealthExamSelectGenderView view];
    self.selectGrenderView.bSelectGenderHandle = ^(NSString * male){
        
        LKStrongSelf
        [_self.nextStepButton setEnabled:YES];
    };
    [self addSubview:self.selectGrenderView];
    
    HealthBaseInfo * heightInfo = [HealthBaseInfo infoWithName:@"身高" unit:@"cm" valur:170];
    heightInfo.minValue = 100;
    heightInfo.maxValue = 300;
    heightInfo.minUnit = 0.5;
    self.heightInfoView = [HealthExamBaseInfoView view];
    [self.heightInfoView config:heightInfo];
    [self addSubview:self.heightInfoView];
    
    HealthBaseInfo * ageInfo = [HealthBaseInfo infoWithName:@"年龄" unit:@"岁" valur:30];
    ageInfo.minValue = 10;
    ageInfo.maxValue = 100;
    ageInfo.minUnit = 1;
    self.ageInfoView = [HealthExamBaseInfoView view];
    [self.ageInfoView config:ageInfo];
    [self addSubview:self.ageInfoView];
    
    HealthBaseInfo * weightInfo = [HealthBaseInfo infoWithName:@"体重" unit:@"Kg" valur:75];
    weightInfo.minValue = 40;
    weightInfo.maxValue = 200;
    weightInfo.minUnit = 1;
    self.weightInfoView = [HealthExamBaseInfoView view];
    [self.weightInfoView config:weightInfo];
    [self addSubview:self.weightInfoView];
    
    self.nextStepButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [self.nextStepButton setEnabled:NO];
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextStepButton addTarget:self action:@selector(navigationToSecondStep) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextStepButton];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    CGFloat margin = 10.0f;
    [self.selectGrenderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(margin);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.heightInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectGrenderView.mas_left);
        make.top.mas_equalTo(self.selectGrenderView.mas_bottom).mas_offset(margin);
        make.right.mas_equalTo(self.selectGrenderView.mas_right);
        make.height.mas_equalTo(90);
    }];
    
    [self.ageInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.heightInfoView.mas_left);
        make.top.mas_equalTo(self.heightInfoView.mas_bottom).mas_offset(margin);
        make.right.mas_equalTo(self.heightInfoView.mas_right);
        make.height.mas_equalTo(self.heightInfoView.mas_height);
    }];
    
    [self.weightInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageInfoView.mas_left);
        make.top.mas_equalTo(self.ageInfoView.mas_bottom).mas_offset(margin);
        make.right.mas_equalTo(self.ageInfoView.mas_right);
        make.height.mas_equalTo(self.ageInfoView.mas_height);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 15.0f;
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-margin);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.weightInfoView.mas_bottom).mas_offset(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-30);
    }];
}

#pragma mark -
#pragma mark Navigation

- (void) navigationToSecondStep{
    
    // 跳转至身体自测
    HealthExamSecondViewController * second = [[HealthExamSecondViewController alloc] init];
    second.info.male = self.selectGrenderView.male;
    second.info.height = [NSString stringWithFormat:@"%ld",(long)self.heightInfoView.baseInfo.currentValue];
    second.info.age = [NSString stringWithFormat:@"%ld",(long)self.ageInfoView.baseInfo.currentValue];
    second.info.weight = [NSString stringWithFormat:@"%ld",(long)self.weightInfoView.baseInfo.currentValue];
    [self.navigationController pushViewController:second animated:YES];
}
@end
