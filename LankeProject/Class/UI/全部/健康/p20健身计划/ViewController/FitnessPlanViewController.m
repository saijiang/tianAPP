//
//  FitnessPlanViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessPlanViewController.h"
#import "FitnessPlanHeaderView.h"
#import "HealthPlanCell.h"
#import "HealthyVideoCell.h"

#import "FitnessPlanHistoryViewController.h"
#import "ChooseFavoriteSportsView.h"
#import "FitAddSportView.h"

// 身体情况自测
#import "HealthExamFirstStepViewController.h"
#import "MyHandRingViewController.h"

@interface FitnessPlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)FitnessPlanHeaderView *planHeaderView;
@property(nonatomic,strong)id dataSource;

@end

@implementation FitnessPlanViewController

-(void)fitnessPlan
{
    [UserServices
     fitnessPlanWithUserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             self.dataSource=responseObject[@"data"];
             
             [self.planHeaderView loadViewWithDataSource:self.dataSource];
             [SVProgressHUD showWithStatus:@"加载中....."];
             UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
             view.backgroundColor = [UIColor blackColor];
             view.alpha = 0.5;
             [[UIApplication sharedApplication].keyWindow addSubview:view];
             double delayInSeconds = 5.0;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^{
                 view.alpha = 0;
                 [SVProgressHUD dismiss];
                 [self.tableCtrl reloadData];
             });
          
             
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];

}

-(void)resetFitnessPaln
{
    [UserServices
     fitnessPlanWithUserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             self.dataSource=responseObject[@"data"];
             [self.planHeaderView loadViewWithDataSource:self.dataSource];
             [self.tableCtrl reloadData];
             //跳到身体情况自测的页面
             HealthExamFirstStepViewController *healthExam = [[HealthExamFirstStepViewController alloc]init];
             [self.navigationController pushViewController:healthExam animated:YES];
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

- (FitnessPlanHeaderView *)planHeaderView
{
    if (!_planHeaderView)
    {
        self.planHeaderView = [[FitnessPlanHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 370)];
        self.planHeaderView.backgroundColor=BM_WHITE;

    }
    return _planHeaderView;
}
- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"健身计划"];
    [self fitnessPlan];
    [self showRightBarButtonItemHUDByName:@"历史健身"];
    [self checkiIsConnected];

}

-(void)checkiIsConnected
{
//    if (![[LAKALABraceletManager sharedInstance] isConnected])
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"当前手环未绑定，是否去绑定手环？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
//            if (buttonIndex==1)
//            {
//                MyHandRingViewController *myhand=[[MyHandRingViewController alloc]init];
//                [self.navigationController pushViewController:myhand animated:YES];
//            }
//        }];
//    }
}

- (void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    self.tableCtrl.tableHeaderView=self.planHeaderView;
    WeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        [weakSelf fitnessPlan];
        [weakSelf.tableCtrl headerEndRefreshing];
    }];
    [self.planHeaderView receiveObject:^(id object) {
//        [self fitnessPlan];
        [self resetFitnessPaln];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataSource[@"HealthLiveList"] count]==0) {
        return 2;
    }
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return [self.dataSource[@"sportsPlanList"] count];
    }
    else if (section==1)
    {
        return [self.dataSource[@"customSportsPlanList"] count];
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2)
    {
        return 100;
    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        NSDictionary *data=self.dataSource[@"sportsPlanList"][indexPath.row];
        HealthPlanCell *cell=[HealthPlanCell cellWithTableView:tableView];
        cell.flag=@"01";
        [cell loadCellWithDataSource:data];
        [cell receiveObject:^(id object)
        {
            [self fitnessPlan];
        }];
        return cell;
    }
    else if (indexPath.section==1)
    {
        NSDictionary *data=self.dataSource[@"customSportsPlanList"][indexPath.row];
        HealthPlanCell *cell=[HealthPlanCell cellWithTableView:tableView];
        cell.flag=@"02";
        [cell loadCellWithDataSource:data];
        [cell receiveObject:^(id object)
         {
             [self fitnessPlan];
         }];
        return cell;
    }
    else
    {
        HealthyVideoCell *cell=[HealthyVideoCell cellWithTableView:tableView];
        [cell loadCellWithDataSource:self.dataSource[@"HealthLiveList"]];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerInSectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
    UIView *headeView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 40)];
    [headerInSectionView addSubview:headeView];
    headeView.backgroundColor=BM_WHITE;
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [headeView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *leftTitle=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [headeView addSubview:leftTitle];
    [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(headeView.mas_centerY);
    }];
    UIButton *rightButton=[UnityLHClass masonryButton:@"" font:14.0 color:BM_Color_Blue];
    [headeView addSubview:rightButton];
    rightButton.bottomlineWithColor=BM_Color_Blue;
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(headeView.mas_centerY);
        make.height.mas_equalTo(17);

    }];
    if (section==0)
    {
        leftTitle.text=@"今日健身智能计划";
        [rightButton setTitle:@"重置喜爱的运动" forState:UIControlStateNormal];
        rightButton.hidden=NO;
    }
    else if (section==1)
    {
        leftTitle.text=@"今日消耗卡路里手动添加";
        [rightButton setTitle:@"添加" forState:UIControlStateNormal];
        rightButton.hidden=NO;
    }
    else
    {
        leftTitle.text=@"其他人正在看";
        rightButton.hidden=YES;
    }
    
    [rightButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        if (section==0)
        {
            ChooseFavoriteSportsView *choose=[[ChooseFavoriteSportsView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 300)];
            choose.data=self.dataSource;
            [choose receiveObject:^(id object) {
                [self fitnessPlan];
            }];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:choose preferredStyle:TYAlertControllerStyleActionSheet];
            alertController.backgoundTapDismissEnable = YES;
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (section==1)
        {
            FitAddSportView *addSport=[[FitAddSportView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 300)];
            addSport.data=self.dataSource;
            [addSport receiveObject:^(id object) {
                [self fitnessPlan];

            }];
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:addSport preferredStyle:TYAlertControllerStyleActionSheet];
            alertController.backgoundTapDismissEnable = YES;
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];

    return headerInSectionView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
}


#pragma mark -
#pragma mark Navigat M

-(void)baseRightBtnAction:(UIButton *)btn
{
    FitnessPlanHistoryViewController *history=[[FitnessPlanHistoryViewController alloc]init];
    [self.topViewController.navigationController pushViewController:history animated:YES];
   
}

@end
