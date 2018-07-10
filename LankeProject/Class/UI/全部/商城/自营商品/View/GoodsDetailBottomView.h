//
//  GoodsDetailBottomView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface GoodsDetailBottomView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) UIButton * addToShopCartButton;
@property (nonatomic ,strong) UIButton * ImmediatelyBuyButton;

@property (nonatomic ,copy) void (^bAddToShopCartHandle)();
@property (nonatomic ,copy) void (^bImmediatelyBuyHandle)();

- (void) enableButton:(BOOL)enable;
@end
