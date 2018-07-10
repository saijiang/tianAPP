//
//  HomepageViewController.m
//  LankeProject
//
//  Created by itman on 16/5/31.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HomepageViewController.h"

// 子视图
#import "LKHomeNavigationBarView.h"
#import "LKWeatherView.h"
#import "LKHomeBannerView.h"
#import "LKTopShelfView.h"
#import "LKBottomShelfView.h"
#import "HLLPopupView.h"
#import "ChoosePopupContentView.h"

//版本管理器
#import "VersionUpdateManager.h"
//定位管理器
#import "LocationManager.h"

// 购物
#import "MallHomepageViewController.h"
//疗休养
#import "TherapyHomepageViewController.h"
// 美食
#import "RepastViewController.h"
// 健康
#import "HealthHomeViewController.h"
// 社区
#import "CommunityHomePageViewController.h"
// 物业
#import "PropertyHomeViewController.h"
// 消息
#import "MyNewsViewController.h"
// 广告位跳转
#import "AdvDetailViewController.h"
#import "AdvertisingTopView.h"
#import "GroupBuyListViewController.h"
#import "MallStoreDetailViewController.h"
@interface HomepageViewController ()

@property (nonatomic ,strong) LKHomeNavigationBarView * navigationBarView;

@property (nonatomic ,strong) LKHomeBannerView * bannerView;

@property (nonatomic ,strong) LKWeatherView * weatherView;

@property (nonatomic ,strong) LKTopShelfView * topShelfView;

@property (nonatomic ,strong) LKBottomShelfView * bottomShelfView;

@property (nonatomic ,strong) NSMutableArray * bannerDatas;


@end

@implementation HomepageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (KAPPDELEGATE.isFirst) {
        
        [self createAdvertisingTopView];
        
    }
}
- (BOOL)hidenNavigationBar
{
 
    return YES;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bannerDatas = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestBannerList];
}
-(void)createAdvertisingTopView
{
    
  KAPPDELEGATE.topView =[[AdvertisingTopView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    KAPPDELEGATE.topView.tag=12306;
 [[UIApplication sharedApplication].keyWindow addSubview:KAPPDELEGATE.topView];
    
    
    [KAPPDELEGATE.topView receiveObject:^(id object) {
//        [topView removeAllSubviews];
        KAPPDELEGATE.isFirst=NO;
        if ([object isEqualToString:@"团购列表"]) {
            // 所有列表：团购列表
            GroupBuyListViewController *shop=[[GroupBuyListViewController alloc]init];
            [ self.navigationController  pushViewController:shop animated:YES];
        }else if ([object isEqualToString:@"自营店铺"]) {
            // 所有列表：团购列表
            [self  requestShopDetailWithmerchantId:KAPPDELEGATE.topView.dataSource[@"merchantId"]];
        }else{
            
            if (KAPPDELEGATE.topView) {
                
                [[[UIApplication sharedApplication].keyWindow viewWithTag:12306] removeFromSuperview];
            }
        }
     
    }];
}
- (void) requestShopDetailWithmerchantId:(NSString *)merchantId{
    
    [UserServices
     getMerchantDetailInfoWithUserId:[KeychainManager readUserId]
     merchantId:merchantId
     completionBlock:^(int result, id responseObject)
     {
         
         if (result == 0)
         {
             id data = responseObject[@"data"];
             
             //前两个自己添加的固定数据
             MallStoreDetailViewController * detail = [[MallStoreDetailViewController alloc] init];
             //             detail.merchantId=merchantSource[[object integerValue]-3][@"merchantId"];
             detail.merchantId=merchantId;
             detail.webData = data;
             [self.navigationController pushViewController:detail animated:YES];
             
             //             self.tempConetnt.data = data;
             
             //             [self.collectionView reloadData];
             //
             //             [self refresh];
         }
         else
         {
             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    [self.weatherView updateWeatherData];
    [[VersionUpdateManager sharedVersionUpdateManager] versionUpdate];
    [self.navigationBarView updateMessageCount];
    
    //更新下用户信息
    [UserServices getUserInfoWithuserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        
    }];
}

-(void)createUI
{
    

    LKWeakSelf
    
    // 6 plus
    // screenHeight = 736
    // height = 274.667
    // screenWidth = 414
    
    self.bannerView = [[LKHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH*(300.0/450.0))];
    self.bannerView.myPageView.didSelectPageViewAtIndex = ^(NSInteger index)
    {
        
        LKStrongSelf
        [_self navigationToAdDetailWithData:_self.bannerDatas[index]];
    };
    self.bannerView.backgroundColor = [UIColor clearColor];
    //[self.bannerView configureBannerViewWithBannerList:temp];
    [self addSubview:_bannerView];
    [self addSubview:self.bannerView];

    
    //
    self.weatherView = [[LKWeatherView alloc] init];
    [self addSubview:self.weatherView];

    //
    self.navigationBarView = [[LKHomeNavigationBarView alloc] init];
    self.navigationBarView.bMessageButtonHandle = ^()
    {
        LKStrongSelf
        [_self navigationToMessage];
    };
    self.navigationBarView.bLocationButtonHandle = ^()
    {
        LKStrongSelf
        [_self navigationToLocation];
    };
    [self addSubview:self.navigationBarView];
    
    //
    self.topShelfView = [[LKTopShelfView alloc] init];
    self.topShelfView.backgroundColor = [UIColor whiteColor];
    self.topShelfView.foodItemView.bShelfTapHandle = ^()
    {
        LKStrongSelf
        [_self navigationToFood];
    };
    
    self.topShelfView.healthItemView.bShelfTapHandle = ^()
    {
        LKStrongSelf
        [_self navigationToHealth];
    };
    self.topShelfView.shoppingItemView.bShelfTapHandle = ^()
    {
        LKStrongSelf
        [_self navigationToShopping];
    };
    self.topShelfView.TherapyItemView.bShelfTapHandle = ^{
       LKStrongSelf
        [_self navigationToTherapy];
    };
    [self addSubview:self.topShelfView];

    
    self.bottomShelfView = [[LKBottomShelfView alloc] init];
    self.bottomShelfView.backgroundColor = [UIColor whiteColor];
    self.bottomShelfView.groupItemView.bShelfTapHandle = ^()
    {
        LKStrongSelf
        [_self navigationToCommunity];
    };
    self.bottomShelfView.propertyItemView.bShelfTapHandle = ^()
    {
        LKStrongSelf
        [_self navigationToProperty];
    };
    [self addSubview:self.bottomShelfView];
    self.contentView.bounces=NO;
    
    [LocationManager sharedLocationManager].bGeoResultHandle=^(id location)
    {
        
        [self.navigationBarView configNavigationBarWithData:location];
    };
    
}

- (void)viewDidLayoutSubviews
{

    [super viewDidLayoutSubviews];
    
    [self.navigationBarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(64);
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.navigationBarView.mas_left);
        make.top.mas_equalTo(self.navigationBarView.mas_top);
        make.right.mas_equalTo(self.navigationBarView.mas_right);
        make.height.mas_equalTo(DEF_SCREEN_WIDTH*(300.0/450.0));
    }];
    
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat height = 100;
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.bannerView.mas_right).mas_offset(-20);
        make.height.mas_equalTo(height);
        make.bottom.mas_equalTo(self.bannerView.mas_bottom).mas_offset(height/2);
    }];
    
    [self.topShelfView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.bannerView.mas_left);
        make.top.mas_equalTo(self.weatherView.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(self.bannerView.mas_right);
        make.height.mas_equalTo(200);
    }];
    
    [self.bottomShelfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bannerView.mas_left);
        make.top.mas_equalTo(self.topShelfView.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(self.bannerView.mas_right);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
}

