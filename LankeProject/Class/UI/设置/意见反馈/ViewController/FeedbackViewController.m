//
//  FeedbackViewController.m
//  LankeProject
//
//  Created by itman on 17/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FeedbackViewController.h"
#import "JYZTextView.h"

@interface FeedbackViewController ()

@property(nonatomic,strong)JYZTextView *feedback;
@property(nonatomic,strong)UITextField *phone;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"意见反馈"];
}
-(void)createUI
{
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor=BM_WHITE;
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(150);
    }];
    
    UILabel *feed=[UnityLHClass masonryLabel:@"反馈内容" font:16.0 color:BM_BLACK];
    [headerView addSubview:feed];
    [feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    UILabel *limit=[UnityLHClass masonryLabel:@"(字数不超过100个字)" font:13.0 color:BM_Color_GrayColor];
    [headerView addSubview:limit];
    [limit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(-10);
    }];
    
    self.feedback=[[JYZTextView alloc]init];
    self.feedback.font=BM_FONTSIZE(16.0);
    self.feedback.placeholder=@"请输入反馈内容";
    [headerView addSubview:self.feedback];
    [self.feedback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(feed.mas_top).offset(-7);
        make.bottom.mas_equalTo(limit.mas_top).offset(-10);
    }];
    
    UIView *phoneView=[[UIView alloc]init];
    phoneView.backgroundColor=BM_WHITE;
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(headerView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *phone=[UnityLHClass masonryLabel:@"联系方式" font:16.0 color:BM_BLACK];
    [phoneView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(phoneView.mas_centerY);
    }];
    
    self.phone=[[UITextField alloc]init];
    self.phone.font=BM_FONTSIZE(16.0);
    self.phone.placeholder=@"请输入联系方式";
    [phone addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(phoneView.mas_centerY);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *submitButton=[UnityLHClass masonryButton:@"提交" font:16.0 color:BM_WHITE];
    submitButton.backgroundColor=BM_Color_Blue;
    submitButton.layer.masksToBounds=YES;
    submitButton.layer.cornerRadius=5;
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(phoneView.mas_bottom).offset(60);
    }];
    [submitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
     {
         [UnityLHClass showHUDWithStringAndTime:@"提交成功"];
         [self.navigationController popViewControllerAnimated:YES];
     }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
