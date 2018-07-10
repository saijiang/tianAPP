//
//  ClearingCarBottomView.h
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearingCarBottomView : UIView

//block
@property (nonatomic,copy) void (^CShoppingCarClearHandle)();
@property (nonatomic,copy) void (^CShoppingCarDeleteHandle)();
@property (nonatomic,copy) void (^CShoppingCarChooseAllHandle)(BOOL isSelected);

//全选按钮
@property (nonatomic, strong) UIButton *allChooseBtn;

//全选文字
@property (nonatomic, strong) UILabel *titleLB;

//删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

//总价
@property (nonatomic, strong) UILabel *priceTitle;

//数据
@property (nonatomic, strong) UILabel *priceValue;

//结算按钮
@property (nonatomic, strong) UIButton *goClearBtn;

- (void) disEnable:(BOOL)disEnable;

@end
