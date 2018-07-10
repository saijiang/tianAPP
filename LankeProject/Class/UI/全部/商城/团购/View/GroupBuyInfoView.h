//
//  GroupBuyInfoView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "LKStepView.h"

@interface GroupBuyInfoView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) LKStepView * stepView;

@property (nonatomic ,copy) void (^bHeightChangeHandle)(CGFloat);
@end
