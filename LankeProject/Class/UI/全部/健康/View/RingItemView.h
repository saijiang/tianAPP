//
//  RingItemView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface RingItemView : UIView<LKCustomViewProtocol>
@property (nonatomic ,strong) UILabel * contentLabel;

+ (instancetype)Distance;
+ (instancetype)SleepTime;
+ (instancetype)SportTime;
+ (instancetype)DeepSleepTime;
+ (instancetype)Calorie;
+ (instancetype)ShallowSleepTime;
+ (instancetype)HeartbeatRate;
@end
