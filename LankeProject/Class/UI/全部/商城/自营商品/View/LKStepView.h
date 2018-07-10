//
//  LKStepView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface LKStepView : UIView<LKCustomViewProtocol>

//传入的value
@property (nonatomic ,assign) NSInteger value;

// default is 0
@property (nonatomic ,assign) NSInteger minValue;
// default is 100
@property (nonatomic ,assign) NSInteger maxValue;

// add value
@property (nonatomic ,strong) UIButton * valueButton;

@property (nonatomic ,copy) void (^bStepValueChangeHandle)(NSInteger value, BOOL puls);

@property (nonatomic ,copy) void (^bReachMinValueHandle)(NSInteger minValue);
@property (nonatomic ,copy) void (^bReachMaxValueHandle)(NSInteger maxValue);
@end