#pragma mark -
#pragma mark Action M

- (void) navigationToMessage
{
    
    // 跳转至消息界面
    if ([KeychainManager islogin])
    {
        MyNewsViewController *mynews=[[MyNewsViewController alloc]init];
        [self.navigationController pushViewController:mynews animated:YES];
    }
   // [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
}

- (void) navigationToLocation
{
    // 跳转至定位界面
    [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
}

- (void) navigationToShopping
{
    
    MallHomepageViewController *mallHome=[[MallHomepageViewController alloc]init];
    [self.navigationController pushViewController:mallHome animated:YES];
}
- (void) navigationToTherapy{
    TherapyHomepageViewController *therapyHome=[[TherapyHomepageViewController alloc]init];
    [self.navigationController pushViewController:therapyHome animated:YES];
}

- (void) navigationToHealth
{
    
    HealthHomeViewController * vc = [[HealthHomeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) navigationToFood
{
    
    // 跳转至美食界面
    RepastViewController *repast = [[RepastViewController alloc]init];
    [self.navigationController pushViewController:repast animated:YES];
}

- (void) navigationToCommunity
{
    // 跳转至社区界面
     [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{

      CommunityHomePageViewController *communityHomePage=[[CommunityHomePageViewController alloc]init];
      [self.navigationController pushViewController:communityHomePage animated:YES];

  }];


    

}

- (void) navigationToProperty{
    
    // 跳转至w物业界面
//    [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
//    return ;
    
  [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{

        //判断物业权限是否开启
        if (![KeychainManager isPropertyAuthorityFlg]) {
          [UnityLHClass showAlertView:@"请联系管理员开启物业权限"];
          return ;
   }
      PropertyHomeViewController * vc = [[PropertyHomeViewController alloc] init];
       [self.navigationController pushViewController:vc animated:YES];

}];


}

- (void) navigationToAdDetailWithData:(id)data{
    
    // 跳转至banner详情界面
    AdvDetailViewController * detail = [[AdvDetailViewController alloc] init];
    if ([data[@"source"]  isEqual: @"02"])
    {
        
        detail.data = data;
        detail.advType = 1;
    }
    if([data[@"source"]  isEqual: @"01"])
    {
        
        detail.advType = 3;
        detail.externalUrl = data[@"externalUrl"];
    }
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
#pragma mark Network M

- (void) requestBannerList
{
    
    [UserServices
     advertAdvertListCompletionBlock:^(int result, id responseObject)
    {
       
        if (result == 0)
        {
            NSArray * data = responseObject[@"data"];
            [self.bannerDatas removeAllObjects];
            [self.bannerDatas addObjectsFromArray:data];
            NSMutableArray * temp = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary * banner in self.bannerDatas)
            {
                [temp addObject:banner[@"advertImage"]];
            }
            [self.bannerView configureBannerViewWithBannerList:temp];
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
