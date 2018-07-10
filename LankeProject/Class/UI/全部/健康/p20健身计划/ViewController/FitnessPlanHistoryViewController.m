//
//  FitnessPlanHistoryViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessPlanHistoryViewController.h"
#import "FitnessPlanHistoryCell.h"
#import "FitnessReportViewController.h"
@interface FitnessPlanHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView *tableCtrl;

@end

@implementation FitnessPlanHistoryViewController

- (void) initiateNetworkListRequest
{
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    [UserServices
     getHistoryFitnessWithUserId:[KeychainManager readUserId]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             NSArray * data = responseObject[@"data"];
             [self responseDataList:data];
             if (self.pageItem.isRefresh)
             {
                 [self.tableCtrl headerEndRefreshing];
             }
             else
             {
                 if (!self.pageItem.canLoadMore)
                 {
                     [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 }
                 [self.tableCtrl footerEndRefreshing];
             }
             
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
    
    self.title = @"健身计划";
    [self refresh];
    LKWeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.tableCtrl addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];

}

- (void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    
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
        self.tableCtrl.emptyDataSetSource=self;
    }
    return _tableCtrl;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.responseDatas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FitnessPlanHistoryCell *cell=[FitnessPlanHistoryCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.section]];
    
    [cell.scan handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        FitnessReportViewController *report=[[FitnessReportViewController alloc]init];
        report.fitnessId=self.responseDatas[indexPath.section][@"id"];
        [self.navigationController pushViewController:report animated:YES];
    }];
    return cell;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
////    FitnessReportViewController *report=[[FitnessReportViewController alloc]init];
////    report.fitnessId=self.responseDatas[indexPath.section][@"id"];
////    [self.navigationController pushViewController:report animated:YES];
//}
#pragma mark -
#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -50);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}


@end
