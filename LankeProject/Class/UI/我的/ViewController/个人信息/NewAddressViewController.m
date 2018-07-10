//
//  NewAddressViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "NewAddressViewController.h"
#import "JYZTextView.h"
#import "LKBottomButton.h"
#import "SelectAddressViewController.h"
#import "BaiduMapHeader.h"

@interface NewAddressViewController ()<BMKGeoCodeSearchDelegate>

@property (nonatomic ,strong) BMKGeoCodeSearch * geoSearch;

@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UITextField *nameTF;

@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) JYZTextView *detailTV;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, copy) NSString *addressLongitude;

@property (nonatomic, copy) NSString *addressLatitude;

@property (nonatomic ,strong) NSString * province;// 省
@property (nonatomic ,strong) NSString * city;// 市
@property (nonatomic ,strong) NSString * county;// 区、县

@end

@implementation NewAddressViewController

- (void)sureBtnAction:(UIButton *)sender
{
    
    if (self.nameTF.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请填写收货人"];
    }
    else if (![UnityLHClass checkTel:self.phoneTF.text])
    {
        [UnityLHClass showHUDWithStringAndTime:@"请填写正确的手机号码"];

    }
    else if (self.addressTF.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请选择所在区域"];
        
    }
    else if (self.detailTV.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请填写具体地址"];
        
    }
    else
    {
        NSString *isDefault=@"0";
        if (self.chooseBtn.selected)
        {
            isDefault=@"1";
        }
        
        if (self.data)
        {
            //编辑
            [UserServices
             getAddressListWithuserId:[KeychainManager readUserId]
             addressId:self.data[@"id"]
             receiveName:self.nameTF.text
             addressLongitude:self.addressLongitude
             addressLatitude:self.addressLatitude
             areaInfo:self.addressTF.text
             detailedAddress:self.detailTV.text
             receivePhone:self.phoneTF.text
             isDefault:isDefault
             province:self.province
             city:self.city
             county:self.county
             completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 }
                 else
                 {
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 }
             }];
        }
        else
        {
            //新增
            [UserServices
             addAddressWithuserId:[KeychainManager readUserId]
             receiveName:self.nameTF.text
             addressLongitude:self.addressLongitude
             addressLatitude:self.addressLatitude
             areaInfo:self.addressTF.text
             detailedAddress:self.detailTV.text
             receivePhone:self.phoneTF.text
             isDefault:isDefault
             province:self.province
             city:self.city
             county:self.county
             completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
                 {
                     [self.navigationController popViewControllerAnimated:YES];

                 }
                 else
                 {
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 }
                 
             }];
        }

    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;

    if (self.data)
    {
        [self showNavBarCustomByTitle:@"编辑收货地址"];

    }
    else
    {
        [self showNavBarCustomByTitle:@"新增收货地址"];

    }

    [self initUI];
}

