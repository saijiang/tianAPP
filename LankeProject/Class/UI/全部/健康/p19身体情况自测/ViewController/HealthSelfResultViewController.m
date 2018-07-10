//
//  HealthSelfResultViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthSelfResultViewController.h"
#import "LKBottomButton.h"
#import "HealthExamResultView.h"
#import "HealthExamEvaluateView.h"

#import "FitnessPlanViewController.h"
#import "HealthHomeViewController.h"

@interface HealthSelfResultViewController ()<UINavigationControllerDelegate>

@property (nonatomic ,strong) HealthExamResultView * resultView;
@property (nonatomic ,strong) HealthExamEvaluateView * evaluateView;
@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) LKBottomButton * nextStepButton;
@property (nonatomic ,strong) UILabel * lastLabel;

@end

@implementation HealthSelfResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自测结果";
    [self creatUI];
}

- (void) creatUI{
    
    LKWeakSelf
    self.resultView = [HealthExamResultView view];
    [self addSubview:self.resultView];
    
    self.evaluateView = [HealthExamEvaluateView view];
    self.evaluateView.bFoldButtonHandle = ^(BOOL isFold){
        LKStrongSelf
        [_self updateEvaluateViewRect:isFold];
    };

    [self addSubview:self.evaluateView];
    
    self.displayLabel = [UnityLHClass masonryLabel:@"已为您定制了健身计划" font:14 color:BM_Color_BlackColor];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.displayLabel];
    
    self.nextStepButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [self.nextStepButton setTitle:@"开启健身计划" forState:UIControlStateNormal];
    [self.nextStepButton addTarget:self action:@selector(openHealthPlanHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextStepButton];
    self.lastLabel = [UnityLHClass masonryLabel:@"本自测结果仅供参考，请评估自己实际状况后再开启健康计划。" font:14 color:BM_Color_BlackColor];
    self.lastLabel.textAlignment = NSTextAlignmentLeft;
    self.lastLabel.numberOfLines=0;
    [self addSubview:self.lastLabel];
    
    
    [self.resultView config:self.data];
    [self.evaluateView config:self.data];
    
//    if ([self.data[@"content"] length]==0)
//    {
//        //有疾病不能开启健身计划
////        self.displayLabel.hidden=YES;
////        self.nextStepButton.hidden=YES;
//
//    }

}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(200);
    }];
    [self.evaluateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.resultView.mas_left);
        make.top.mas_equalTo(self.resultView.mas_bottom);
        make.right.mas_equalTo(self.resultView.mas_right);
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultView.left);
        make.right.mas_equalTo(self.resultView.mas_right);
        make.top.mas_equalTo(self.evaluateView.mas_bottom).mas_offset(40);
        make.height.mas_equalTo(30);
    }];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 15.0f;
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-margin);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).mas_offset(20);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-30);
    }];
    [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nextStepButton.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-30);
    }];
}

- (void) updateEvaluateViewRect:(BOOL)isFold{
    
    [self loadViewIfNeeded];
}
#pragma mark -
#pragma mark Action M

- (void) openHealthPlanHandle
{
    
    [UserServices
     getLastFitnessPlanWithUserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             NSDictionary *data=responseObject[@"data"];
             // fag 	String 	1、说明有未结束的健身计划，0、没有未结束的健身计划
             if ([data[@"flag"] integerValue]==1)
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"有未结束的健身计划,确认还要开启新的健身计划吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                 [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                     if (buttonIndex==1)
                     {
                         [self saveFitnessPlan];
                     }
                 }];
             }
             else
             {
                 [self saveFitnessPlan];

             }
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];

    
}

-(void)saveFitnessPlan
{
    [UserServices
     saveFitnessPlanWithUserId:[KeychainManager readUserId]
     userName:[KeychainManager readNickName]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             // 异步
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 //同步一下用户信息
                 [[LAKALABraceletManager sharedInstance]synchronizationInformation];
                 // 回到主线程
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [UnityLHClass showHUDWithStringAndTime:@"开启成功"];
                     BOOL isFitnessPlanViewController=NO;
                     for (UIViewController *viewClass in self.navigationController.viewControllers)
                     {
                         if ([viewClass isKindOfClass:[FitnessPlanViewController class]])
                         {
                             isFitnessPlanViewController=YES;
                             [self.navigationController popToViewController:viewClass animated:YES];
                         }
                     }
                     if (!isFitnessPlanViewController)
                     {
                         FitnessPlanViewController *fitnessPlan=[[FitnessPlanViewController alloc]init];
                         [self.navigationController pushViewController:fitnessPlan animated:YES];
                         
                     }

                 });
             });
             
             
        }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
         
     }];
    

}

-(void)baseBackBtnAction:(UIButton *)btn
{
    BOOL isFitnessPlanViewController=NO;
    for (UIViewController *viewClass in self.navigationController.viewControllers)
    {
        if ([viewClass isKindOfClass:[FitnessPlanViewController class]])
        {
            isFitnessPlanViewController=YES;
            [self.navigationController popToViewController:viewClass animated:YES];
        }
    }
    if (!isFitnessPlanViewController)
    {
        
        for (UIViewController *viewClass in self.navigationController.viewControllers)
        {
            if ([viewClass isKindOfClass:[HealthHomeViewController class]])
            {
                [self.navigationController popToViewController:viewClass animated:YES];
            }
        }
    }
}

@end
