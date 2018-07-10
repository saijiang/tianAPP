//
//  PersonCenterOrderView.m
//  LankeProject
//
//  Created by itman on 17/2/22.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PersonCenterOrderView.h"
#import "MyGoodsOrderViewController.h"
#import "MyFoodOrderViewController.h"
#import "MyGoodsOrderViewController.h"
#import "GroupOrderListViewController.h"
#import "OneNumberShopOrderViewController.h"
#import "JDShopOrderViewController.h"

@implementation PersonCenterOrderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
       // UIButton *leftBtn = [[UIButton alloc] init];
        //[leftBtn setTitle:@"1号店订单" forState:UIControlStateNormal];
        //leftBtn.titleLabel.font = BM_FONTSIZE(14.0);
       // [leftBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
       // [leftBtn setBackgroundColor: BM_CLEAR];
       // [self addSubview:leftBtn];
        
         UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setTitle:@"京东订单" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = BM_FONTSIZE(14.0);
         [leftBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [leftBtn setBackgroundColor: BM_CLEAR];
         [self addSubview:leftBtn];
        
        UIButton *centerBtn = [[UIButton alloc] init];
        [centerBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [centerBtn setTitle:@"购物订单" forState:UIControlStateNormal];
        centerBtn.titleLabel.font = BM_FONTSIZE(14.0);
        [centerBtn setBackgroundColor: BM_CLEAR];
        [self addSubview:centerBtn];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [rightBtn setTitle:@"美食订单" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = BM_FONTSIZE(14.0);
        [rightBtn setBackgroundColor: BM_CLEAR];
        [self addSubview:rightBtn];
        
        UIButton *groupBtn = [[UIButton alloc] init];
        [groupBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [groupBtn setTitle:@"团购订单" forState:UIControlStateNormal];
        groupBtn.titleLabel.font = BM_FONTSIZE(14.0);
        [groupBtn setBackgroundColor: BM_CLEAR];
        [self addSubview:groupBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(centerBtn.mas_width);
            make.height.offset(30);
        }];
        
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(rightBtn.mas_width);
            make.height.offset(30);
            make.left.mas_equalTo(leftBtn.mas_right).offset(1);

        }];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(groupBtn.mas_width);
            make.height.offset(30);
            make.left.mas_equalTo(centerBtn.mas_right).offset(1);
        }];
        
        [groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(rightBtn.mas_width);
            make.height.offset(30);
            make.left.mas_equalTo(rightBtn.mas_right).offset(1);
        }];
        
        //分割线
        UIImageView *line1 = [[UIImageView alloc] init];
        line1.backgroundColor = BM_WHITE;
        [self addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc] init];
        line2.backgroundColor = BM_WHITE;
        [self addSubview:line2];
        
        UIImageView *line3 = [[UIImageView alloc] init];
        line3.backgroundColor = BM_WHITE;
        [self addSubview:line3];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(centerBtn.mas_left);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.width.mas_equalTo(0.7);
            make.height.mas_equalTo(15);

        }];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(rightBtn.mas_left);
            make.centerY.mas_equalTo(centerBtn.mas_centerY);
            make.width.mas_equalTo(0.7);
            make.height.mas_equalTo(15);
         
          
        }];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(line2.mas_width);
            make.height.mas_equalTo(line2.mas_height);
            make.centerY.mas_equalTo(centerBtn.mas_centerY);
            make.left.mas_equalTo(groupBtn.mas_left);
        }];
        
        [leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(0)];
            [self leftButtonAction:leftBtn];
        }];
        [centerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(1)];
            [self centerButtonAction:centerBtn];

        }];
        [rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(2)];
            [self rightButtonAction:rightBtn];

        }];
        [groupBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(3)];
            [self groupButtonAction:groupBtn];

        }];

    }
    return self;
}
- (void)leftButtonAction:(UIButton *)sender
{
    
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
//        OneNumberShopOrderViewController *oneNumberShopOrder = [[OneNumberShopOrderViewController alloc] init];
//        [self.topViewController.navigationController pushViewController:oneNumberShopOrder animated:YES];
        
        JDShopOrderViewController *oneNumberShopOrder = [[JDShopOrderViewController alloc] init];
        [self.topViewController.navigationController pushViewController:oneNumberShopOrder animated:YES];
    }];
    
    
}

- (void)centerButtonAction:(UIButton *)sender
{
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
        MyGoodsOrderViewController *order=[[MyGoodsOrderViewController alloc]init];
        [self.topViewController.navigationController pushViewController:order animated:YES];
        
    }];
    
}

- (void)rightButtonAction:(UIButton *)sender
{
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
        MyFoodOrderViewController * foodOrder = [[MyFoodOrderViewController alloc] init];
        [self.topViewController.navigationController pushViewController:foodOrder animated:YES];
    }];
}

- (void)groupButtonAction:(UIButton *)sender
{
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
        GroupOrderListViewController *groupOrderList=[[GroupOrderListViewController alloc]init];
        [self.topViewController.navigationController pushViewController:groupOrderList animated:YES];
    }];
}

@end
