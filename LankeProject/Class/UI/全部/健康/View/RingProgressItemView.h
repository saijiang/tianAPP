//
//  RingProgressItemView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface RingProgressItemView : UIView<LKCustomViewProtocol>
@property (nonatomic ,strong) UILabel * valueLabel;
@property (nonatomic ,strong) UILabel * unitLabel;

@property(nonatomic ,assign) float progress;

@end
