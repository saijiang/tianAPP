//
//  AddLogisticsViewController.m
//  LankeProject
//
//  Created by fud on 2017/12/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "AddLogisticsViewController.h"
#import "JYZTextView.h"
#import "PopUpSeletedView.h"
#import "ChoosePopupContentView.h"
#import "HLLPopupView.h"

@interface AddLogisticsViewController ()
@property(nonatomic,strong)UITextField *order;//快递单号
@property(nonatomic,strong)UITextField *feeTf;//运费
@property(nonatomic,strong)UIButton *timeBtn;//发货时间
@property(nonatomic,strong)UIButton *type;
@property(nonatomic,assign)NSInteger seletedIndex;
@property(nonatomic,assign)NSInteger seletedType;
@end

@implementation AddLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seletedIndex=0;
    self.seletedType=0;
    self.title = @"填写快递信息";
}

-(void)createUI
{
    UIView *topView=[[UIView alloc]init];
    topView.backgroundColor=BM_WHITE;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(163);
    }];
    
    
    UILabel *leftLab = [UnityLHClass masonryLabel:@"快递方式" font:15.0 color:BM_BLACK];
    [topView addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
    
    UIButton  *goImage=[UnityLHClass masonryButton:@"" imageStr:@"right_arrow" font:15.0 color:BM_BLACK];
    [topView addSubview:goImage];
    [goImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(leftLab.mas_centerY);
    }];
    [goImage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
        
    }];
    
    self.type=[UnityLHClass masonryButton:@"请选择" imageStr:@"" font:15.0 color:BM_BLACK];
    [topView addSubview:self.type];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImage.mas_left).offset(-5);
        make.centerY.mas_equalTo(leftLab.mas_centerY);
    }];
    [self.type handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftLab.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(leftLab.mas_left);
        make.right.mas_equalTo(goImage.mas_right);
        
    }];
    
    UILabel *leftOneLable=[UnityLHClass masonryLabel:@"快递单号" font:15.0 color:BM_BLACK];
    [topView addSubview:leftOneLable];
    [leftOneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_left);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(line.mas_bottom);
    }];
    
    self.order=[[UITextField alloc]init];
    self.order.placeholder=@"请输入快递单号";
    self.order.textAlignment = NSTextAlignmentRight;
    self.order.font=BM_FONTSIZE(15.0);
    [topView addSubview:self.order];
    [self.order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftOneLable.mas_right).offset(20);
        make.right.mas_equalTo(line.mas_right);
        make.centerY.mas_equalTo(leftOneLable.mas_centerY);
        
    }];
    
    UIView *twoline=[[UIView alloc]init];
    twoline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [topView addSubview:twoline];
    [twoline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftOneLable.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(leftLab.mas_left);
        make.right.mas_equalTo(goImage.mas_right);
        
    }];
    
    //运费
    UILabel *leftTwoLable=[UnityLHClass masonryLabel:@"运费" font:15.0 color:BM_BLACK];
    [topView addSubview:leftTwoLable];
    [leftTwoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_left);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(twoline.mas_bottom);
    }];
    
    self.feeTf=[[UITextField alloc]init];
    self.feeTf.placeholder=@"请输入运费";
    self.feeTf.textAlignment = NSTextAlignmentRight;
    self.feeTf.font=BM_FONTSIZE(15.0);
    [topView addSubview:self.feeTf];
    [self.feeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftOneLable.mas_right).offset(20);
        make.right.mas_equalTo(line.mas_right);
        make.centerY.mas_equalTo(leftTwoLable.mas_centerY);
        
    }];
    
    UIView *threeline=[[UIView alloc]init];
    threeline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [topView addSubview:threeline];
    [threeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftTwoLable.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(leftLab.mas_left);
        make.right.mas_equalTo(goImage.mas_right);
        
    }];
    
    //发货时间
    UILabel *leftThreeLable=[UnityLHClass masonryLabel:@"发货时间" font:15.0 color:BM_BLACK];
    [topView addSubview:leftThreeLable];
    [leftThreeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_left);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(threeline.mas_bottom);
    }];
    
    
    
    self.timeBtn = [UnityLHClass masonryButton:@"请选择发货时间" imageStr:@"" font:15.0 color:BM_BLACK];
    [topView addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line.mas_right);
        make.centerY.mas_equalTo(leftThreeLable.mas_centerY);
    }];
    [self.timeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self choseTime];
    }];
    
