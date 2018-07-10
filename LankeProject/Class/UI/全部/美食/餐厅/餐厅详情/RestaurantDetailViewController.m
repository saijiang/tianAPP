//
//  RestaurantDetailViewController.m
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RestauraSectionView.h"
#import "RestauraNewsView.h"
#import "RestauraFooterView.h"
#import "ReservationViewController.h"
#import "ChooseDishesViewController.h"
#import "TakeOutListViewController.h"

@interface RestaurantDetailViewController ()<CommonHeaderViewDelegate>
{
    NSDictionary *tableDict;
    NSArray *bannerArray;
}
@property(nonatomic,strong)CommonHeaderView *bannerView;
@property(nonatomic,strong)RestauraSectionView *location;
@property(nonatomic,strong)RestauraSectionView *time;
@property(nonatomic,strong)RestauraSectionView *phone;
@property(nonatomic,strong)RestauraNewsView *instruction;
@property(nonatomic,strong)RestauraNewsView *news;
@property(nonatomic,strong)RestauraFooterView *footerView;
@property(nonatomic,strong)UIButton *islove;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"*******"];
    
    [self requestRestaurantDetailInfo];
}

-(CommonHeaderView*)bannerView
{
    if (!_bannerView)
    {
        //
        CGFloat rate = 0.5;
        self.bannerView = [[CommonHeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH * rate)];
        self.bannerView.delegate=self;
        self.bannerView.backgroundColor = [UIColor clearColor];
        [self.bannerView configureBannerViewWithImageData:nil];
    }
    return _bannerView;
}
-(RestauraSectionView*)location
{
    if (!_location)
    {
        _location=[[RestauraSectionView alloc]init];
        [_location loadViewWithImage:@"ding_dingwei" title:@"地        址:" content:@"北京市海淀区南大街31号"];
    }
    return _location;
}
-(RestauraSectionView*)time
{
    if (!_time)
    {
        _time=[[RestauraSectionView alloc]init];
        [_time loadViewWithImage:@"ding_shijian" title:@"营业时间：" content:@"10:00-20:00"];
    }
    return _time;

}
-(RestauraSectionView*)phone
{
    if (!_phone)
    {
        _phone=[[RestauraSectionView alloc]init];
        [_phone loadViewWithImage:@"ding_dianhua" title:@"联系电话：" content:@"010-57571289"];
        _phone.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        [_phone addGestureRecognizer:tap];
    }
    return _phone;
}
-(RestauraNewsView*)instruction
{
    if (!_instruction)
    {
        _instruction=[[RestauraNewsView alloc]init];
        _instruction.leftImage.image=[UIImage imageNamed:@"shuoming"];
    }
    return _instruction;
}
-(RestauraNewsView*)news
{
    if (!_news)
    {
        _news=[[RestauraNewsView alloc]init];
    }
    return _news;
}
-(RestauraFooterView *)footerView
{
    if (!_footerView)
    {
        _footerView=[[RestauraFooterView alloc]init];
        [_footerView receiveObject:^(id object) {
            if ([object integerValue]==0)
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    //订座
                    ReservationViewController * reservation=[[ReservationViewController alloc]init];
                    reservation.restaurantData = tableDict;
                    [self.navigationController pushViewController:reservation animated:YES];
                }];
            }
            else
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    //外卖
                    TakeOutListViewController * takeOut = [[TakeOutListViewController alloc] init];
                    takeOut.restaurantData = tableDict;
                    takeOut.takeOutType = @"02";
                    [self.navigationController pushViewController:takeOut animated:YES];
                }];
            }
        }];
    }
    return _footerView;
}

-(UIButton *)islove
{
    if (!_islove)
    {
        _islove=[UnityLHClass masonryButton:@"" imageStr:@"navigation_bar_collection_normal" font:14.0 color:[UIColor colorWithRed:1.00 green:0.64 blue:0.23 alpha:1.00]];
        //[_islove setTitle:@"" forState:UIControlStateSelected];
        [_islove setImage:[UIImage imageNamed:@"ding_shoucang"] forState:UIControlStateSelected];
        [_islove setTitleColor:[UIColor colorWithRed:1.00 green:0.64 blue:0.23 alpha:1.00] forState:UIControlStateSelected];
        [_islove handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                
                if (self.islove.isSelected) {
                    
                    [self requestCancelCollection];
                }else{
                    [self requestAddCollection];
                }
            }];
        }];
    }
    return _islove;
}
-(void)createUI
{
    [self addSubview:self.bannerView];
    [self addSubview:self.location];
    [self addSubview:self.time];
    [self addSubview:self.phone];
    [self addSubview:self.instruction];
    [self addSubview:self.news];
    [self addSubview:self.footerView];
    [self addSubview:self.islove];

    
    [self.islove mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.location.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.location.mas_bottom).offset(0);
        make.height.mas_equalTo(self.location.mas_height);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.time.mas_bottom).offset(0);
        make.height.mas_equalTo(self.location.mas_height);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    [self.instruction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.phone.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    [self.news mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.instruction.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.news.mas_bottom).offset(10);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

// 点选bannerimage的操作
- (void) commonHeaderView:(CommonHeaderView *)comonHeaderView didSelectedBannerImageAtIndex:(NSInteger)index
{
    
}


#pragma mark -
#pragma mark Network M

- (void) requestRestaurantDetailInfo{
    
    [UserServices getRestaurantDetail:self.restaurantData[@"id"]
                               userId:[KeychainManager readUserId]
                      completionBlock:^(int result, id responseObject)
     {
         if ([responseObject[@"status"] integerValue] == 0)
         {
             id data = responseObject[@"data"];
             
             tableDict = [[NSDictionary alloc] initWithDictionary:data];
             bannerArray = [[NSArray alloc] initWithObjects:tableDict[@"restaurantImageDetail1"],tableDict[@"restaurantImageDetail2"],tableDict[@"restaurantImageDetail3"], nil];
             
             self.location.contentLab.text = data[@"restaurantAddress"];
             self.islove.selected = [data[@"isCollect"] boolValue];
             self.time.contentLab.text = [NSString stringWithFormat:@"%@-%@",data[@"openTime"],data[@"endTime"]];
             self.phone.contentLab.text = data[@"contactPhone"];
             [self.news loadTitleWithTitle: data[@"noticeContent"]];
             [self.instruction loadTitleWithTitle: data[@"takeOutInstruction"]];
             self.title = [NSString stringWithFormat:@"%@",tableDict[@"restaurantName"]];
             [self.bannerView configureBannerViewWithImageData:bannerArray];
         }else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}


- (void) requestAddCollection{
    
    NSString * itemsId = [NSString stringWithFormat:@"%@",self.restaurantData[@"id"]];
    
    [UserServices collectionHeadlthAdviceWithUserId:[KeychainManager readUserId] itemsId:itemsId collectType:@"02" userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"收藏成功"];
            self.islove.selected = YES;
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestCancelCollection{
    
    NSString * itemsId = [NSString stringWithFormat:@"%@",self.restaurantData[@"id"]];
    
    [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId:itemsId collectType:@"02" completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];
            self.islove.selected = NO;
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)callPhone:(UITapGestureRecognizer *)tapGesture {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tableDict[@"contactPhone"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
