//
//  LKFilterView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "GoodSearchItem.h"
@interface LKFilterView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) NSArray * priceFilter;

@property (nonatomic ,copy) void (^bCancelHandle)(LKFilterView * filter);
@property (nonatomic ,copy) void (^bConfirmHandle)(LKFilterView * filterView ,id data);
@property (nonatomic ,assign) BOOL isProShop;//是否为自营商店；
@property(nonatomic,strong)GoodSearchItem* searchItem;

@property (nonatomic,assign)BOOL isRight;//默认从上方弹出，YES从右侧弹出 (京东模块从右侧弹出)

#pragma mark -
#pragma mark Animaiton

- (void) showWithView:(UIView *)view onViewController:(UIViewController *)vc;
- (void) hide:(BOOL)animated;

@end
