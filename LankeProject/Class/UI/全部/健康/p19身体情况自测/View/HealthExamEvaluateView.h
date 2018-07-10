//
//  HealthExamEvaluateView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface HealthExamEvaluateView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bFoldButtonHandle)(BOOL isFold);
@end
