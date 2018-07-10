//
//  GoodsDetailHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "LKStepView.h"

@interface GoodsDetailHeaderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,assign ,getter=isSelfSupport) BOOL selfSupport;

@property (nonatomic ,strong) LKStepView * stepView;
@property (nonatomic ,strong) NSString * isTypeShop;


- (NSInteger) currentGoodsCount;

- (void) configForStoreOneWith:(id)data;
- (void) configForStoreJDWith:(id)data;


@end
