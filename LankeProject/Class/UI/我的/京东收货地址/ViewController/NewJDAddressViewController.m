//
//  NewJDAddressViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "NewJDAddressViewController.h"
#import "JYZTextView.h"
#import "LKBottomButton.h"
#import "SelectAddressViewController.h"
#import "BaiduMapHeader.h"
#import "SwitchAreaView.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"
#import "AddressItem.h"
@interface NewJDAddressViewController ()<BMKGeoCodeSearchDelegate,NSURLSessionDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) BMKGeoCodeSearch * geoSearch;
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic,strong) UIView  *cover;
@property (nonatomic, strong) UITextField *emailTF;

@property (nonatomic, strong) UITextField *nameTF;

@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) NSMutableArray *addressArray;

@property (nonatomic, strong) JYZTextView *detailTV;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, copy) NSString *addressLongitude;

@property (nonatomic, copy) NSString *addressLatitude;

@property (nonatomic ,strong) NSString * province;// 省
@property (nonatomic ,strong) NSString * city;// 市
@property (nonatomic ,strong) NSString * county;// 区、县
@property (nonatomic ,strong) NSString * town;// 区、县


@end

@implementation NewJDAddressViewController

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
    else if (![UnityLHClass validateEmail:self.emailTF.text])
    {
        [UnityLHClass showHUDWithStringAndTime:@"请填写正确的邮箱地址"];

        
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
            NSString*province=@"";
            NSString*provinceName=@"";
            NSString*city=@"";
            NSString*cityName=@"";
            NSString*county=@"";
            NSString*countyName=@"";
            NSString*town=@"";
            NSString*townName=@"";
         
            if (self.addressArray.count!=0) {
                
                
               
                for (int i=0; i<self.addressArray.count; i++) {
                    AddressItem*item=self.addressArray[i];
                    
                    if (i==0) {
                        province=item.value;
                        provinceName=item.name;
                    }
                    if (i==1) {
                        city=item.value;
                        cityName=item.name;
                    }
                    if (i==2) {
                        county=item.value;
                        countyName=item.name;
                    }
                    if (i==3) {
                        
                        town=item.value;
                        townName=item.name;
                    }
                }
                if (self.addressArray.count<4) {
                    town=@"0";
                    townName=@"";
                }
            }else{
                province=self.data[@"province"];
                provinceName=self.data[@"provinceName"];
                city=self.data[@"city"];
                cityName=self.data[@"cityName"];
                county=self.data[@"county"];
                countyName=self.data[@"countyName"];
                town=self.data[@"town"];
                townName=self.data[@"townName"];
                
            }

            
            [UserServices getJDAddressListWithaddressId:self.data[@"id"] userId:[KeychainManager readUserId] name:self.nameTF.text mobile:self.phoneTF.text email:self.emailTF.text address:self.detailTV.text province:province provinceName:provinceName city:city cityName:cityName county:county countyName:countyName town:town townName:townName  isDefault:isDefault completionBlock:^(int result, id responseObject) {
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
            NSString*province=@"";
            NSString*provinceName=@"";
            NSString*city=@"";
            NSString*cityName=@"";
            NSString*county=@"";
            NSString*countyName=@"";
            NSString*town=@"";
            NSString*townName=@"";
            for (int i=0; i<self.addressArray.count; i++) {
                AddressItem*item=self.addressArray[i];
                if (i==0) {
                    province=item.value;
                    provinceName=item.name;
                }
                if (i==1) {
                    city=item.value;
                    cityName=item.name;
                }
                if (i==2) {
                    county=item.value;
                    countyName=item.name;
                }
                if (i==3) {
                    
                    town=item.value;
                    townName=item.name;
                }
            }
            if (self.addressArray.count<4) {
                town=@"0";
                townName=@"";
            }
            
            
            [UserServices addJDAddressWithuserId:[KeychainManager readUserId] name:self.nameTF.text mobile:self.phoneTF.text email:self.emailTF.text address:self.detailTV.text province:province provinceName:provinceName city:city cityName:cityName county:county countyName:countyName  town:town townName:townName isDefault:isDefault completionBlock:^(int result, id responseObject) {
                if (result==0)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else
                {
                    [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                }
                

            }];
            //新增
//            [UserServices
//             addAddressWithuserId:[KeychainManager readUserId]
//             receiveName:self.nameTF.text
//             addressLongitude:self.addressLongitude
//             addressLatitude:self.addressLatitude
//             areaInfo:self.addressTF.text
//             detailedAddress:self.detailTV.text
//             receivePhone:self.phoneTF.text
//             isDefault:isDefault
//             province:self.province
//             city:self.city
//             county:self.county
//             completionBlock:^(int result, id responseObject)
//             {
//                 if (result==0)
//                 {
//                     [self.navigationController popViewControllerAnimated:YES];
//                     
//                 }
//                 else
//                 {
//                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//                 }
//                 
//             }];
        }
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   // [[CitiesDataTool sharedManager] requestGetData];

    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;
    
    if (self.data)
    {
     
        [self showNavBarCustomByTitle:@"编辑收货地址"];
        self.chooseLocationView.address=[NSString stringWithFormat:@"%@ %@ %@ %@",self.data[@"provinceName"],self.data[@"cityName"],self.data[@"countyName"],self.data[@"townName"]];
        self.chooseLocationView.areaCode=@"440104";
    }
    else
    {
        [self showNavBarCustomByTitle:@"新增收货地址"];
        
    }
    
    [self initUI];
    
    [self.view addSubview:self.cover];

}
- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addressTF.text=weakSelf.chooseLocationView.address;
                weakSelf.addressArray=weakSelf.chooseLocationView.itemArray;
                
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}
- (void)initUI
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = BM_WHITE;
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.height.offset(300);
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
    
    UIImageView *lineEmail = [[UIImageView alloc] init];
    lineEmail.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topView addSubview:lineEmail];
    
    [lineEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLB.mas_bottom).offset(15);
        make.left.mas_equalTo(phoneLB.mas_left);
        make.right.mas_equalTo(topView.mas_right).offset(-10);
        make.height.offset(0.8);
    }];
    
    // --------------------- 邮箱 ----------------------

    
    UILabel *emailLB = [UnityLHClass masonryLabel:@"邮箱" font:15.0 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [topView addSubview:emailLB];
    
    [emailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineEmail.mas_bottom).offset(15);
        make.left.mas_equalTo(nameLB.mas_left);
        make.width.mas_equalTo(nameLB.mas_width);
    }];

    
    self.emailTF = [[UITextField alloc] init];
    self.emailTF.placeholder = @"请输入邮箱";
    self.emailTF.font = BM_FONTSIZE(14.0);
    [topView addSubview:self.emailTF];
    
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineEmail.mas_bottom).offset(15);
        make.right.mas_equalTo(topView.mas_right).offset(-15);
        make.left.mas_equalTo(emailLB.mas_right).offset(10);
        make.centerY.mas_equalTo(emailLB.mas_centerY);
    }];
