//
//  FitnessPlanHeaderView.m
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessPlanHeaderView.h"
#import "PlanWeatherView.h"
#import "PlanInfoViewController.h"
#import "RingViewController.h"
#import "WCGraintCircleLayer.h"
#import "AddSportHistoryViewController.h"

@interface FitnessPlanHeaderView ()

@property(nonatomic,strong)id data;
@property(nonatomic,strong)WCGraintCircleLayer *circleLayer;


@property(nonatomic,strong)PlanWeatherView *watherView;
@property(nonatomic,strong)UILabel *targetCost;
@property(nonatomic,strong)UILabel *todayCost;
@property(nonatomic,strong)UIButton *resetPlan;
@property(nonatomic,strong)UILabel *planDays;
@property(nonatomic,strong)UIImageView *centerImage;
@end

@implementation FitnessPlanHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    
    }
    return self;
}
-(void)createUI
{
    self.watherView=[[PlanWeatherView alloc]init];
    [self addSubview:self.watherView];
    [self.watherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(120);

    }];
    [self.watherView updateWeatherData];

    UIButton *scanInfo=[UnityLHClass masonryButton:@"查看计划详情" font:14.0 color:BM_WHITE];
    [scanInfo setBackgroundImage:[UIImage imageNamed:@"health_btn"] forState:UIControlStateNormal];
    [self addSubview:scanInfo];
    [scanInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.watherView.mas_centerY);
    }];
    [scanInfo handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        PlanInfoViewController * info = [[PlanInfoViewController alloc] init];
        info.fitnessId=self.data[@"id"];
        [self.topViewController.navigationController pushViewController:info animated:YES];
    }];
    UIImageView *centerImage=[[UIImageView alloc]init];
//    centerImage.image=[UIImage imageNamed:@"health_round"];
    centerImage.userInteractionEnabled=YES;
    [self addSubview:centerImage];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [centerImage addGestureRecognizer:tap];
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.and.height.mas_equalTo(DEF_HEIGHT(self)/2.0-8);
    }];
    self.centerImage=centerImage;
    self.centerImage.layer.masksToBounds=YES;
    self.centerImage.layer.cornerRadius =(DEF_HEIGHT(self)/2.0-8)/2.0;
    self.centerImage.layer.borderWidth=10;
    self.centerImage.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    
    self.todayCost=[UnityLHClass masonryLabel:@"0" font:50.0 color:[UIColor colorWithRed:0.00 green:0.62 blue:0.95 alpha:1.00]];
    self.todayCost.font=[UIFont boldSystemFontOfSize:50.0];
    self.todayCost.adjustsFontSizeToFitWidth=YES;
    [centerImage addSubview:self.todayCost];
    [self.todayCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerImage.mas_centerX);
        make.centerY.mas_equalTo(centerImage.mas_centerY);
        make.width.mas_lessThanOrEqualTo(DEF_HEIGHT(self)/2.0-100);
    }];
    UILabel *todayCost=[UnityLHClass masonryLabel:@"千卡" font:12.0 color:[UIColor colorWithRed:0.00 green:0.62 blue:0.95 alpha:1.00]];
    [centerImage addSubview:todayCost];
    [todayCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.todayCost.mas_right);
        make.bottom.mas_equalTo(self.todayCost.mas_bottom).offset(-10);
    }];

    
    UILabel *today=[UnityLHClass masonryLabel:@"今日消耗" font:14.0 color:BM_BLACK];
    [centerImage addSubview:today];
    [today mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerImage.mas_centerX);
        make.bottom.mas_equalTo(self.todayCost.mas_top).offset(-5);
        
    }];
    
    self.targetCost=[UnityLHClass masonryLabel:@"目标0千卡" font:14.0 color:[UIColor colorWithRed:0.32 green:0.64 blue:0.84 alpha:1.00]];
    self.targetCost.adjustsFontSizeToFitWidth=YES;
    [centerImage addSubview:self.targetCost];
    [self.targetCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerImage.mas_centerX);
        make.top.mas_equalTo(self.todayCost.mas_bottom).offset(5);
        make.width.mas_lessThanOrEqualTo(self.centerImage.mas_width).multipliedBy(0.5);
        
    }];
    
    UIView *resetPlanView=[[UIView alloc]init];
    [self addSubview: resetPlanView];
    
    self.planDays=[UnityLHClass masonryLabel:@"健身计划已进入第0天" font:14.0 color:BM_BLACK];
    [resetPlanView addSubview:self.planDays];
    
    self.resetPlan=[UnityLHClass masonryButton:@"重置计划" font:14.0 color:BM_Color_Blue];
    self.resetPlan.bottomlineWithColor=BM_Color_Blue;
    [resetPlanView addSubview:self.resetPlan];
    [self.resetPlan handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self resetFitnessPlan];
    }];
    
    [self.planDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(resetPlanView.mas_centerY);
        make.left.mas_equalTo(resetPlanView.mas_left);
    }];
    
    [self.resetPlan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(resetPlanView.mas_centerY);
        make.left.mas_equalTo(self.planDays.mas_right);
        make.right.mas_equalTo(resetPlanView.mas_right);
        make.height.mas_equalTo(17);
    }];
    
    [resetPlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerImage.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.planDays.mas_left);
        make.right.mas_equalTo(self.resetPlan.mas_right);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
 
    
}

-(void)loadViewWithDataSource:(id)data
{
    
    
    self.data=data;
    self.planDays.text=[NSString stringWithFormat:@"健身计划已进入第%d天",[data[@"count"] intValue]];
    float targetCalorie=[data[@"targetCalorie"] floatValue];
    float consumeCalories=[data[@"consumeCalories"] floatValue];
    self.targetCost.text=[NSString stringWithFormat:@"目标%.0f千卡",targetCalorie];
    if (self.circleLayer) {
        [self.circleLayer removeFromSuperlayer];
    }

    
    // 异步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
  
       if ([[LAKALABraceletManager sharedInstance] isConnected])
      {
          
            [[LAKALABraceletManager sharedInstance]synchronizationInformation];
          
      }
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //手动添加的运动和手环的运动consumeCalories(后台已经累加)
            self.todayCost.text=[NSString stringWithFormat:@"%.0f",consumeCalories];
            CGFloat progress= consumeCalories/targetCalorie;
            self.circleLayer = [[WCGraintCircleLayer alloc] initGraintCircleWithBounds:CGRectMake(0, 0, self.bounds.size.height/2.0, self.bounds.size.height/2.0) Position:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0) FromColor:[UIColor greenColor] ToColor:[UIColor blueColor] LineWidth:10.0 ProgressWith:progress];
            [self.layer addSublayer:self.circleLayer];
        });
    });
    
  
}
-(void)resetFitnessPlan
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"重新开启新的健身计划，是否重置计划？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
            [UserServices
             resetFitnessPlanWithFitnessId:self.data[@"id"]
             completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
                 {
                     [UnityLHClass showHUDWithStringAndTime:@"重置计划成功"];
                     [self sendObject:@"reset"];
                     
                 }
                 else
                 {
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 }
             }];

        }
    }];
    
}
-(void)tapAction
{
    if ([[LAKALABraceletManager sharedInstance] isConnected])
    {
        RingViewController *ring=[[RingViewController alloc]init];
        ring.consumeCalories=[self.todayCost.text floatValue];//消耗卡路里
        [self.topViewController.navigationController pushViewController:ring animated:YES];
    }
    else
    {
        AddSportHistoryViewController *myhand=[[AddSportHistoryViewController alloc]init];
        myhand.data=self.data;
        [self.topViewController.navigationController pushViewController:myhand animated:YES];
    }
   }
@end
