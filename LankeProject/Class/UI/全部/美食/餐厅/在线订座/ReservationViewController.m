//
//  ReservationViewController.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationViewController.h"

#import "ReservationSectionView.h"
#import "ReservationTextView.h"
#import "ReservationGenderView.h"
#import "ReservationNoteView.h"
#import "BookPopupContentView.h"
#import "ChoosePopupContentView.h"
#import "ReservationInfo.h"
#import "ChooseDishesViewController.h"


@interface ReservationViewController ()

@property (nonatomic ,strong) ReservationInfo * info;

@property(nonatomic,strong)ReservationTextView *num;
@property(nonatomic,strong)ReservationSectionView *time;
@property(nonatomic,strong)ReservationTextView *name;
@property(nonatomic,strong)ReservationGenderView *gender;
@property(nonatomic,strong)ReservationTextView *phone;
@property(nonatomic,strong)ReservationNoteView *note;

@end

@implementation ReservationViewController

-(void)hideKeyboard
{
    [self.num.textField resignFirstResponder];
    [self.name.textField resignFirstResponder];
    [self.phone.textField resignFirstResponder];
    [self.note.textView resignFirstResponder];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.info = [[ReservationInfo alloc] init];
    
    [self showNavBarCustomByTitle:@"在线订餐"];
}
-(void)createUI
{
    //

    LKWeakSelf
    //
    self.num=[[ReservationTextView alloc]init];
    self.num.leftTitle.text=@"人数";
    self.num.textField.placeholder=@"请输入订座人数";
    self.num.textField.textAlignment=NSTextAlignmentRight;
    self.num.textField.keyboardType=UIKeyboardTypeNumberPad;
    self.num.bTextChangeValueHandle = ^(NSString * content){
        LKStrongSelf
        _self.info.count = [content integerValue];
    };
    [self addSubview:self.num];
    
    //
    self.time=[[ReservationSectionView alloc]init];
    self.time.leftTitle.text=@"时间";
    self.time.rightTitle.text = @"请选择";
    self.time.bTapHandle = ^(){
        LKStrongSelf
        [_self hideKeyboard];
        ChoosePopupContentView * choosepopupContentView = [[ChoosePopupContentView alloc] initPopupViewWithType:ChoosePopupContentDate];
        choosepopupContentView.bSureHandle = ^(NSDate * data){
          
            NSString * date = [data stringForNormalDataFormatter:@"YYYY-MM-dd"];
            NSString * time ;//= [data stringForNormalDataFormatter:@"HH:mm"];
            NSString * time_hour = [data stringForNormalDataFormatter:@"HH"];
            NSString * time_min = [data stringForNormalDataFormatter:@"mm"];
            NSInteger min = [time_min integerValue];
            if (min< 30)
            {
                time_min = @"00";
            }
            else
            {
                time_min = @"30";
            }
            time = [NSString stringWithFormat:@"%@:%@",time_hour,time_min];
            _self.time.rightTitle.text = [NSString stringWithFormat:@"%@ %@",[data stringForNormalDataFormatter:@"MM月dd日"],time];
            _self.info.dateString = date;
            _self.info.timeString = time;
            _self.info.date = data;
        };
        HLLPopupView * popupView = [HLLPopupView tipInWindow:choosepopupContentView];
        [popupView show:YES];
    };
    [self addSubview:self.time];
    
    //
    self.name=[[ReservationTextView alloc]init];
    self.name.leftTitle.text=@"姓名";
    self.name.textField.placeholder=@"请输入你的姓名";
    self.name.bTextChangeValueHandle = ^(NSString * content){
        LKStrongSelf
        _self.info.name = content;
    };
    [self addSubview:self.name];
    
    //
    self.gender=[[ReservationGenderView alloc]init];
    self.gender.bChooseGenderHandle = ^(NSString * gender){
        LKStrongSelf
        _self.info.sex = gender;
    };
    [self addSubview:self.gender];
    
    //
    self.phone=[[ReservationTextView alloc]init];
    self.phone.leftTitle.text=@"电话";
    self.phone.textField.placeholder=@"请输入你的手机号码";
    self.phone.textField.keyboardType = UIKeyboardTypePhonePad;
    self.phone.bTextChangeValueHandle = ^(NSString * content){
        LKStrongSelf
        _self.info.phoneNumber = content;
    };
    [self addSubview:self.phone];
    
    //
    self.note=[[ReservationNoteView alloc]init];
    self.note.bTextChangeValueHandle = ^(NSString * note){
        LKStrongSelf
        _self.info.note = note;
    };
    [self addSubview:self.note];
    
    UIButton *goButton=[UnityLHClass masonryButton:@"立即订座" font:15.0 color:BM_WHITE];
    goButton.layer.masksToBounds=YES;
    goButton.layer.cornerRadius=10;
    [goButton addTarget:self action:@selector(gotoButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goButton];
    [goButton hll_setBackgroundImageWithColor:[UIColor colorWithRed:0.33 green:0.69 blue:0.85 alpha:1.00] forState:UIControlStateNormal];

    
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(50);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.num.mas_bottom);
        make.height.mas_equalTo(self.num.mas_height);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.time.mas_bottom).offset(10);
        make.height.mas_equalTo(self.num.mas_height);
    }];
    
    [self.gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.name.mas_bottom);
        make.height.mas_equalTo(self.num.mas_height);
    }];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.gender.mas_bottom);
        make.height.mas_equalTo(self.num.mas_height);
    }];
    
    [self.note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.phone.mas_bottom).offset(10);
        make.height.mas_equalTo(100);
    }];
    
    [goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.note.mas_bottom).offset(40);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-40);
    }];
}

