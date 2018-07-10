//
//  GroupBuyDetailHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface GroupBuyDetailHeaderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bReachMaxValueHandle)(NSInteger maxValue);
@property (nonatomic ,copy) void (^bHeightChangeHandle)(CGFloat height);

- (NSInteger) currentGoodsCount;

@end
