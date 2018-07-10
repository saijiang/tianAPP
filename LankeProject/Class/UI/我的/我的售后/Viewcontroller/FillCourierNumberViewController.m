//
//  FillCourierNumberViewController.m
//  LankeProject
//
//  Created by itman on 17/1/20.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FillCourierNumberViewController.h"
#import "JYZTextView.h"
#import "PopUpSeletedView.h"
@interface FillCourierNumberViewController ()

@property(nonatomic,strong)UITextField *order;
@property(nonatomic,strong)UIButton *type;
@property(nonatomic,assign)NSInteger seletedIndex;
@property(nonatomic,assign)NSInteger seletedType;

@end

@implementation FillCourierNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.seletedIndex=0;
    self.seletedType=0;
    [self showNavBarCustomByTitle:@"填写快递单号"];
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
        make.height.mas_equalTo(122);
    }];
    
    
    UIButton *leftOnebutton=[UnityLHClass masonryButton:@"  请选择" font:15.0 color:BM_BLACK];
    [leftOnebutton setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
    [leftOnebutton setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];

    [topView addSubview:leftOnebutton];
    [leftOnebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
    
    UIButton  *goImage=[UnityLHClass masonryButton:@"" imageStr:@"right_arrow" font:15.0 color:BM_BLACK];
    [topView addSubview:goImage];
    [goImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(leftOnebutton.mas_centerY);
    }];
    [goImage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
        
    }];
    
    self.type=[UnityLHClass masonryButton:@"请选择" imageStr:@"" font:15.0 color:BM_BLACK];
    [topView addSubview:self.type];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImage.mas_left).offset(-5);
        make.centerY.mas_equalTo(leftOnebutton.mas_centerY);
    }];
    [self.type handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftOnebutton.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(leftOnebutton.mas_left);
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
        make.left.mas_equalTo(leftOnebutton.mas_left);
        make.right.mas_equalTo(goImage.mas_right);
        
    }];
    
    UIButton *leftTwobutton=[UnityLHClass masonryButton:@"  其他（用户自送或者商家上门取货）" font:15.0 color:BM_BLACK];
    [leftTwobutton setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
    [leftTwobutton setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
    
    [topView addSubview:leftTwobutton];
    [leftTwobutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(twoline.mas_bottom);
    }];

    
    UIButton *submitButton=[UnityLHClass masonryButton:@"提交申请" font:15.0 color:BM_WHITE];
    submitButton.layer.masksToBounds=YES;
    submitButton.layer.cornerRadius=5;
    submitButton.backgroundColor=[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
    submitButton.frame=CGRectMake(15, 200, DEF_SCREEN_WIDTH-15*2, 40);
    [self addSubview:submitButton];
    [submitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self updateReturnOrder];
    }];
    self.contentView.contentSize=CGSizeMake(0, DEF_BOTTOM(submitButton)+30);
    
    leftOnebutton.selected=YES;
    [leftOnebutton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        leftOnebutton.selected=YES;
        leftTwobutton.selected=NO;
        self.seletedType=0;

    }];
    
    [leftTwobutton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        leftOnebutton.selected=NO;
        leftTwobutton.selected=YES;
        self.seletedType=1;

    }];

    
}
-(void)showDropDownView
{
//    NSArray *dropArray=@[@{@"code":@"shunfeng",@"name":@"顺丰快递"},
//                         @{@"code":@"ems",@"name":@"邮政EMS"},
//                         @{@"code":@"shentong",@"name":@"申通快递"},
//                         @{@"code":@"yuantong",@"name":@"圆通速递"},
//                         @{@"code":@"zhongtong",@"name":@"中通快递"},
//                         @{@"code":@"huitongkuaidi",@"name":@"百世汇通"},
//                         @{@"code":@"yunda",@"name":@"韵达快递"},
//                         ];
    NSArray *dropArray=@[@"顺丰快递",@"邮政EMS",@"申通快递",@"圆通速递",@"中通快递",@"百世汇通",@"韵达快递"];
    PopUpSeletedView *showView=[[PopUpSeletedView alloc]initWithFrame:CGRectZero];
//    [showView setSelectedAtIndex:self.seletedIndex];
    [showView resetWithSourceArray:dropArray];
    [showView showWithRect:CGRectMake(0, 64+10+40, DEF_SCREEN_WIDTH, dropArray.count*50) andEndChooseBlock:^(id data, NSInteger row) {
        [self.type setTitle:dropArray[row] forState:UIControlStateNormal];

    }];
   
}

-(void)updateReturnOrder
{
    if (self.seletedType==0)
    {
        if (self.order.text.length==0)
        {
            [UnityLHClass showHUDWithStringAndTime:@"请输入快递单号"];
        }
        else
        {
            if ([self.type.titleLabel.text isEqualToString:@"请选择"])
            {
                [UnityLHClass showHUDWithStringAndTime:@"请选择快递方式"];
                return;
            }
            [UserServices
             updateReturnOrderWithOrderId:self.orderId
             deliveryCompanyName:self.type.titleLabel.text
             deliverySn:self.order.text
             completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
                 {
                     [self sendObject:@"reload"];
                     [self.navigationController popViewControllerAnimated:YES];
//                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     
                 }
                 else
                 {
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 }
             }];
            
        }

    }
    else
    {
        [UserServices
         updateReturnOrderWithOrderId:self.orderId
         deliveryCompanyName:nil
         deliverySn:nil
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 [self sendObject:@"reload"];
                 [self.navigationController popViewControllerAnimated:YES];
//                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
        
    }
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