- (void) gotoButtonHandle:(UIButton *)button{
    
    if ([self.info isValid]) {
        
        BookPopupContentView * popupContentView = [[BookPopupContentView alloc] init];
        popupContentView.iconImageView.image = [UIImage imageNamed:@"alert_icon_confirm"];
        [popupContentView configLeftButton:@"不需要点菜" handle:^{
            
            [self requestCommitReservationOrderGotoChooseDishes:@"0" completion:^(id data) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        [popupContentView configRightButton:@"去点菜" handle:^{
            
            ChooseDishesViewController * chooseDishes = [[ChooseDishesViewController alloc] init];
            chooseDishes.reservationInfo = self.info;
            chooseDishes.reservation = YES;
            chooseDishes.restaurantData = self.restaurantData;
            chooseDishes.flag = 100;
            [self.navigationController pushViewController:chooseDishes animated:YES];
        }];
        
        HLLPopupView * popupView = [HLLPopupView alertInWindow:popupContentView];
        [popupView show:YES];
        
        return;
    }
    
    //[UnityLHClass showHUDWithStringAndTime:@"请填写有效订座信息"];

}

// 是否点菜 0 否    1 是
- (void) requestCommitReservationOrderGotoChooseDishes:(NSString *)hasChooseDishes completion:(void(^)(id data))completion{
    
    NSString * count = [NSString stringWithFormat:@"%ld",(long)self.info.count];
    
    [UserServices orderReservationWithUserId:[KeychainManager readUserId]
                                    userName:[KeychainManager readUserName]
                                restaurantId:self.restaurantData[@"id"]
                              restaurantName:self.restaurantData[@"restaurantName"]
                                 contactName:self.info.name
                               contactMobile:self.info.phoneNumber
                                  contactSex:self.info.sex
                                   dinersNum:count
                                 reserveDate:self.info.dateString
                                 reserveTime:self.info.timeString
                                    orderFlg:hasChooseDishes
                                   orderNote:self.info.note
                                     payMent:@"01"
                             completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {

            if (completion) {
                completion(responseObject[@"data"]);
            }
    
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
