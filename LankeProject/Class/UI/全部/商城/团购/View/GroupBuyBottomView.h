//
//  GroupBuyBottomView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface GroupBuyBottomView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bRushHandle)();
@end
