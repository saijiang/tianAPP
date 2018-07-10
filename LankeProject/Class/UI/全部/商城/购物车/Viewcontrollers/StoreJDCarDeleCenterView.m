//
//  StoreJDCarDeleCenterView.m
//  LankeProject
//
//  Created by zhounan on 2018/5/24.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import "StoreJDCarDeleCenterView.h"

@implementation StoreJDCarDeleCenterView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
     self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.8];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _centerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,(DEF_SCREEN_WIDTH-40), 300)];
    _centerView.backgroundColor=BM_WHITE;
    _centerView.alpha=1.0;
    _centerView.center=self.center;
    _centerView.layer.cornerRadius=4;
     _centerView.layer.masksToBounds=YES;
    [self addSubview:_centerView];
    _titleLB=[UnityLHClass masonryLabel:@"提示" font:18 color:BM_BLACK];
    _titleLB.textAlignment=NSTextAlignmentCenter;
    [_centerView addSubview:_titleLB];
    
    _makeSure=[UnityLHClass masonryButton:@"知道" font:14 color:BM_WHITE];
    _makeSure.layer.masksToBounds=YES;
    _makeSure.layer.cornerRadius=4.0;
    [_centerView addSubview:_makeSure];
    _makeSure.backgroundColor=[UIColor colorWithHexString:@"#197AAE"];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.and.right.mas_equalTo(0);
    }];
    
    [_makeSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(_centerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
     _scrollView= [[UIScrollView alloc] init];
    [_centerView addSubview:_scrollView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO; //隐藏横向滚动条
    _scrollView.showsVerticalScrollIndicator = NO; //隐藏竖向滚动条
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLB.mas_bottom).mas_offset(20);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_makeSure.mas_top).mas_offset(-20);
        
    }];
    _centerLable=[UnityLHClass masonryLabel:@"" font:16 color:BM_BLACK];
    _centerLable.numberOfLines=0;
    [_scrollView addSubview:_centerLable];
    
    [_centerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_top);
        make.left.mas_offset(15);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH-70);
        make.bottom.mas_equalTo(_scrollView.mas_bottom);
        
    }];
    
}
-(void) loadViewWithData:(id)data
{
    _centerLable.text=[NSString stringWithFormat:@"以下商品由于库存不足，已被删除：%@",data];
    CGFloat height=[UnityLHClass getHeight:data wid:DEF_WIDTH(_centerLable) font:15];
    _scrollView.contentSize = CGSizeMake((DEF_SCREEN_WIDTH-40), height);

}
@end
