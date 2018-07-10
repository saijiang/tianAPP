//
//  FitLivingChooseTimeView.h
//  LankeProject
//
//  Created by itman on 2017/7/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitLivingChooseTimeView : UIView

@property(nonatomic,assign)NSInteger maxWeek;//设置最大日期 0 1 2 3

@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;

@end
