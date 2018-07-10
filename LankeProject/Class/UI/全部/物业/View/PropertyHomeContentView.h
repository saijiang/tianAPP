//
//  PropertyHomeContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface PropertyHomeContentView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bSelectItemHandle)(NSInteger index);
@end
