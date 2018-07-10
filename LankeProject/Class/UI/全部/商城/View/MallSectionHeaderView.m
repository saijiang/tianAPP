//
//  MallSectionHeaderView.m
//  LankeProject
//
//  Created by itman on 17/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSectionHeaderView.h"

@interface MallSectionHeaderView ()

@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UIImageView *rightImage;
@property(nonatomic,strong)UIButton *moreAll;
@end

@implementation MallSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        self.scanAll= [UnityLHClass masonryButton:@"推荐商品" font:15.0 color:BM_BLACK];
        [self addSubview:self.scanAll];
        [self.scanAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIImageView *leftImage=[[UIImageView alloc]init];
        leftImage.image=[UIImage imageNamed:@"Mall_biaotibg"];
        [self addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.scanAll.mas_left).offset(-3);
            make.centerY.mas_equalTo(self.scanAll.mas_centerY);
        }];
        self.leftImage=leftImage;
        
        UIImageView *rightImage=[[UIImageView alloc]init];
        rightImage.image=[UIImage imageNamed:@"Mall_biaotibg"];
        rightImage.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scanAll.mas_right).offset(3);
            make.centerY.mas_equalTo(self.scanAll.mas_centerY);
        }];
        self.rightImage=rightImage;

        UIButton *moreAll=[UnityLHClass masonryButton:@"更多分类" imageStr:@"Mall_bluemore" font:13.0 color:BM_Color_Blue];
        [moreAll layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        [self addSubview:moreAll];
        self.moreAll=moreAll;
        [moreAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [moreAll handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"more"];
        }];
    }
    return self;
}
-(void)loadMallforIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        //[self.moreAll setImage:[UIImage imageNamed:@"Mall_redmore"] forState:UIControlStateNormal];
        //[self.moreAll setTitleColor:[UIColor colorWithRed:1.00 green:0.42 blue:0.36 alpha:1.00] /forState:UIControlStateNormal];
        //[self.moreAll setTitle:@"更多分类" forState:UIControlStateNormal];
        //self.leftImage.image=[UIImage imageNamed:@"Mall_redline"];
        //self.rightImage.image=[UIImage imageNamed:@"Mall_redlinetwo"];
       // [self loadMallSectionHeaderViewTitleWithDataSource:@"商品分类 "];
        //[self.scanAll setTitleColor:[UIColor colorWithRed:1.00 green:0.42 blue:0.36 alpha:1.00] forState:UIControlStateNormal];
        
        [self.moreAll setImage:[UIImage imageNamed:@"Mall_bluemore"] forState:UIControlStateNormal];
        [self.moreAll setTitleColor:BM_Color_Blue  forState:UIControlStateNormal];
        [self.moreAll setTitle:@"更多团购" forState:UIControlStateNormal];
        self.leftImage.image=[UIImage imageNamed:@"Mall_blueline"];
        self.rightImage.image=[UIImage imageNamed:@"Mall_bluelinetwo"];
        [self loadMallSectionHeaderViewTitleWithDataSource:@"商品团购 "];
        [self.scanAll setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    }
    else if (indexPath.section==2)
    {
        //[self.moreAll setImage:[UIImage imageNamed:@"Mall_bluemore"] forState:UIControlStateNormal];
        //[self.moreAll setTitleColor:BM_Color_Blue  forState:UIControlStateNormal];
        //[self.moreAll setTitle:@"更多团购" forState:UIControlStateNormal];
        //self.leftImage.image=[UIImage imageNamed:@"Mall_blueline"];
        //self.rightImage.image=[UIImage imageNamed:@"Mall_bluelinetwo"];
       // [self loadMallSectionHeaderViewTitleWithDataSource:@"商品团购 "];
       // [self.scanAll setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
        
        
        [self.moreAll setImage:[UIImage imageNamed:@"Mall_redmore"] forState:UIControlStateNormal];
        [self.moreAll setTitleColor:[UIColor colorWithRed:1.00 green:0.42 blue:0.36 alpha:1.00] forState:UIControlStateNormal];
        [self.moreAll setTitle:@"更多分类" forState:UIControlStateNormal];
        self.leftImage.image=[UIImage imageNamed:@"Mall_redline"];
        self.rightImage.image=[UIImage imageNamed:@"Mall_redlinetwo"];
        [self loadMallSectionHeaderViewTitleWithDataSource:@"商品分类 "];
        [self.scanAll setTitleColor:[UIColor colorWithRed:1.00 green:0.42 blue:0.36 alpha:1.00] forState:UIControlStateNormal];
    }
    else if (indexPath.section==3)
    {
        [self.moreAll setImage:[UIImage imageNamed:@"Mall_zisemore"] forState:UIControlStateNormal];
        [self.moreAll setTitleColor:[UIColor colorWithRed:0.83 green:0.70 blue:0.91 alpha:1.00]  forState:UIControlStateNormal];
        [self.moreAll setTitle:@"更多商品" forState:UIControlStateNormal];
        self.leftImage.image=[UIImage imageNamed:@"Mall_ziseline"];
        self.rightImage.image=[UIImage imageNamed:@"Mall_ziselinetwo"];
        [self loadMallSectionHeaderViewTitleWithDataSource:@"推荐商品"];
        [self.scanAll setTitleColor:[UIColor colorWithRed:0.83 green:0.70 blue:0.91 alpha:1.00] forState:UIControlStateNormal];

    }
}

-(void)loadMallSectionHeaderViewTitleWithDataSource:(NSString *)title
{
    [self.scanAll setTitle:title forState:UIControlStateNormal];

}
-(void)loadSectionWithTitle:(NSString *)title
{
    self.backgroundColor=BM_WHITE;
    self.moreAll.hidden=YES;
    self.leftImage.hidden=YES;
    self.rightImage.hidden=YES;
    self.leftImage.image=[UIImage imageNamed:@"Mall_blueline"];
    self.rightImage.image=[UIImage imageNamed:@"Mall_blueline"];
    [self loadMallSectionHeaderViewTitleWithDataSource:title];
    [self.scanAll setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
}
@end
