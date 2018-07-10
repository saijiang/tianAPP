//
//  MallSearchView.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//


#import "MallTopSearchView.h"

@interface MallTopSearchView ()

@property(nonatomic,strong)NSArray *dropArray;

@end

@implementation MallTopSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.dropArray=@[@"商品",@"店铺"];
        self.leftButtonIndex=0;
        self.leftButton=[UnityLHClass masonryButton:self.dropArray[self.leftButtonIndex] imageStr:@"Mall_jiantou" font:15.0 color:BM_BLACK];
        [self.leftButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"Mall_kuang"] forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.search=[[SearchView alloc]init];
        self.search.searchFD.placeholder=@"查询自营商品";
//        self.search.searchFD.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.search];
        [self.search receiveObject:^(id object) {
            [self sendObject:object];
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(60);
        }];
        
        [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(self.leftButton.mas_right).offset(10);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(self.mas_height);
        }];
//        [self.search.searchFD mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.search);
//            make.right.mas_equalTo(-20);
//            make.left.mas_equalTo(10);
//            
//        }];
        
    }
    return self;
}

-(void)leftButtonAction:(UIButton *)button
{

    DropDownView *drop=[[DropDownView alloc]initWithFrame:CGRectZero];
    drop.hasCheckImage = NO;
    [drop resetWithSourceArray:self.dropArray];
    [drop setSelectedAtIndex:self.leftButtonIndex];
    [drop showWithRect:CGRectMake(0,64, DEF_SCREEN_WIDTH, self.dropArray.count*50)
     andEndChooseBlock:^(id data, NSInteger row) {
         
         if (self.leftButtonIndex != row) {
             
             self.search.searchFD.text = @"";
         }
         self.leftButtonIndex=row;
         [self.leftButton setTitle:self.dropArray[row] forState:UIControlStateNormal];
         if (self.bChangeFilterOptionHandle) {
             self.bChangeFilterOptionHandle(row);
         }
     }];
}

-(void)setLeftButtonIndex:(NSInteger)leftButtonIndex
{
    _leftButtonIndex=leftButtonIndex;
    [self.leftButton setTitle:self.dropArray[_leftButtonIndex] forState:UIControlStateNormal];

}

@end
