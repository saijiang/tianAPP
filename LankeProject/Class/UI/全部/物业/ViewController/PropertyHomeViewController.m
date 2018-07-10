//
//  PropertyHomeViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyHomeViewController.h"
#import "PropertyHomeBannerView.h"
#import "PropertyHomeContentView.h"
#import "SwitchAreaView.h"

#import "CommunityHeadViewController.h"
#import "PropertyPayHomeViewController.h"
#import "ConvenienceServiceViewController.h"
#import "QuestionResearchViewController.h"
#import "MyPropertyInfoViewController.h"
#import "SuggestionViewController.h"
#import "PropertyRepairViewController.h"


@interface PropertyHomeViewController ()

@property (nonatomic ,strong) PropertyHomeBannerView * propertyBannerView;
@property (nonatomic ,strong) PropertyHomeContentView * propertyContentView;

@end

@implementation PropertyHomeViewController

-(void)getDistrictInfo
{
    if ([[KeychainManager readlocalDistrictId]length]==0)
    {
        //假如没有小区信息强制去选择一个小区
        [self baseRightBtnAction:nil];
        return;
    }
    [UserServices
     getDistrictInfoWithDistrictId:[KeychainManager readlocalDistrictId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.propertyBannerView config:responseObject[@"data"]];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showRightBarButtonItemHUDByName:@"切换小区"];
    [KeychainManager setlocalDistrictState:YES];
    [KeychainManager setlocalDistrictName:[KeychainManager readDistrictName]];
    [KeychainManager setlocalDistrictId:[KeychainManager readDistrictId]];
    [self showRightBar];

}

-(void)showRightBar
{
    self.title=[KeychainManager readlocalDistrictName];
    [self getDistrictInfo];
}

-(void)createUI{

    self.propertyBannerView = [[PropertyHomeBannerView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/2.0)];
    [self addSubview:self.propertyBannerView];
    
    LKWeakSelf
    self.propertyContentView = [PropertyHomeContentView view];
    self.propertyContentView.bSelectItemHandle = ^(NSInteger index){
        
        if ([[KeychainManager readlocalDistrictId]length]==0)
        {
            //假如没有小区信息强制去选择一个小区
            [__weakSelf baseRightBtnAction:nil];
            return;
        }
//        [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
//        return ;
        LKStrongSelf
        if(!(index==0||index==2))
        {
            //判断物业权限是否开启
            if (![KeychainManager isPropertyAuthorityFlg]) {
                [UnityLHClass showAlertView:@"请联系管理员开启物业权限"];
                return ;
            }
            else
            {
                if (index == 6) {
                    MyPropertyInfoViewController * vc = [[MyPropertyInfoViewController alloc] init];
                    [_self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    //判断所选择的小区和默认小区是否同一个小区
                    [UserServices
                     getDefaultpropertyWithDistrictId:[KeychainManager readlocalDistrictId]
                     completionBlock:^(int result, id responseObject)
                     {
                         
                         if (result==0)
                         {
                             if (index == 1) {
                                 PropertyRepairViewController * vc = [[PropertyRepairViewController alloc] init];
                                 [_self.navigationController pushViewController:vc animated:YES];
                             }
                             if (index == 3) {
                                 SuggestionViewController * vc = [[SuggestionViewController alloc] init];
                                 [_self.navigationController pushViewController:vc animated:YES];
                             }
                             if (index == 4) {
                                 PropertyPayHomeViewController * vc = [[PropertyPayHomeViewController alloc] init];
                                 [_self.navigationController pushViewController:vc animated:YES];
                             }
                             if (index == 5) {
                                 QuestionResearchViewController * vc = [[QuestionResearchViewController alloc] init];
                                 [_self.navigationController pushViewController:vc animated:YES];
                             }
                         }
                         else
                         {
                             [UnityLHClass showAlertView:responseObject[@"msg"]];
                             
                         }
                     }];

                }

            }
        }
        else
        {
           
            if (index == 0) {
                CommunityHeadViewController * vc = [[CommunityHeadViewController alloc] init];
                [_self.navigationController pushViewController:vc animated:YES];
            }
            if (index == 2) {
                ConvenienceServiceViewController * vc = [[ConvenienceServiceViewController alloc] init];
                [_self.navigationController pushViewController:vc animated:YES];
            }
            
        }
       
    };
    [self addSubview:self.propertyContentView];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.propertyContentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.propertyBannerView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(300);
    }];
}


#pragma mark -
#pragma mark Navig M

-(void)baseRightBtnAction:(UIButton *)btn
{
    SwitchAreaView *switchAreaView=[[SwitchAreaView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_HEIGHT(self.view)/2.0)];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:switchAreaView preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
    [switchAreaView receiveObject:^(id object) {
        [self showRightBar];
    }];
}


@end
