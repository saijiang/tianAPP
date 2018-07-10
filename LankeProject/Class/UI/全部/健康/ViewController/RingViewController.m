//
//  RingViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "RingViewController.h"
#import "RingItemView.h"
#import "RingProgressItemView.h"
#import "LAKALABraceletManager.h"
#import "MyHandRingViewController.h"
@interface RingViewController ()

@property (nonatomic ,strong) UILabel * timeLabel;
@property (nonatomic ,strong) UIButton * sportButton;
@property (nonatomic ,strong) UIButton * sleepButton;

@property (nonatomic ,strong) LocalhostImageView * backgroundImageView;

@property (nonatomic ,strong) RingProgressItemView * footProgressView;
@property (nonatomic ,strong) RingProgressItemView * sleepProgressView;

@property (nonatomic ,strong) RingItemView * distanceView;
@property (nonatomic ,strong) RingItemView * sleepTimeView;
@property (nonatomic ,strong) RingItemView * sportTimeView;
@property (nonatomic ,strong) RingItemView * deepSleepTimeView;
@property (nonatomic ,strong) RingItemView * calorieView;
@property (nonatomic ,strong) RingItemView * shallowSleepTimeView;
@property (nonatomic ,strong) RingItemView * HeartbeatRateView;
@property (nonatomic ,strong) NSArray * itemViews;
@property (nonatomic ,strong) NSString * walkStepNum;
@property (nonatomic ,strong) NSString * heartNum;
@end

@implementation RingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的手环";
    [self reloadViewWithDataSource];
    [self postHeaterAndSheep];
    
}
-(void)postHeaterAndSheep
{
    [UserServices gaddInfoWithUserId:[KeychainManager readUserId] stepNum:self.walkStepNum heartRate: self.heartNum completionBlock:^(int result, id responseObject) {
        if (result==0)
        {
          
            
        }
        else
        {
            //[UnityLHClass showAlertView:responseObject[@"msg"]];
        }
    }];
}
-(void)reloadViewWithDataSource
{
    [self viewDidLayoutWithLKLType];
    [SVProgressHUD showWithStatus:@"正在获取手环数据"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    // 异步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 回到主线程
        LAKALARecordParams *params= [[LAKALABraceletManager sharedInstance] getRecordParams];
//        [[LAKALABraceletManager sharedInstance]synchronizationInformation];
        dispatch_async(dispatch_get_main_queue(), ^{
            int sleepTime=params.deepSleepTime;
            //            深度睡眠： 大于2小时 良好 进度条为100
            //            大于等于1小时小于等于2小时   适宜  进度条80
            //            剩下的   较差  进度条60
            NSString *status=@"良好";
            if (sleepTime>120)
            {
                status=@"良好";
                self.sleepProgressView.progress=1.0;
                
            }
            else if (sleepTime>=60)
            {
                status=@"适宜";
                self.sleepProgressView.progress=0.8;
                
            }
            else
            {
                status=@"较差";
                self.sleepProgressView.progress=0.6;
                
            }
            
            self.sleepProgressView.valueLabel.text = status;
            self.footProgressView.valueLabel.text =[NSString stringWithFormat:@"%d",params.sportStepNum];
            self.footProgressView.progress=params.sportStepNum/10000.0;
            self.distanceView.contentLabel.text=[NSString stringWithFormat:@"%.1f公里",params.sportStepLenght/1000.0];
            self.walkStepNum= [NSString stringWithFormat:@"%d",params.walkStepNum] ;
            self.sportTimeView.contentLabel.text=[NSString stringWithFormat:@"%d小时%d分钟",params.sportTime/60,params.sportTime%60];
            self.sleepTimeView.contentLabel.text =[NSString stringWithFormat:@"%d小时%d分钟",(params.latentSleepTime+params.deepSleepTime)/60,(params.latentSleepTime+params.deepSleepTime)%60] ;
            self.deepSleepTimeView.contentLabel.text =[NSString stringWithFormat:@"%d小时%d分钟",(params.deepSleepTime)/60,(params.deepSleepTime)%60];
            self.shallowSleepTimeView.contentLabel.text =[NSString stringWithFormat:@"%d小时%d分钟",(params.latentSleepTime)/60,(params.latentSleepTime)%60];
            self.calorieView.contentLabel.text = [NSString stringWithFormat:@"%.0f千卡",self.consumeCalories];
            self.HeartbeatRateView.contentLabel.text=[NSString stringWithFormat:@"%d次/分",params.heartNum];
            self.heartNum=[NSString stringWithFormat:@"%d次/分",params.heartNum];
           [self postHeaterAndSheep];
            double delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                view.alpha = 0;
                [SVProgressHUD dismiss];
            });
          

        });
    });
    
}

