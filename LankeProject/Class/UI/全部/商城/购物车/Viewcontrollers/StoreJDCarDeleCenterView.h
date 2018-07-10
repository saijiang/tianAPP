//
//  StoreJDCarDeleCenterView.h
//  LankeProject
//
//  Created by zhounan on 2018/5/24.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreJDCarDeleCenterView : UIView
@property(nonatomic,strong)UIView*centerView;

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIButton *makeSure;
@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UILabel*centerLable;
-(void) loadViewWithData:(id)data;

@end
