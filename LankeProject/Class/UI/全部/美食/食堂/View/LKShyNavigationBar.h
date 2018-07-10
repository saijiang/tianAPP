//
//  LKShyNavigationBar.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKShyNavigationBar : UIView

@property (nonatomic ,assign) BOOL hasRightButton;// default is NO

@property (nonatomic ,assign) CGFloat offset;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,copy) void (^bBackButtonHandle)();
@property (nonatomic ,copy) void (^bRightButtonHandle)();

@property (nonatomic ,strong) UIButton * backButton;
@property (nonatomic ,strong) UIButton * rightButton;

// 购物车中的商品数量
@property (nonatomic ,assign) NSInteger cartCount;

- (void) shyNavigationBarStatus:(BOOL)hide animation:(BOOL)animation;

- (void) linearShyNavigationBarWithOffset:(CGFloat)offset;

- (void) cleanBackButtonImage;
@end
