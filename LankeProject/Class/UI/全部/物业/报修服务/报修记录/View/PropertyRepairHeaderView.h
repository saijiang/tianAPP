//
//  PropertyRepairHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface PropertyRepairHeaderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bSwitchOptionHandle)(NSInteger index);

@property (nonatomic ,strong) NSString * segmentType;
@end
