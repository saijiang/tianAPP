//
//  FitnessRankingHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface FitnessRankingHeaderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bShareMineRankingHandle)();
@property (nonatomic ,copy) void (^bZanMySelfHandle)();//??
@end
