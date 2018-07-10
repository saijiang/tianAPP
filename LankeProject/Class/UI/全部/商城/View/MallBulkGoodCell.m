//
//  MallBulkGoodCell.m
//  LankeProject
//
//  Created by itman on 17/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallBulkGoodCell.h"

@implementation MallBulkGoodCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        UIColor *color=[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.00];
        self.contentView.backgroundColor=BM_WHITE;
        
        self.goodIcon=[[NetworkImageView alloc]init];
        [self.contentView addSubview:self.goodIcon];
        self.goodIcon.image=[UIImage imageNamed:@"temp_photo"];
        self.goodIcon.layer.masksToBounds=YES;
        self.goodIcon.layer.cornerRadius=5;
        self.goodIcon.clipsToBounds=YES;
        [self.goodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(self.goodIcon.mas_height);

        }];
        
        self.gooodParticipationNumber=[UnityLHClass masonryButton:@"  100人成团  " font:11.0 color:BM_WHITE];
        self.gooodParticipationNumber.layer.masksToBounds=YES;
        self.gooodParticipationNumber.layer.cornerRadius=3;
        [self.goodIcon addSubview:self.gooodParticipationNumber];
        self.gooodParticipationNumber.backgroundColor=BM_Color_Blue;
        [self.gooodParticipationNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(1);
            make.height.mas_equalTo(18);

        }];
        
        self.isClouds=[UnityLHClass masonryButton:@"已成团" font:12.0 color:BM_WHITE];
        [self.goodIcon addSubview:self.isClouds];
        self.isClouds.backgroundColor=[UIColor colorWithRed:0.99 green:0.47 blue:0.40 alpha:0.5];
        [self.isClouds mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(25);
            
        }];
        
        self.gooodName=[UnityLHClass masonryLabel:@"四川黄心猕猴桃5kg（20-30个）" font:14.0 color:[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]];
        [self.contentView addSubview:self.gooodName];
        [self.gooodName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.goodIcon.mas_top).offset(2);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.goodIcon.mas_right).offset(10);
            
        }];
        
        self.gooodPrice=[UnityLHClass masonryLabel:@"¥500.00" font:15.0 color:[UIColor colorWithRed:1.00 green:0.59 blue:0.11 alpha:1.00]];
        [self.contentView addSubview:self.gooodPrice];
        [self.gooodPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gooodName.mas_bottom).offset(10);
            make.left.mas_equalTo(self.gooodName.mas_left);
            
        }];

        self.gooodOriginalPrice=[UnityLHClass masonryLabel:@"¥800.00" font:11.0 color:color];
        [self.contentView addSubview:self.gooodOriginalPrice];
        [self.gooodOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.gooodPrice.mas_centerY);
            make.left.mas_equalTo(self.gooodPrice.mas_right).offset(10);
            
        }];
        
        UIView *priceLine=[[UIView alloc]init];
        priceLine.backgroundColor=color;
        [self.gooodOriginalPrice addSubview:priceLine];
        [priceLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.gooodOriginalPrice.mas_centerY);
            make.centerX.mas_equalTo(self.gooodOriginalPrice.mas_centerX);
            make.width.mas_equalTo(self.gooodOriginalPrice.mas_width);
            make.height.mas_equalTo(1);
        }];
        
        self.gooodDiscount=[UnityLHClass masonryLabel:@"5折" font:13.0 color:[UIColor colorWithRed:1.00 green:0.59 blue:0.11 alpha:1.00]];
        [self.contentView addSubview:self.gooodDiscount];
        [self.gooodDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.gooodOriginalPrice.mas_centerY);
            make.right.mas_equalTo(self.gooodName.mas_right);
            
        }];
        
        UILabel *gooodTime=[UnityLHClass masonryLabel:@"截止时间：" font:12.0 color:color];
        [self.contentView addSubview:gooodTime];
        [gooodTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gooodPrice.mas_bottom).offset(10);
            make.left.mas_equalTo(self.gooodName.mas_left);
            
        }];
        
        self.gooodTime=[UnityLHClass masonryLabel:@"2017.1.10 17:00" font:12.0 color:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.00]];
        [self.contentView addSubview:self.gooodTime];
        [self.gooodTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(gooodTime.mas_centerY);
            make.left.mas_equalTo(gooodTime.mas_right);
            
        }];
        
        self.gooodOrderNumber=[UnityLHClass masonryLabel:@"88人已抢购" font:12.0 color:[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]];
        [self.contentView addSubview:self.gooodOrderNumber];
        [self.gooodOrderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gooodTime.mas_bottom).offset(10);
            make.left.mas_equalTo(self.gooodName.mas_left);
            
        }];
        
        self.goodBuy=[UnityLHClass masonryButton:@"去抢购" font:14.0 color:BM_WHITE];
        self.goodBuy.layer.masksToBounds=YES;
        self.goodBuy.userInteractionEnabled = NO;
        self.goodBuy.layer.cornerRadius=5;
        [self.goodBuy handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bHandle) {
                self.bHandle();
            }
        }];
        [self.contentView addSubview:self.goodBuy];
        self.goodBuy.backgroundColor=BM_Color_Blue;
        [self.goodBuy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gooodOrderNumber.mas_top);
            make.right.mas_equalTo(self.gooodName.mas_right);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(70);
        }];
        
        self.gooodProgress=[[UIView alloc]init];
        self.gooodProgress.layer.masksToBounds=YES;
        self.gooodProgress.layer.cornerRadius=2;
        self.gooodProgress.backgroundColor=color;
        [self.contentView addSubview:self.gooodProgress];
        [self.gooodProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.goodBuy.mas_bottom).offset(-5);
            make.left.mas_equalTo(self.gooodName.mas_left);
            make.right.mas_equalTo(self.goodBuy.mas_left).offset(-10);
            make.height.mas_equalTo(4);
        }];

        self.gooodOrderProgress=[[UIView alloc]init];
        self.gooodOrderProgress.layer.masksToBounds=YES;
        self.gooodOrderProgress.layer.cornerRadius=2;
        self.gooodOrderProgress.backgroundColor=[UIColor colorWithRed:1.00 green:0.38 blue:0.32 alpha:1.00];
        [self.gooodProgress addSubview:self.gooodOrderProgress];
        [self.gooodOrderProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.gooodProgress);
        }];
        self.gooodProgress.hidden =
        self.gooodOrderProgress.hidden = YES;
        
        self.progressView = [[UIProgressView alloc] init];
        self.progressView.layer.cornerRadius = 5.0f;
        self.progressView.layer.masksToBounds = YES;
        self.progressView.tintColor = [UIColor colorWithRed:1.00 green:0.38 blue:0.32 alpha:1.00];
        [self.contentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.mas_equalTo(self.goodBuy.mas_bottom).offset(-5);
            make.left.mas_equalTo(self.gooodName.mas_left);
            make.right.mas_equalTo(self.goodBuy.mas_left).offset(-10);
            make.height.mas_equalTo(10);
        }];
        
        self.progress=[UnityLHClass masonryLabel:@"45%" font:10.0 color:BM_WHITE];
        [self.contentView addSubview:self.progress];
        [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.progressView.mas_centerY);
            make.centerX.mas_equalTo(self.progressView.mas_centerX);
            
        }];
        
        
    }
    return self;
}

