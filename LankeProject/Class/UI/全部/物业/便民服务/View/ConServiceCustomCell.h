//
//  ConServiceCustomCell.h
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ConServiceCustomCell : BaseTableViewCell

@property (nonatomic,strong)NetworkImageView *serviceIcon;//便民服务的图片
@property (nonatomic,strong)UILabel *serviceTitle;//标题
@property (nonatomic,strong)UILabel *serviceContent;//简介
@property (nonatomic,strong)LocalhostImageView *serviceAddressImg;//地址图标
@property (nonatomic,strong)UILabel *serviceAddressLab;//地址内容
@property (nonatomic,strong)UIButton *serviceCallBtn;//电话图标

@end
