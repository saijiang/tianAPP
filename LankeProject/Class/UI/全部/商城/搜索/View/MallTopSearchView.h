//
//  MallSearchView.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"

@interface MallTopSearchView : UIView

@property(nonatomic,strong)SearchView *search;
@property(nonatomic,strong)UIButton *leftButton;
/** 0 is 商品  \n  1 is 店铺 */
@property(nonatomic,assign)NSInteger leftButtonIndex;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@property (nonatomic ,copy) void (^bChangeFilterOptionHandle)(NSInteger index);
@end
