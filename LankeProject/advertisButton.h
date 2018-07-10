//
//  advertisButton.h
//  LankeProject
//
//  Created by admin on 2017/7/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface advertisButton : UIButton
{
    // 定时刷新
    dispatch_source_t timer;
    NSInteger count;
}

@property(nonatomic,assign)NSInteger time;
-(void)startTimer;
-(void)endTimer;
@end
