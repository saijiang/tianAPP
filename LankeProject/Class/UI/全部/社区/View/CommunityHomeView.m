//
//  CommunityHomeView.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHomeView.h"

@interface CommunityHomeView ()
{
    UIView *topView;
}

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *classification;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong) id data;

@end

@implementation CommunityHomeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self createView];
    }
    return self;
}

-(void)createView
{
    
    self.name=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [self addSubview:self.name];
    
    topView=[[UIView alloc]init];
    [self addSubview:topView];
    topView.layer.masksToBounds=YES;
    topView.layer.cornerRadius=5;
    topView.layer.borderWidth = 1.0;
    topView.layer.borderColor =[UIColor colorWithWhite:0 alpha:0.05].CGColor;
  

    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.name.mas_top);
    }];
    
    self.classification=[UnityLHClass masonryLabel:@"" font:13.0 color:BM_Color_Blue];
    [self addSubview:self.classification];
    
    
    self.num=[UnityLHClass masonryLabel:@"" font:13.0 color:BM_Color_GrayColor];
    [self addSubview:self.num];
    
    self.icon=[[UIImageView alloc]init];
    self.icon.userInteractionEnabled=YES;
    self.icon.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:self.icon];
    //self.icon.image=[UIImage imageNamed:@"Community_pic"];
    
    [self.classification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom);
        make.bottom.mas_equalTo(topView.mas_bottom);
        make.left.mas_equalTo(topView.mas_left).offset(5);
        make.height.mas_equalTo(25);
    }];
    
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.classification.mas_centerY);
        make.right.mas_equalTo(topView.mas_right).offset(-5);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top);
        make.bottom.mas_equalTo(self.classification.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(topView.mas_width);
    }];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    self.hidden=YES;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(void)tap
{
    [self sendObject:self.data];
}
-(void)loadViewWithDataSource:(id)dataSource
{
    
    if (!dataSource) {
        self.hidden=YES;
        return;
    }
    self.data=dataSource;
    self.hidden=NO;
    self.name.text=dataSource[@"associationTitle"];
    self.num.text=[NSString stringWithFormat:@"%@人",dataSource[@"userCount"]];
    self.classification.text=dataSource[@"className"];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"associationImage"]]];
}

@end
