//
//  PropertyHomeBannerView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyHomeBannerView.h"
#import "CommonHeaderView.h"
@interface PropertyHomeBannerView ()<CommonHeaderViewDelegate>

@property (nonatomic ,strong) CommonHeaderView * bannerImageView;
@property (nonatomic ,strong) UIImageView * nameContentImageView;
@property (nonatomic ,strong) UILabel * nameLabel;

@end
@implementation PropertyHomeBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect bannerFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.bannerImageView = [[CommonHeaderView alloc]initWithFrame:bannerFrame];
        self.bannerImageView.delegate = self;
        [self.bannerImageView configureBannerViewWithImageData:nil];
         [self addSubview:self.bannerImageView];
        self.bannerImageView.bannerView.pc.frame=CGRectMake(0, frame.size.height - 25-60, frame.size.width - 5, 20);
//        self.bannerImageView.bannerView.pc.hidden=YES;
        
        self.nameContentImageView = [[UIImageView alloc] init];
        self.nameContentImageView.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.4 alpha:0.5]];
        [self addSubview:self.nameContentImageView];
        self.nameContentImageView.frame=CGRectMake(0,DEF_HEIGHT(self)-30, DEF_WIDTH(self), 30);
        
        self.nameLabel = [UnityLHClass masonryLabel:[KeychainManager readDistrictAddress] font:15 color:[UIColor whiteColor]];
        [self.nameContentImageView addSubview:self.nameLabel];
        self.nameLabel.frame=CGRectMake(15,0 , DEF_WIDTH(self)-30, 30);

        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

}

+ (instancetype)view{

    return [[self alloc] init];
}

- (void)config:(id)data
{
    [self.bannerImageView configureBannerViewWithImageData:data[@"imageArr"]];
    self.nameLabel.text=[NSString stringWithFormat:@"%@%@%@%@%@",data[@"provinceName"],data[@"cityName"],data[@"countyName"],data[@"districtAddress"],data[@"districtName"]];
}

// 点选bannerimage的操作
- (void) commonHeaderView:(CommonHeaderView *)comonHeaderView didSelectedBannerImageAtIndex:(NSInteger)index
{
    
}
@end