//
    
    
    UIImageView *line2 = [[UIImageView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emailLB.mas_bottom).offset(15);
        make.left.mas_equalTo(emailLB.mas_left);
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
        make.height.offset(320);
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
        self.nameTF.text=self.data[@"name"];
        self.phoneTF.text=self.data[@"mobile"];
        self.addressTF.text=[NSString stringWithFormat:@"%@ %@ %@ %@",self.data[@"provinceName"],self.data[@"cityName"],self.data[@"countyName"],self.data[@"townName"]];
        self.detailTV.text=self.data[@"address"];
         self.emailTF.text=self.data[@"email"];
       // self.addressLatitude=self.data[@"addressLatitude"];
        //self.addressLongitude=self.data[@"addressLongitude"];
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
    [UIView animateWithDuration:0.25 animations:^{
//        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
        self.cover.hidden = !self.cover.hidden;
        self.chooseLocationView.hidden = self.cover.hidden;
    }];
   
//    SwitchAreaView *switchAreaView=[[SwitchAreaView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_HEIGHT(self.view)/2.0)];
//    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:switchAreaView preferredStyle:TYAlertControllerStyleActionSheet];
//    alertController.backgoundTapDismissEnable = YES;
//    [self presentViewController:alertController animated:YES completion:nil];
//    [switchAreaView receiveObject:^(id object) {
//        
//        
//       // [self showRightBar];
//    }];
    
//    SelectAddressViewController *adress=[[SelectAddressViewController alloc]init];
//    adress.data=self.data;
//    [self.navigationController pushViewController:adress animated:YES];
//    [adress receiveObject:^(id object)
//     {
//         BMKPoiInfo *info=(BMKPoiInfo *)object;
//         DEF_DEBUG(@"name=====%@  address=======%@",info.name,info.address);
//         self.addressTF.text=info.name;
//         self.addressLatitude=[NSString stringWithFormat:@"%f",info.pt.latitude];
//         self.addressLongitude=[NSString stringWithFormat:@"%f",info.pt.longitude];
//         
//         BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc] init];
//         option.reverseGeoPoint = info.pt;
//         [self.geoSearch reverseGeoCode:option];
//     }];
    
}


#pragma mark -
#pragma mark BMKGeoCodeSearchDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}

- (ChooseLocationView *)chooseLocationView{
    
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0,DEF_SCREEN_HEIGHT - 350, DEF_SCREEN_WIDTH, 350)];
        
    }
    return _chooseLocationView;
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSString * province = result.addressDetail.province;
    NSString * city = result.addressDetail.city;
    NSString * region = result.addressDetail.district;
//    NSString*town=result.addressDetail.streetName;
    
    self.province = province;
    self.city = city;
    self.county = region;
//    self.town=town;
    
}
@end

