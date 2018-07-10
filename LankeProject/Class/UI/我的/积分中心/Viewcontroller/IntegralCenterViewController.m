//
//  IntegralCenterViewController.m
//  LankeProject
//
//  Created by itman on 17/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//
#import "IntegralCenterViewController.h"
#import "ExpenseCell.h"
@interface IntegralCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dataSource;
}
@property (nonatomic, strong) UITableView *tableCtrl;
@property (nonatomic, strong) UIView *changeView;
@property (nonatomic ,strong) UITextField * jifenTextField;
@property (nonatomic ,strong) UILabel * lable1;
@property (nonatomic ,strong) UILabel * lable2;
@property (nonatomic ,strong) UILabel * lable3;
@property (nonatomic ,strong) UILabel * lable4;

@end

@implementation IntegralCenterViewController

-(void)getIntegralDetai
{
    [UserServices
     getIntegralDetailWithUserId:[KeychainManager readUserId]
     pageIndex:@"1"
     pageSize:@"10000"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             dataSource=responseObject[@"data"];
             [self.tableCtrl reloadData];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"积分中心"];
    [self initUI];
    [self getIntegralDetai];
    [self createExchangeView];
    
}

- (void)initUI
{
    self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, DEF_SCREEN_WIDTH, DEF_CONTENT - 15) style:UITableViewStyleGrouped];
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.separatorStyle = 0;
    self.tableCtrl.backgroundColor = BM_CLEAR;
    [self.view addSubview:self.tableCtrl];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource[@"list"] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 150)];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
    topView.userInteractionEnabled=YES;
    topView.backgroundColor = BM_WHITE;
    [baseView addSubview:topView];
    
    NSString *integral=[NSString stringWithFormat:@"当前积分：%@",dataSource[@"total"]];
    UILabel *integralLB = [UnityLHClass masonryLabel:integral font:15 color:BM_RED];
    [topView addSubview:integralLB];
    [integralLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH/2);
    }];
    
    UIButton*changeBtn=[[UIButton alloc]init];
    [changeBtn setTitle:@"兑换i币" forState:UIControlStateNormal];
    changeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [changeBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
    changeBtn.frame=CGRectMake(DEF_SCREEN_WIDTH-100, 10, 80, 30);
    changeBtn.layer.masksToBounds=YES;
    changeBtn.layer.cornerRadius=5;
    changeBtn.backgroundColor=BM_Color_Blue;
    [topView addSubview:changeBtn];
    
    [changeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        self.changeView.hidden=NO;
        [self sentData:dataSource];
        self.jifenTextField.text = @"";
        
    }];
    
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, DEF_SCREEN_WIDTH, 50)];
    [baseView addSubview:centerView];
    UILabel *mingxiLB = [UnityLHClass masonryLabel:@"积分明细" font:15 color:BM_BLACK];
    [centerView addSubview:mingxiLB];
    [mingxiLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(centerView.mas_centerY);
    }];
    
    UIView *bottomView =[[UIView alloc] initWithFrame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = BM_WHITE;
    [baseView addSubview:bottomView];
    
    UILabel *nameLB = [UnityLHClass masonryLabel:@"项目" font:16.5 color:[UIColor colorWithHexString:@"#333333"]];
    nameLB.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:nameLB];
    
    UILabel *timeLB = [UnityLHClass masonryLabel:@"时间" font:16.5 color:[UIColor colorWithHexString:@"#333333"]];
    timeLB.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:timeLB];
    
    UILabel *priceLB = [UnityLHClass masonryLabel:@"积分" font:16.5 color:[UIColor colorWithHexString:@"#333333"]];
    priceLB.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:priceLB];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [bottomView addSubview:line];
    
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.3);
        make.left.offset(0);
        make.height.mas_equalTo(bottomView.mas_height);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
    }];
    
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.4);
        make.left.mas_equalTo(nameLB.mas_right);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(bottomView.mas_height);
    }];
    
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bottomView.mas_width).multipliedBy(0.3);
        make.right.offset(0);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(bottomView.mas_height);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        make.height.offset(0.8);
    }];
    
    
    return baseView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50*3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    ExpenseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[ExpenseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = BM_WHITE;
    }
    NSDictionary *data=dataSource[@"list"][indexPath.row];
    cell.nameLB.text = @"注册";
    switch ([data[@"integralType"] integerValue])
    {
        case 1:
        {
            cell.nameLB.text = @"注册";
            
        }
            break;
        case 2:
        {
            cell.nameLB.text = @"登录";
            
        }
            break;
        case 3:
        {
            cell.nameLB.text = @"消费";
            
        }
            break;
        case 4:
        {
            cell.nameLB.text = @"健身计划";
            
        }
            break;
        case 5:
        {
            cell.nameLB.text = @"积分兑换";
           
        }
        break;
        
        default:
            break;
    }
    cell.timeLB.text = [[NSString stringWithFormat:@"%@",data[@"integralTime"]] stringformatterDate:@"yyyy/MM/dd HH:mm"];
    if ([data[@"integralType"] integerValue]==5) {
        cell.priceLB.textColor=BM_RED;
         cell.priceLB.text = [NSString stringWithFormat:@"-%@",data[@"integralNum"]];
    }else{
    cell.priceLB.textColor=[UIColor colorWithRed:0.56 green:0.88 blue:0.65 alpha:1];
    cell.priceLB.text = [NSString stringWithFormat:@"＋%@",data[@"integralNum"]];
    }
    
    return cell;
}

