//
//  HealthExamBaseInfoView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRRulerControl.h"
#import "LKCustomViewProtocol.h"

@class HealthBaseInfo;
@interface HealthExamBaseInfoView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) HealthBaseInfo * baseInfo;

@end


@interface HealthBaseInfo : NSObject

@property (nonatomic ,assign) CGFloat minUnit;// 最小单位

@property (nonatomic ,assign) CGFloat minValue;
@property (nonatomic ,assign) CGFloat maxValue;
@property (nonatomic ,assign) CGFloat currentValue;

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * unit;

+ (instancetype) infoWithName:(NSString *)name unit:(NSString *)unit valur:(NSInteger)value;
@end
