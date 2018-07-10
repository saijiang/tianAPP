//
//  DailyFitnessPickDateView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface DailyFitnessPickDateView : UIView<LKCustomViewProtocol>
@property (nonatomic ,strong) UILabel * dateLabel;
@property (nonatomic ,strong) LocalhostImageView * iconImageView;

@property (nonatomic ,copy) void (^bChooseDateHandle)();
@end