-(void)createExchangeView
{
    self.changeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    self.changeView.hidden=YES;
    self.changeView.userInteractionEnabled=YES;
    self.changeView.backgroundColor=BM_Color_GrayColor;
    [[UIApplication sharedApplication].keyWindow addSubview:self.changeView];
    
    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(30, 0, DEF_SCREEN_WIDTH-60, DEF_SCREEN_WIDTH-80)];
    bgView.centerY=self.changeView.centerY-30;
    bgView.userInteractionEnabled=YES;
    bgView.backgroundColor=BM_WHITE;
    [self.changeView addSubview:bgView];
    
    UILabel*titleLable=[UnityLHClass masonryLabel:@"兑换i币" font:16 color:BM_WHITE];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.backgroundColor=BM_Color_Blue;
    [bgView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    self.lable1=[UnityLHClass masonryLabel:@"积分" font:15 color:BM_BLACK];
    [bgView addSubview:self.lable1];
    [self.lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(titleLable.mas_bottom).offset(50);
    }];
    
    self.jifenTextField=[[UITextField alloc]init];
    self.jifenTextField.font=[UIFont systemFontOfSize:14];
    self.jifenTextField.text = @"";
    self.jifenTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    
    self.jifenTextField.leftViewMode = UITextFieldViewModeAlways;
    self.jifenTextField.placeholder=@"请输入积分";
    self.jifenTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [bgView addSubview:self.jifenTextField];
    self.jifenTextField.layer.masksToBounds=YES;
    self.jifenTextField.layer.cornerRadius=5;
    self.jifenTextField.layer.borderWidth=1.0f;
    self.jifenTextField.layer.borderColor=BM_Color_LineColor.CGColor;
    [  self.jifenTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lable1.mas_right).offset(5);
        make.centerY.mas_equalTo(self.lable1.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [ self.jifenTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    self.lable2=[UnityLHClass masonryLabel:@"可兑换0个i币" font:14 color:BM_BLACK];
    [bgView addSubview:   self.lable2];
    [self.lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jifenTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.lable1.mas_centerY);
    }];
    
    self.lable3=[UnityLHClass masonryLabel:@"" font:14 color:BM_GRAY];
    [bgView addSubview: self.lable3];
    [ self.lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.jifenTextField.mas_bottom).offset(20);
    }];
    
    self.lable4=[UnityLHClass masonryLabel:@"注:" font:14 color:BM_RED];
    [bgView addSubview:self.lable4];
    [self.lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo( self.lable3.mas_left);
        make.top.mas_equalTo( self.lable3.mas_bottom).offset(20);
        
    }];
    
    
    
    UIButton*makeSureBtn=[UnityLHClass masonryButton:@"确认兑换" font:15 color:BM_WHITE];
    makeSureBtn.layer.masksToBounds=YES;
    makeSureBtn.layer.cornerRadius=5;
    makeSureBtn.backgroundColor=BM_Color_Blue;
    [bgView addSubview:makeSureBtn];
    
    [makeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lable4.mas_left);
        make.top.mas_equalTo(self.lable4.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        
    }];
    [makeSureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self submmJiFen];
        [self.jifenTextField resignFirstResponder];

    }];
    
    UIButton*cancelBtn=[UnityLHClass masonryButton:@"取消" font:15 color:BM_WHITE];
    cancelBtn.layer.masksToBounds=YES;
    cancelBtn.layer.cornerRadius=5;
    cancelBtn.backgroundColor=BM_Color_huiColor;
    [bgView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(self.lable4.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        
    }];
    [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.changeView.hidden=YES;
        [self.jifenTextField resignFirstResponder];
    }];
}
-(void)sentData:(id)data
{
    self.lable3.text=[NSString stringWithFormat:@"最多输入%@",data[@"total"]];
    self.lable4.text=[NSString stringWithFormat:@"注:%@积分兑换一个i币",self.dataArray[@"parameterValue"]];
    
    
    NSLog(@"%@",data);
    
}
-(void)valueChanged:(UITextField*)changefield
{
    NSString*str=[self.lable3.text substringFromIndex:4];
    
    
    if ([str integerValue]<[changefield.text integerValue]) {
        self.jifenTextField.text=str;
    }else{
        self.jifenTextField.text=changefield.text;
    }
    //    self.lable2.text=[NSString stringWithFormat:@"可兑换%ldi币",[changefield.text integerValue]/20 ];
    self.lable2.text=[NSString stringWithFormat:@"可兑换%ldi币",[changefield.text integerValue]/[self.dataArray[@"parameterValue"] integerValue] ];
}
-(void)submmJiFen
{
    [ UserServices getIntegraljifenWithUserId:self.dataArray[@"userId"] point:self.jifenTextField.text completionBlock:^(int result, id responseObject) {
        if (result==0)
        {
              [self getIntegralDetai];
            self.changeView.hidden=YES;
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
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