//    [UnityLHClass masonryLabel:@"请选择发货时间" font:15.0 color:BM_BLACK];
//    self.timeLab.textAlignment = NSTextAlignmentRight;
//    self.timeLab.userInteractionEnabled = YES;
//    [topView addSubview:self.timeLab];
//    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(leftOneLable.mas_right).offset(20);
//        make.right.mas_equalTo(line.mas_right);
//        make.centerY.mas_equalTo(leftThreeLable.mas_centerY);
//        make.height.mas_equalTo(leftThreeLable.mas_height);
//    }];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseTime)];
//    [self.timeLab addGestureRecognizer:tap];
    
    UIButton *submitButton=[UnityLHClass masonryButton:@"提交申请" font:15.0 color:BM_WHITE];
    submitButton.layer.masksToBounds=YES;
    submitButton.layer.cornerRadius=5;
    submitButton.backgroundColor=[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
    submitButton.frame=CGRectMake(15, 250, DEF_SCREEN_WIDTH-15*2, 40);
    [self addSubview:submitButton];
    [submitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self updateReturnOrder];
    }];
    self.contentView.contentSize=CGSizeMake(0, DEF_BOTTOM(submitButton)+30);
    
}
-(void)showDropDownView
{
    [self.view endEditing:YES];
    //    NSArray *dropArray=@[@{@"code":@"shunfeng",@"name":@"顺丰快递"},
    //                         @{@"code":@"ems",@"name":@"邮政EMS"},
    //                         @{@"code":@"shentong",@"name":@"申通快递"},
    //                         @{@"code":@"yuantong",@"name":@"圆通速递"},
    //                         @{@"code":@"zhongtong",@"name":@"中通快递"},
    //                         @{@"code":@"huitongkuaidi",@"name":@"百世汇通"},
    //                         @{@"code":@"yunda",@"name":@"韵达快递"},
    //                         ];
//    发运公司 圆通快递、申通快递、韵达快递、中通快递、宅急送、EMS、顺丰快递
    NSArray *dropArray=@[@"圆通快递",@"申通快递",@"韵达快递",@"中通快递",@"宅急送",@"EMS",@"顺丰快递"];
    PopUpSeletedView *showView=[[PopUpSeletedView alloc]initWithFrame:CGRectZero];
    //    [showView setSelectedAtIndex:self.seletedIndex];
    [showView resetWithSourceArray:dropArray];
    [showView showWithRect:CGRectMake(0, 64+10+40, DEF_SCREEN_WIDTH, dropArray.count*50) andEndChooseBlock:^(id data, NSInteger row) {
        [self.type setTitle:dropArray[row] forState:UIControlStateNormal];
        
    }];
    
}

-(void)choseTime
{
    [self.view endEditing:YES];
    ChoosePopupContentView * choosepopupContentView = [[ChoosePopupContentView alloc] initPopupViewWithType:ChoosePopupContentDateYYYYMMDD];
    choosepopupContentView.isJdAlert = YES;
    choosepopupContentView.bSureHandle = ^(NSDate * data){
        NSString * date = [data stringForNormalDataFormatter:@"YYYY-MM-dd"];
        
        [_timeBtn setTitle:date forState:UIControlStateNormal];
        
    };
    HLLPopupView * popupView = [HLLPopupView tipInWindow:choosepopupContentView];
    [popupView show:YES];
}

-(void)updateReturnOrder
{
    [self.view endEditing:YES];
    
    if (self.order.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请输入快递单号"];
        return;
    }
    if ([self.type.titleLabel.text isEqualToString:@"请选择"])
    {
        [UnityLHClass showHUDWithStringAndTime:@"请选择快递方式"];
        return;
    }
    if ([self.feeTf.text length] == 0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请输入运费"];
        return;
    }
    if ([_timeBtn.titleLabel.text length] == 0 || [_timeBtn.titleLabel.text isEqualToString:@"请选择发货时间"])
    {
        [UnityLHClass showHUDWithStringAndTime:@"请选择发货时间"];
        return;
    }
    
    [self updateSendSkuRequest];
}

#pragma mark --- 填写客户发运信息
-(void)updateSendSkuRequest
{
    /**
     afsServiceId     是     int     服务单号
     freightMoney     是     BigDecimal     运费
     expressCompany     是     string     发运公司 圆通快递、申通快递、韵达快递、中通快递、宅急送、EMS、顺丰快递
     deliverDate     是     string     发货日期 格式为yyyy-MM-dd HH:mm:ss
     expressCode     是     string     货运单号
     */
    NSString *time = [NSString stringWithFormat:@"%@ 00:00:00",_timeBtn.titleLabel.text];
    [UserServices jdAfterSellApplyUpdateSendSkuWithAfsServiceId:self.afsServiceId
                                                   freightMoney:self.feeTf.text
                                                 expressCompany:self.type.titleLabel.text
                                                    deliverDate:time
                                                    expressCode:self.order.text
                                                completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             [UnityLHClass showHUDWithStringAndTime:@"提交成功!"];
             [self sendObject:@"reload"];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
