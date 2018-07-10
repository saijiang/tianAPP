//
//  PersonCenterOrderStateView.h
//  LankeProject
//
//  Created by 孟德初 on 2018/6/15.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterOrderStateView : UIView

@property (strong,nonatomic) NSArray *stateName;//展示名（必须设置）
@property (assign,nonatomic) NSInteger maxDisplayCount;//最大展示数（必须设置）
@property (assign,nonatomic) NSInteger buttonWidth;//按钮宽（必须设置）
@property(copy,nonatomic) void(^stateBlock)();

@end
