//
//  HLLValuationBottomView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLValuationBottomView : UIView

@property (nonatomic ,strong) UIButton * shoppingCartButton;
@property (nonatomic ,strong) UIButton * settleAccountsButton;
@property (nonatomic ,strong) UILabel * priceLabel;
@property (nonatomic ,strong) UILabel * countLabel;
@property (nonatomic ,strong) UILabel * couponLabel;

@property (nonatomic ,assign) CGFloat price;

@property (nonatomic ,strong) UIView * whiteViewForMargin;

@property (nonatomic ,copy) void (^bSettleAccountsHandle)();
@property (nonatomic ,copy) void (^bShoppingCarHandle)();

- (void) updateValuationBottomViewWithData:(id)data;

/** 有一个界面不需要显示购物车图标 */
- (void) updateBottomViewForHideShopingView;
@end
