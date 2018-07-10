//
//  MallBulkGoodCell.h
//  LankeProject
//
//  Created by itman on 17/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface MallBulkGoodCell : BaseCollectionCell

@property (nonatomic ,copy) void (^bHandle)();
@property(nonatomic,strong)NetworkImageView *goodIcon;
@property(nonatomic,strong)UIButton *gooodParticipationNumber;
@property(nonatomic,strong)UIButton *isClouds;
@property(nonatomic,strong)UILabel *gooodName;
@property(nonatomic,strong)UILabel *gooodPrice;
@property(nonatomic,strong)UILabel *gooodOriginalPrice;
@property(nonatomic,strong)UILabel *gooodDiscount;
@property(nonatomic,strong)UILabel *gooodTime;
@property(nonatomic,strong)UILabel *gooodOrderNumber;
@property(nonatomic,strong)UIView *gooodProgress;
@property(nonatomic,strong)UIView *gooodOrderProgress;
@property(nonatomic,strong)UIProgressView * progressView;
@property(nonatomic,strong)UILabel * progress;
@property(nonatomic,strong)UIButton *goodBuy;

@end
