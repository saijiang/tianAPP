//
//  PropertyRepairViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairViewController.h"
#import "PropertyRepairHistoryViewController.h"
#import "PropertyRepairZoneView.h"
#import "PropertyRepairLocationView.h"
#import "LKBottomButton.h"
#import "SelectedPhotoView.h"

@interface PropertyRepairViewController ()

@property (nonatomic ,strong) PropertyRepairZoneView * zoneView;
@property (nonatomic ,strong) PropertyRepairLocationView * locationView;
@property (nonatomic ,strong) UILabel *photolable;
@property (nonatomic ,strong) SelectedPhotoView * photo;
@property (nonatomic ,strong) LKBottomButton * button;
@end

@implementation PropertyRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修单";
    [self showRightBarButtonItemHUDByName:@"报修历史"];
    
}

- (void)createUI{

    self.zoneView = [PropertyRepairZoneView view];
    [self addSubview:self.zoneView];
    
    self.locationView = [PropertyRepairLocationView view];
    [self addSubview:self.locationView];
    
    
    self.photolable=[UnityLHClass masonryLabel:@"上传照片" font:15.0 color:BM_BLACK];
    [self addSubview:self.photolable];
    
    self.photo=[[SelectedPhotoView alloc]initWithFrame:CGRectMake(10, DEF_BOTTOM(self.photolable), DEF_SCREEN_WIDTH-10*2, 100)];
    self.photo.maxColumn=3;
    self.photo.maxImageCount=3;
    [self addSubview:self.photo];

    LKBottomButton * button = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:@"提交申请" forState:UIControlStateNormal];
    button.layer.masksToBounds = NO;
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self addOrderRepair];
    }];
    [self addSubview:button];
    self.button = button;
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    [self.zoneView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(250);
    }];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.zoneView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(150);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.photolable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.locationView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.photolable.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-90);
    }];
}

- (void)baseRightBtnAction:(UIButton *)btn{

    PropertyRepairHistoryViewController * vc = [[PropertyRepairHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addOrderRepair
{
    if (self.zoneView.repairTypeSecond.length==0||[self.zoneView.repairTypeSecond isEqualToString:@"请选择"])
    {
        [UnityLHClass showAlertView:@"请选择报修类型"];
    }
    else if (self.locationView.contentView.text.length==0)
    {
        [UnityLHClass showAlertView:@"请填写报修内容"];

    }
    else if (self.locationView.contentView.text.length>50)
    {
        [UnityLHClass showAlertView:self.locationView.contentView.placeholder];
        
    }
    else
    {
        [UserServices
         addOrderRepairWithDistrictId:[KeychainManager readDistrictId]
         userId:[KeychainManager readUserId]
         repairArea:self.zoneView.repairArea
         repairTypeFirst:self.zoneView.repairTypeFirst
         repairTypeSecond:self.zoneView.repairTypeSecond
         repairAddress:self.locationView.repairAddressView.text
         repairContent:self.locationView.contentView.text
         imagesPath:self.photo.images
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 [UnityLHClass showHUDWithStringAndTime:@"提交申请成功，尽快安排工作人员维修"];
                 PropertyRepairHistoryViewController * vc = [[PropertyRepairHistoryViewController alloc] init];
                 [self.navigationController pushViewController:vc animated:YES];
                 if (self.navigationController && [self.navigationController.viewControllers count])
                 {
                     NSMutableArray * vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                     [vcs removeObjectAtIndex:vcs.count-2];
                     self.navigationController.viewControllers = vcs;
                 }

             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
}

@end