-(void)loadCellWithDataSource:(id)dataSource
{
    
    [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.gooodName.text=dataSource[@"goodsName"];

    NSInteger finalGroupStatus = [dataSource[@"finalGroupStatus"] integerValue];
    
    NSInteger isEndStatus = [dataSource[@"isEndStatus"] integerValue];
    
    if (isEndStatus == 1) {
        
        [self.isClouds setTitle:[NSString stringWithFormat:@"已截团"] forState:UIControlStateNormal];
        self.isClouds.hidden = NO;
        UIColor * color = [UIColor colorWithWhite:0.5 alpha:0.3];
        self.isClouds.backgroundColor= color;
        self.goodBuy.enabled = NO;
        self.goodBuy.backgroundColor=BM_Color_SeparatorColor;
    }else{
        self.goodBuy.enabled = YES;
        if (finalGroupStatus==1)// 已成团
        {
            [self.isClouds setTitle:[NSString stringWithFormat:@"已成团"] forState:UIControlStateNormal];
            self.isClouds.hidden = NO;
            self.isClouds.backgroundColor=[UIColor colorWithRed:0.99 green:0.47 blue:0.40 alpha:0.5];
            
            self.goodBuy.backgroundColor=BM_Color_Blue;
        }
        else if(finalGroupStatus == 2)// 未成团
        {
            [self.isClouds setTitle:[NSString stringWithFormat:@"未成团"] forState:UIControlStateNormal];
            self.isClouds.hidden = YES;
            UIColor * color = [UIColor colorWithWhite:0.5 alpha:0.3];
            self.isClouds.backgroundColor= color;
            
            self.goodBuy.backgroundColor=BM_Color_Blue;
        }
    }
    
    self.gooodPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"groupPrice"] floatValue]];
    self.gooodOriginalPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"originalPrice"] floatValue]];;
    self.gooodDiscount.text=[NSString stringWithFormat:@"%.1f折",[dataSource[@"groupPrice"] floatValue]/[dataSource[@"originalPrice"] floatValue]*10.0];

    self.gooodTime.text=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM.dd HH:mm" andTimeString:dataSource[@"endDate"]];
    
     NSInteger groupRule= [dataSource[@"groupRule"] integerValue];
    if (groupRule==1) {
        [self.gooodParticipationNumber setTitle:[NSString stringWithFormat:@"  %@人成团  ",dataSource[@"groupNumber"]] forState:UIControlStateNormal];
        self.gooodOrderNumber.text=[NSString stringWithFormat:@"%d人已抢购",[dataSource[@"alreadyBuyNum"] intValue]];
        
        CGFloat progress = [dataSource[@"alreadyBuyNum"] floatValue] / [dataSource[@"groupNumber"] floatValue];
        [self.progressView setProgress:progress];
        self.progress.text=[NSString stringWithFormat:@"%.0f％",progress*100.0];
        if (progress>1)
        {
            self.progress.text=[NSString stringWithFormat:@"%.0f％",100.f];
        }
        
    }else if(groupRule == 2){
        [self.gooodParticipationNumber setTitle:[NSString stringWithFormat:@"  %@件成团  ",dataSource[@"groupGoodsNumber"]] forState:UIControlStateNormal];
        self.gooodOrderNumber.text=[NSString stringWithFormat:@"%d件已抢购",[dataSource[@"alreadyBuyGoodsNum"] intValue]];
        
        CGFloat progress = [dataSource[@"alreadyBuyGoodsNum"] floatValue] / [dataSource[@"groupGoodsNumber"] floatValue];
        [self.progressView setProgress:progress];
        self.progress.text=[NSString stringWithFormat:@"%.0f％",progress*100.0];
        if (progress>1)
        {
            self.progress.text=[NSString stringWithFormat:@"%.0f％",100.f];
        }
    }
    
}

@end
