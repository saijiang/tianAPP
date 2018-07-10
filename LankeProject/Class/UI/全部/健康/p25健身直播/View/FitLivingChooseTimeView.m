//
//  FitLivingChooseTimeView.m
//  LankeProject
//
//  Created by itman on 2017/7/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitLivingChooseTimeView.h"

@interface FitLivingChooseTimeView ()

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UILabel *centerLab;
@property(nonatomic,strong)UIButton *rightBtn;



@property(nonatomic,assign)NSInteger currentWeek;

@end

@implementation FitLivingChooseTimeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.currentWeek=0;
        self.maxWeek=4;
        [self configView];
        [self configData];

    }
    return self;
}
#pragma mark -- 初始化选择条
-(void)configView
{
    
    self.toplineWithColor = BM_Color_LineColor;
    self.bottomlineWithColor = BM_Color_LineColor;

    
    _leftBtn = [UnityLHClass masonryButton:@"上周" imageStr:nil font:13.0 color:BM_Color_Blue];
    _leftBtn.layer.borderWidth = 1.0;
    _leftBtn.layer.borderColor = BM_Color_Blue.CGColor;
    _leftBtn.selected=YES;
//    _leftBtn.layer.borderColor = BM_Color_huiColor.CGColor;
    _leftBtn.layer.cornerRadius = 5.0;
    [_leftBtn setTitleColor:BM_Color_huiColor forState:UIControlStateNormal];
    [_leftBtn setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
    [self addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(currentWeekBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    _centerLab = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    _centerLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_centerLab];
    
    
    _rightBtn = [UnityLHClass masonryButton:@"下周" imageStr:nil font:13.0 color:BM_Color_Blue];
    _rightBtn.layer.borderWidth = 1.0;
    _rightBtn.layer.borderColor = BM_Color_Blue.CGColor;
    _rightBtn.layer.cornerRadius = 5.0;
    [_rightBtn setTitleColor:BM_Color_huiColor forState:UIControlStateNormal];
    [_rightBtn setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
    _rightBtn.selected=YES;
    [self addSubview:_rightBtn];
    [_rightBtn addTarget:self action:@selector(nextWeekBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}
#pragma mark -- 数据处理
- (void)configData
{
   
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    //
    NSDate * firstday = days.firstObject;
    firstday = [firstday dateByAddingTimeInterval: kWeekTimeInterval*self.currentWeek-kHourTimeInterval];
    self.startTime = [dateFormatter stringFromDate:firstday];
    
    NSDate * lastday = days.lastObject;
    lastday = [lastday dateByAddingTimeInterval: kWeekTimeInterval*self.currentWeek-kHourTimeInterval];
    self.endTime = [dateFormatter stringFromDate:lastday];
    
    NSString *time=[NSString stringWithFormat:@"%@-%@",[self.startTime stringByReplacingOccurrencesOfString:@"-" withString:@"."],[self.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
    _centerLab.text=time;
    
    [self sendObject:@"time"];
}


-(void)currentWeekBtnClick
{
    if (self.currentWeek>-self.maxWeek) {
        self.currentWeek--;
        [self setWeekButtonSeleted];
        [self configData];
    }else{
        
    }
   
}
-(void)nextWeekBtnClick
{
    if (self.currentWeek<self.maxWeek) {
        self.currentWeek++;
        [self setWeekButtonSeleted];
        [self configData];
    }else{
      
    }

} 

//设置本周button选中状态
-(void)setWeekButtonSeleted
{
    if (self.currentWeek==-4) {
        _leftBtn.selected=NO;
        _rightBtn.selected=YES;
        _leftBtn.layer.borderColor = BM_Color_huiColor.CGColor;
        _rightBtn.layer.borderColor = BM_Color_Blue.CGColor;
        
        
    }
  if (self.currentWeek>-4&&self.currentWeek<self.maxWeek) {
        _leftBtn.selected=YES;
        _rightBtn.selected=YES;
        _rightBtn.layer.borderColor = BM_Color_Blue.CGColor;
        _leftBtn.layer.borderColor = BM_Color_Blue.CGColor;
        
    }
     if (self.currentWeek==4){
        _leftBtn.selected=YES;
        _rightBtn.selected=NO;
        _rightBtn.layer.borderColor = BM_Color_huiColor.CGColor;
        _leftBtn.layer.borderColor = BM_Color_Blue.CGColor;
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    float width = DEF_SCREEN_WIDTH/3.0/2.0;
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(self.mas_left).offset(width);
    }];
    [_centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(self.mas_right).offset(-width);
    }];

}

@end
