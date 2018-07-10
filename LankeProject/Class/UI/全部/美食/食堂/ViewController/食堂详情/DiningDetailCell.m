//
//  DiningDetailCell.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningDetailCell.h"

@implementation DiningDetailCell
-(id)initWithFrame:(CGRect)frame
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImageView = [[LocalhostImageView alloc]init];
        self.iconImageView.image = [UIImage imageNamed:@"locationIcon"];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(15);
        }];
        
        
        self.titleLab = [UnityLHClass masonryLabel:@"营业时间：" font:14.0 color:BM_Color_GrayColor];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            
        }];
        
        self.contentLab = [UnityLHClass masonryLabel:@"北京市海淀区南大街31号" font:14.0 color:BM_Color_BlackColor];
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_right).offset(0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(void)loadDiningDetailCellWithDataSource:(id)dataSource
{
    self.iconImageView.image = [UIImage imageNamed:@"locationIcon"];
    self.titleLab.text = @"营业时间：";
    self.contentLab.text = @"10:00-20:00";
}

-(void)loadViewWithImage:(NSString *)image title:(NSString *)title  content:(NSString *)content
{
    self.iconImageView.image = [UIImage imageNamed:image];
    self.titleLab.text = title;
    self.contentLab.text = content;
}
@end
