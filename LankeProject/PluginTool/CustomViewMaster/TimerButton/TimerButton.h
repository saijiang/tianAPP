//
//  TimerButton.h
//  BMProject
//
//  Created by itman on 16/1/8.
//  Copyright (c) 2016年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerButton : UIButton
{
    // 定时刷新
    dispatch_source_t timer;
    NSInteger count;
}

@property(nonatomic,assign)NSInteger time;
-(void)startTimer;
-(void)endTimer;

@end
