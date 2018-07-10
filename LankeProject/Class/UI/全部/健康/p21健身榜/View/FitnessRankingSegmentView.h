//
//  FitnessRankingSegmentView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface FitnessRankingSegmentView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bSwitchOptionHandle)(NSInteger index);
@property (nonatomic ,strong) NSString * segmentType;
@end
