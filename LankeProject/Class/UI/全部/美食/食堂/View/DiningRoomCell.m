//
//  DiningRoomCell.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningRoomCell.h"

@implementation DiningRoomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.selectionStyle=UICollectionViewCellSelectionStyleNone;
        
        UIImageView *bgImageView = [[UIImageView alloc]init];
        bgImageView.image = [UIImage imageWithColor:BM_WHITE];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.layer.cornerRadius = 5;
        bgImageView.layer.masksToBounds = YES;
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.clipsToBounds = YES;
        [bgImageView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgImageView.mas_left).offset(0);
            make.right.mas_equalTo(bgImageView.mas_right).offset(0);
            make.height.mas_equalTo(bgImageView.mas_height).offset(-60);
            make.top.mas_equalTo(bgImageView.mas_top);
        }];
        
        self.distanceLab = [UnityLHClass masonryLabel:@"227m" font:13.0 color:BM_Color_GrayColor];
        self.distanceLab.textAlignment = NSTextAlignmentRight;
        [bgImageView addSubview:self.distanceLab];
        [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgImageView.mas_right).mas_offset(-10);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(self.iconImageView.mas_bottom);
        }];
        
        self.locationIcon = [[LocalhostImageView alloc]initWithImage:[[UIImage imageNamed:@"locationIcon"] tintedGradientImageWithColor:[UIColor colorWithHexString:@"#999999"]]];
        [bgImageView addSubview:self.locationIcon];
        [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.distanceLab.mas_centerY);
            make.right.mas_equalTo(self.distanceLab.mas_left).mas_offset(-5);
        }];
        
        self.name = [UnityLHClass masonryLabel:@"朝阳区大望路11号" font:14.0 color:[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00]];
        [bgImageView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgImageView.mas_left).offset(10);
            make.height.mas_equalTo(self.distanceLab.mas_height);
            make.top.mas_equalTo(self.iconImageView.mas_bottom);
            make.right.mas_lessThanOrEqualTo(self.locationIcon.mas_left).mas_offset(-10);
        }];

        
        self.addressLab = [UnityLHClass masonryLabel:@"朝阳区大望路11号" font:14.0 color:BM_Color_BlackColor];
        [bgImageView addSubview:self.addressLab];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bgImageView.mas_bottom).offset(-10);
            make.left.mas_equalTo(bgImageView.mas_left).offset(10);
        }];
        
    }
    return self;
}

-(void)loadDiningRoomCellWithDataSource:(id)dataSource
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataSource[@"restaurantImageList"]]] placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    self.addressLab.text = dataSource[@"restaurantAddress"];
    self.name.text=dataSource[@"restaurantName"];
    NSString *distanceStr = [NSString stringWithFormat:@"%@",dataSource[@"distance"]];
    self.distanceLab.text = [NSString stringWithFormat:@"%@",distanceStr];
}


@end
