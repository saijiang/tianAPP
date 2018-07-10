//
//  CommunityDetailHeaderView.m
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityDetailHeaderView.h"

@interface CommunityDetailHeaderView ()

@property(nonatomic,strong)NetworkImageView *icon;

@property(nonatomic,strong)UILabel *status;

@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *contact;
@property(nonatomic,strong)UILabel *phone;


@end

@implementation CommunityDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        [self createView];
    }
    return self;
}
-(void)createView
{
    self.icon=[[NetworkImageView alloc]init];
    self.icon.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.icon.image=[UIImage imageNamed:@"Community_pic"];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.and.top.and.right.mas_equalTo(0);
         make.height.mas_equalTo(self.mas_width).multipliedBy(0.5);
     }];
    
    self.title=[UnityLHClass masonryLabel:@"全民炫跑活动召集令" font:15.0 color:BM_BLACK];
    self.title.numberOfLines=0;
    [self addSubview:self.title];
   
    
    self.status=[UnityLHClass masonryLabel:@"报名中" font:13.0 color:BM_WHITE];
    self.status.textAlignment=NSTextAlignmentCenter;
    self.status.backgroundColor=[UIColor colorWithRed:0.96 green:0.73 blue:0.33 alpha:1.00];
    self.status.adjustsFontSizeToFitWidth=YES;
    self.status.layer.masksToBounds=YES;
    self.status.layer.cornerRadius=2;
    [self addSubview:self.status];
    [self.status mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.mas_equalTo(-15);
         make.centerY.mas_equalTo(self.title.mas_centerY);
         make.height.mas_equalTo(25);
         make.width.mas_equalTo(65);
     }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.mas_lessThanOrEqualTo(self.status.mas_left).offset(-10);
         make.left.mas_equalTo(15);
         make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(10);
     }];
    
    UIButton *time=[UnityLHClass masonryButton:@"活动时间：" imageStr:@"Community_shijian" font:13.0 color:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00]];
    [time layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self addSubview:time];
    self.time=[UnityLHClass masonryLabel:@"2017-03-15 10:00-20:00" font:13.0 color:BM_BLACK];
    [self addSubview:self.time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_left);
        make.top.mas_equalTo(self.title.mas_bottom).mas_offset(10);

    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(time.mas_right).offset(5);
        make.centerY.mas_equalTo(time.mas_centerY);
        
    }];
    
    UIButton *address=[UnityLHClass masonryButton:@"活动地点：" imageStr:@"Community_dingwei" font:13.0 color:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00]];
    [address layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self addSubview:address];
    self.address=[UnityLHClass masonryLabel:@"北京市海淀区南大街31号" font:13.0 color:BM_BLACK];
    [self addSubview:self.address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_left);
        make.top.mas_equalTo(time.mas_bottom).mas_offset(10);
        
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(address.mas_right).offset(5);
        make.centerY.mas_equalTo(address.mas_centerY);
        
    }];
    
    UIButton *contact=[UnityLHClass masonryButton:@"活动联系人：" imageStr:@"Community_user" font:13.0 color:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00]];
    [contact layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self addSubview:contact];
    self.contact=[UnityLHClass masonryLabel:@"张海燕" font:13.0 color:BM_BLACK];
    [self addSubview:self.contact];
    [contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_left);
        make.top.mas_equalTo(address.mas_bottom).mas_offset(10);
        
    }];
    [self.contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contact.mas_right).offset(5);
        make.centerY.mas_equalTo(contact.mas_centerY);
        
    }];
    
    UIButton *phone=[UnityLHClass masonryButton:@"联系人号码：" imageStr:@"Community_dianhua" font:13.0 color:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00]];
    [phone layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self addSubview:phone];
    self.phone=[UnityLHClass masonryLabel:@"13022172628" font:13.0 color:BM_BLACK];
    [self addSubview:self.phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_left);
        make.top.mas_equalTo(contact.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phone.mas_right).offset(5);
        make.centerY.mas_equalTo(phone.mas_centerY);
        
    }];
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_top);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.phone.mas_bottom).offset(10);
    }];
}
-(void)loadViewWithDataSource:(id)data
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:data[@"activityImage"]]];
    NSString *activityBeginTime=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd HH:mm" andTimeString:data[@"activityBeginTime"]];
    NSString *activityEndTime=[UnityLHClass getCurrentTimeWithType:@"MM-dd HH:mm" andTimeString:data[@"activityEndTime"]];
    self.time.text=[NSString stringWithFormat:@"%@-%@",activityBeginTime,activityEndTime];
    
    //applyStatus 	String 	报名状态（01：报名未开始,02：报名中,03：报名截止,04：活动中,05：活动结束）
    NSString *applyStatus=@"报名未开始";
    switch ([data[@"applyStatus"] integerValue])
    {
        case 1:
        {
            applyStatus=@"报名未开始";
        }
            break;
        case 2:
        {
            applyStatus=@"报名中";
        }
            break;
        case 3:
        {
            applyStatus=@"报名截止";
            
        }
            break;
        case 4:
        {
            applyStatus=@"活动中";
            
        }
            break;
        case 5:
        {
            applyStatus=@"活动结束";
            
        }
            break;
            
        default:
            break;
    }
    self.status.text= applyStatus;
    self.title.text=data[@"activityTitle"];
    self.address.text=data[@"activityAddress"];
    self.contact.text=[NSString stringWithFormat:@"%@",data[@"activityContact"]];
    self.phone.text=data[@"contactMobile"];
}

@end
