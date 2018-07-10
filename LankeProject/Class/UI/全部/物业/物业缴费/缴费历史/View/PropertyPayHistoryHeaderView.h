//
//  PropertyPayHistoryHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "FullTimeView.h"
@interface PropertyPayHistoryHeaderView : UIView<LKCustomViewProtocol,FinishPickView>

@property (nonatomic ,strong) UILabel * categoryLabel;
@property (nonatomic ,strong) UIButton * startTimeButton;
@property (nonatomic ,strong) UIButton * endTimeButton;

@property (nonatomic ,copy) void (^bTypeHandle)();

@property (nonatomic ,copy) void (^bChooseStartHandle)();
@property (nonatomic ,copy) void (^bChooseEndHandle)();
@end
