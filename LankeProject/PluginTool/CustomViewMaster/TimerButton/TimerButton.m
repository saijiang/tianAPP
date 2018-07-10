//
//  TimerButton.m
//  BMProject
//
//  Created by itman on 16/1/8.
//  Copyright (c) 2016年 MengHuan. All rights reserved.
//

#import "TimerButton.h"

@interface TimerButton ()

@property (nonatomic ,strong) UIColor * normalTitleColor;

@end
@implementation TimerButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_CLEAR;
        [self createTimer];
    }
    return self;
}
-(void)createTimer
{
    //  创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 时间
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    //每秒执行
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.00*NSEC_PER_SEC, 0);
    
    // 开始计时
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //设置界面的按钮显示 根据自己需求设置
            [self doSomethingPerSeconds];
        });
    });
}


-(void)setTime:(NSInteger)time
{
    if (time)
    {
        _time=time;
        count=time;
    }
}
-(void)doSomethingPerSeconds
{
    self.backgroundColor=BM_CLEAR;
    self.userInteractionEnabled=NO;
    if (count>0)
    {
        count--;
        self.titleLabel.adjustsFontSizeToFitWidth=YES;
        [self setTitle:[NSString stringWithFormat:@"%lds",(long)count] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00] forState:UIControlStateNormal];
    }
    else
    {
        [self endTimer];
        count=self.time ;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.backgroundColor=BM_CLEAR;
        [self setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        self.userInteractionEnabled=YES;
    }
    
    
}

-(void)startTimer
{
    if (timer)
    {
        dispatch_resume(timer);
    }
    self.normalTitleColor = self.titleLabel.textColor;
}
-(void)endTimer
{
    if (timer)
    {
        dispatch_suspend(timer);
    }

}

@end
