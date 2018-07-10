//
//  GroupBuyDetailHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyDetailHeaderView.h"
#import "LKBannerView.h"
#import "GroupBuyInfoView.h"
#import "GroupBuyRushInfoView.h"

@interface GroupBuyDetailHeaderView ()

@property (nonatomic ,strong) LKBannerView * bannerView;
@property (nonatomic ,strong) GroupBuyInfoView * infoView;
@property (nonatomic ,strong) GroupBuyRushInfoView * rushInfoView;

@property (nonatomic ,strong) id goodsData;
@end

@implementation GroupBuyDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _bannerView = [[LKBannerView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH + 0)];
        _bannerView.myPageView.duration = 3.0f;
        [self addSubview:_bannerView];
        
        LKWeakSelf
        _infoView = [GroupBuyInfoView view];
        
        _infoView.bHeightChangeHandle = ^(CGFloat height){
            LKStrongSelf
            if (_self.bHeightChangeHandle) {
                _self.bHeightChangeHandle(height + DEF_SCREEN_WIDTH + 60);
            }
        };
        _infoView.stepView.bReachMaxValueHandle = ^(NSInteger maxValue){
            LKStrongSelf
            if (_self.bReachMaxValueHandle) {
                _self.bReachMaxValueHandle(maxValue);
            }
        };
        [self addSubview:_infoView];
        
        _rushInfoView = [GroupBuyRushInfoView view];
        [self addSubview:_rushInfoView];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.left.mas_equalTo(self.bannerView.mas_left);
        make.right.mas_equalTo(self.bannerView.mas_right);
        make.bottom.mas_equalTo(self.rushInfoView.mas_top);
    }];
    
    [_rushInfoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.bannerView.mas_left);
        make.right.mas_equalTo(self.bannerView.mas_right);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (NSInteger) currentGoodsCount{
    
    return self.infoView.stepView.value;
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void) config:(id)data{
    
    self.goodsData = data;

    [self.bannerView configureBannerViewWithBannerList:data[@"imageArr"]];
    
    [self.infoView config:data];
    
    [self.rushInfoView config:data];
}
+(CGFloat)height:(id)data
{
      CGFloat height;
    height+=[GroupBuyInfoView height:data];
    height+=DEF_SCREEN_WIDTH ;
    height+=150;
    return height;
}
@end
