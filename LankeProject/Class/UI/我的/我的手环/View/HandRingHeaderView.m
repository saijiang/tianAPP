//
//  HandRingHeaderView.m
//  LankeProject
//
//  Created by itman on 17/4/1.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HandRingHeaderView.h"
#import "CircleProgressView.h"
#import "LAKALABraceletManager.h"

@interface HandRingHeaderView()

@property(nonatomic,strong)CircleProgressView *progress;
@property(nonatomic,strong)UILabel *electricity;
@property(nonatomic,strong)id data;

@end

@implementation HandRingHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_Color_Blue;
        self.progress=[[CircleProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height-50, frame.size.height-50)];
        self.progress.center=self.center;
        self.progress.progressColor=[UIColor whiteColor];
        self.progress.progressBackgroundColor=[UIColor groupTableViewBackgroundColor];
        self.progress.progressWidth=3.0;
        self.progress.percent=0.5;
        self.progress.backgroundColor=BM_CLEAR;
        self.progress.centerLabel.text=@"绑定手环";
        self.progress.textFont=[UIFont systemFontOfSize:22];
        self.progress.textColor=BM_WHITE;
        [self addSubview:self.progress];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        self.electricity=[UnityLHClass masonryLabel:@"剩余电量" font:15.0 color:BM_WHITE];
        [self addSubview:self.electricity];
        self.electricity.hidden=YES;
        

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.electricity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_centerY).offset(20);
    }];
}

-(void)tapAction
{
    [self sendObject:@"搜索设备"];
}

-(void)loadViewWithDataSource:(LAKALABleDeviceInfo*)data
{
    self.data=data;
    if (data)
    {
        self.progress.percent=data.powerLevel/100.0;
        NSString *battery=[NSString stringWithFormat:@"%d",data.powerLevel];
        battery=[battery stringByAppendingString:@"%"];
        self.progress.centerLabel.text=battery;
        self.electricity.hidden=NO;
    }
    else
    {
        self.progress.percent=0;
        self.progress.centerLabel.text=@"绑定手环";
        self.electricity.hidden=YES;


    }
  

}

@end