- (void)createUI
{

    self.backgroundImageView = [[LocalhostImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.image = [UIImage imageNamed:@"health_ring_bg"];
    [self addSubview:self.backgroundImageView];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy.MM.dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    self.timeLabel = [UnityLHClass masonryLabel:[NSString stringWithFormat:@"今天 %@",locationString] font:18 color:[UIColor blackColor]];
    [self addSubview:self.timeLabel];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.sportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sportButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    self.sportButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sportButton setTitle:@"运动" forState:UIControlStateNormal];
    [self.sportButton setBackgroundImage:[UIImage imageNamed:@"health_ring_yundong"] forState:UIControlStateNormal];
    [self addSubview:self.sportButton];
    
    self.sleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sleepButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    self.sleepButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sleepButton setBackgroundImage:[UIImage imageNamed:@"health_ring_shuimian"] forState:UIControlStateNormal];
    [self.sleepButton setTitle:@"睡眠" forState:UIControlStateNormal];
    [self addSubview:self.sleepButton];
    
    self.footProgressView = [RingProgressItemView view];
    self.footProgressView.valueLabel.text = @"00";
    self.footProgressView.unitLabel.text = @"步";
    self.sleepProgressView = [RingProgressItemView view];
    self.sleepProgressView.valueLabel.text = @"";
    self.sleepProgressView.unitLabel.text = @"";
    [self addSubview:self.footProgressView];
    [self addSubview:self.sleepProgressView];
    
    self.distanceView = [RingItemView Distance];
    self.sleepTimeView = [RingItemView SleepTime];
    self.sportTimeView = [RingItemView SportTime];
    self.deepSleepTimeView = [RingItemView DeepSleepTime];
    self.calorieView = [RingItemView Calorie];
    self.shallowSleepTimeView = [RingItemView ShallowSleepTime];
    self.HeartbeatRateView = [RingItemView HeartbeatRate];
    self.itemViews = @[self.distanceView,self.sleepTimeView,self.sportTimeView,self.deepSleepTimeView,self.calorieView,self.shallowSleepTimeView,self.HeartbeatRateView];
    for (UIView * view in self.itemViews) {
        [self addSubview:view];
    }
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(20);
    }];

}

- (void)viewDidLayoutWithLKLType
{

    LKLBraceletType type= [[LAKALABraceletManager sharedInstance] getDeviceType];
    CGFloat itemViewWidth = DEF_SCREEN_WIDTH / 2;
    CGFloat itemViewHeight = 120;
    if (type==LKLBraceletTypeB2)
    {
        itemViewWidth = DEF_SCREEN_WIDTH;

    }
  
    [self.sportButton mas_remakeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(self.footProgressView.mas_centerX);
    }];
    [self.sleepButton mas_remakeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.sportButton.mas_top);
        make.centerX.mas_equalTo(self.sleepProgressView.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(self.sportButton.mas_height);
    }];
    
    [self.footProgressView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.sportButton.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(itemViewWidth);
        make.height.mas_equalTo(150);
    }];
    
    [self.sleepProgressView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.footProgressView.mas_right);
        make.top.mas_equalTo(self.footProgressView.mas_top);
        make.width.mas_equalTo(self.footProgressView.mas_width);
        make.height.mas_equalTo(self.footProgressView.mas_height);
    }];
    
    NSInteger index = 0;
    for (UIView * view in self.itemViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(itemViewWidth * (index % 2));
            make.top.mas_equalTo(self.footProgressView.mas_bottom).mas_offset(0 + itemViewHeight * (index / 2));
            make.size.mas_equalTo(CGSizeMake(itemViewWidth,itemViewHeight));
            if (index >= self.itemViews.count - 2) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-100);
            }
        }];
        index ++;
    }
}


@end