- (void)initUI
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = BM_WHITE;
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.height.offset(200);
    }];
    
    //收货人
    UILabel *nameLB = [UnityLHClass masonryLabel:@"收货人" font:15.0 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [topView addSubview:nameLB];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(15);
        make.left.mas_equalTo(topView.mas_left).offset(15);
        make.width.mas_equalTo(topView.mas_width).multipliedBy(0.2);
    }];
    
    self.nameTF = [[UITextField alloc] init];
    self.nameTF.placeholder = @"请输入收货人";
    self.nameTF.font = BM_FONTSIZE(14.0);
    [topView addSubview:self.nameTF];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(15);
        make.right.mas_equalTo(topView.mas_right).offset(-15);
        make.left.mas_equalTo(nameLB.mas_right).offset(10);
        make.centerY.mas_equalTo(nameLB.mas_centerY);
    }];
    
    UIImageView *line1 = [[UIImageView alloc] init];
    line1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLB.mas_bottom).offset(15);
        make.left.mas_equalTo(nameLB.mas_left);
        make.right.mas_equalTo(topView.mas_right).offset(-10);
        make.height.offset(0.8);
    }];
    
    
    // --------------------- 手机号码 ----------------------
    UILabel *phoneLB = [UnityLHClass masonryLabel:@"手机号码" font:15.0 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [topView addSubview:phoneLB];
    
    [phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).offset(15);
        make.left.mas_equalTo(nameLB.mas_left);
        make.width.mas_equalTo(nameLB.mas_width);
    }];
    
    
    self.phoneTF = [[UITextField alloc] init];
    self.phoneTF.placeholder = @"请输入手机号码";
    self.phoneTF.font = BM_FONTSIZE(14.0);
    [topView addSubview:self.phoneTF];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).offset(15);
        make.right.mas_equalTo(topView.mas_right).offset(-15);
        make.left.mas_equalTo(phoneLB.mas_right).offset(10);
        make.centerY.mas_equalTo(phoneLB.mas_centerY);
    }];
    
    
    UIImageView *line2 = [[UIImageView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLB.mas_bottom).offset(15);
        make.left.mas_equalTo(phoneLB.mas_left);
        make.right.mas_equalTo(topView.mas_right).offset(-10);
        make.height.offset(0.8);
    }];

    // ----------------- 所在区域 -----------------
    UILabel *addressLB = [UnityLHClass masonryLabel:@"所在区域" font:15.0 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [topView addSubview:addressLB];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).offset(15);
        make.left.mas_equalTo(nameLB.mas_left);
        make.width.mas_equalTo(nameLB.mas_width);
    }];
    
    
    self.addressTF = [[UITextField alloc] init];
    self.addressTF.placeholder = @"请选择";
    self.addressTF.font = BM_FONTSIZE(14.0);
    self.addressTF.userInteractionEnabled = NO;
    [topView addSubview:self.addressTF];
    
   
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.image = [UIImage imageNamed:@"UserCenter-RightArrow"];
    [topView addSubview:rightArrow];
    
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(addressLB.mas_centerY);
        make.right.mas_equalTo(topView.mas_right).offset(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];
    
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).offset(15);
        make.right.mas_equalTo(rightArrow.mas_left).offset(-10);
        make.left.mas_equalTo(addressLB.mas_right).offset(10);
        make.centerY.mas_equalTo(addressLB.mas_centerY);
    }];
  
    
    UIImageView *line3 = [[UIImageView alloc] init];
    line3.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topView addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLB.mas_bottom).offset(15);
        make.left.mas_equalTo(addressLB.mas_left);
        make.right.mas_equalTo(topView.mas_right).offset(-10);
        make.height.offset(0.8);
    }];
    
    
    UIButton *button=[[UIButton alloc]init];
    [button addTarget:self action:@selector(citySeleted) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=BM_CLEAR;
    [topView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLB.mas_centerY);
        make.left.mas_equalTo(self.addressTF.mas_left);
        make.right.mas_equalTo(rightArrow.mas_right);
        make.bottom.mas_equalTo(line3.mas_bottom);
    }];
    
    // ----------------- 具体地址 -----------------
    UILabel *addressDetailLB = [UnityLHClass masonryLabel:@"具体地址" font:15.0 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [topView addSubview:addressDetailLB];

    [addressDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line3.mas_bottom).offset(15);
        make.left.mas_equalTo(nameLB.mas_left);
        make.width.mas_equalTo(nameLB.mas_width);
    }];
    
    self.detailTV = [[JYZTextView alloc] init];
    self.detailTV.font = BM_FONTSIZE(14.0);
    self.detailTV.placeholder = @"请输入详细地址";
    self.detailTV.placeHolderLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:self.detailTV];
    
    [self.detailTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameTF.mas_left).offset(-5);
        make.top.mas_equalTo(line3.mas_bottom).offset(8);
        make.right.mas_equalTo(topView.mas_right).offset(-20);
        make.height.offset(100);
    }];
    
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.height.offset(280);
    }];
    
    
    //第二级
    UIView *buttomView = [[UIView alloc] init];
    buttomView.backgroundColor = BM_WHITE;
    [self.view addSubview:buttomView];
    
    self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.chooseBtn setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
    [self.chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseBtn setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
    [self.chooseBtn setTitle:@" 设为默认地址" forState:UIControlStateNormal];
    [buttomView addSubview:self.chooseBtn];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(buttomView.mas_centerY);
        make.left.mas_equalTo(buttomView.mas_left).offset(15);
        make.height.mas_equalTo(buttomView.mas_height).multipliedBy(0.4);
    }];
    
    [buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(topView.mas_bottom).offset(15);
        make.height.offset(50);
    }];
    
    
    //确认
    LKBottomButton *sureBtn = [[LKBottomButton alloc] init];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = BM_FONTSIZE(17.0);
    [self.view addSubview:sureBtn];
 
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.offset(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(buttomView.mas_bottom).offset(20);
    }];
    
    if (self.data)
    {
        [self showNavBarCustomByTitle:@"编辑收货地址"];
        self.nameTF.text=self.data[@"receiveName"];
        self.phoneTF.text=self.data[@"receivePhone"];
        self.addressTF.text=self.data[@"areaInfo"];
        self.detailTV.text=self.data[@"detailedAddress"];
        self.addressLatitude=self.data[@"addressLatitude"];
        self.addressLongitude=self.data[@"addressLongitude"];
        self.chooseBtn.selected=NO;
        if ([self.data[@"isDefault"] integerValue]==1)
        {
            self.chooseBtn.selected=YES;
        }
    }
}

- (void)chooseBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)citySeleted
{
    [self.view endEditing:YES];
    
    SelectAddressViewController *adress=[[SelectAddressViewController alloc]init];
    adress.data=self.data;
    [self.navigationController pushViewController:adress animated:YES];
    [adress receiveObject:^(id object)
    {
        BMKPoiInfo *info=(BMKPoiInfo *)object;
        DEF_DEBUG(@"name=====%@  address=======%@",info.name,info.address);
        self.addressTF.text=info.name;
        self.addressLatitude=[NSString stringWithFormat:@"%f",info.pt.latitude];
        self.addressLongitude=[NSString stringWithFormat:@"%f",info.pt.longitude];
        
        BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc] init];
        option.reverseGeoPoint = info.pt;
        [self.geoSearch reverseGeoCode:option];
    }];
    
}


#pragma mark -
#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSString * province = result.addressDetail.province;
    NSString * city = result.addressDetail.city;
    NSString * region = result.addressDetail.district;
    
    self.province = province;
    self.city = city;
    self.county = region;
    
}
@end
