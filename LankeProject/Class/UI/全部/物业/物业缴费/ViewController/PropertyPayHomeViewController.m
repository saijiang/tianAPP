//
//  PropertyPayHomeViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayHomeViewController.h"
#import "PropertyPayContentView.h"
#import "PropertyPayViewController.h"
#import "PropertyPayHistoryViewController.h"

@interface PropertyPayHomeViewController ()

@property (nonatomic ,strong) NetworkImageView * bannerView;
@property (nonatomic ,strong) PropertyPayContentView * payContentView;
@property (nonatomic ,strong) UILabel * desLabel;

@property (nonatomic ,strong) LocalhostImageView * bottomImageView;

@end

@implementation PropertyPayHomeViewController

-(void)getDistrictInfo
{
    [UserServices
     getDistrictInfoWithDistrictId:[KeychainManager readDistrictId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             NSDictionary *data=responseObject[@"data"];
             NSString *imageUrl= [data[@"imageArr"] firstObject];
             [self.bannerView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"property_pay_home_banner"]];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业缴费";
    [self showRightBarButtonItemHUDByName:@"缴费记录"];
    [self creatUI];
    [self getDistrictInfo];
    
}

- (void) creatUI{
    
    self.bottomImageView = [[LocalhostImageView alloc] init];
    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bottomImageView.image = [UIImage imageNamed:@"property_pay_home_bottom"];
    [self addSubview:self.bottomImageView];
    
    self.bannerView = [[NetworkImageView alloc] init];
    self.bannerView.image = [UIImage imageNamed:@"property_pay_home_banner"];
    [self addSubview:self.bannerView];
    LKWeakSelf
    self.payContentView = [PropertyPayContentView view];
    self.payContentView.bSelectHandle = ^(NSInteger index){
        LKStrongSelf
        PropertyPayViewController * pay = [[PropertyPayViewController alloc] init];
        pay.billType=index+1;
        [_self.navigationController pushViewController:pay animated:YES];
    };
    [self addSubview:self.payContentView];
    
    self.desLabel = [UnityLHClass masonryLabel:@"本缴费模块支持i币支付，如i币余额不足，请去线下充值点充值" font:14 color:[UIColor colorWithHexString:@"666666"]];
    self.desLabel.numberOfLines = 0;
    [self addSubview:self.desLabel];
    
}
- (void)baseRightBtnAction:(UIButton *)btn{

    PropertyPayHistoryViewController * vc = [[PropertyPayHistoryViewController alloc] init];
    vc.TypeNum=0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(DEF_SCREEN_WIDTH/2.0);
    }];
    
    [self.payContentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.left.mas_equalTo(self.bannerView.mas_left);
        make.right.mas_equalTo(self.bannerView.mas_right);
        make.height.mas_equalTo(250);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.top.mas_equalTo(self.payContentView.mas_bottom).mas_offset(10);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(120);
    }];
}


#pragma mark -
#pragma mark Navigation M



#pragma mark -
#pragma mark Network M

@end
