//
//  HRDailyFitnessViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRDailyFitnessViewController.h"
#import "HRDailFitnessCell.h"
#import "HRDailFitnessHeaderView.h"
#import "HRDailyFitnessDetailViewController.h"

@interface HRDailyFitnessViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * dailyFitnessTableView;
@property (nonatomic ,assign) NSString * fitnessDate;
@property (nonatomic ,strong) HRDailFitnessHeaderView *headerView;
@end

@implementation HRDailyFitnessViewController

- (void) initiateNetworkListRequest
{
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    
   [ UserServices getStepNumListWithUserId:[KeychainManager readUserId] startTime:_headerView.statrTimeStr endTime:_headerView.endTimeStr pageIndex:pageIndex pageSize:pageSize completionBlock:^(int result, id responseObject) {
       if (result==0)
       {
           NSArray * data = responseObject[@"data"];
           [self responseDataList:data];
           if (self.pageItem.isRefresh)
           {
               [self.dailyFitnessTableView headerEndRefreshing];
           }
           else
           {
               if (!self.pageItem.canLoadMore)
               {
                   [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
               }
               [self.dailyFitnessTableView footerEndRefreshing];
           }
           
           [self.dailyFitnessTableView reloadData];
       }
       else
       {
           [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
       }

   }];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日健身情况";
    
}

- (void) createUI{
    
     _headerView = [[HRDailFitnessHeaderView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 150)];
    [self addSubview:_headerView];
    [_headerView receiveObject:^(id object) {
          [self refresh];
    }];
    self.dailyFitnessTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.dailyFitnessTableView.backgroundColor = [UIColor clearColor];
    self.dailyFitnessTableView.delegate = self;
    self.dailyFitnessTableView.dataSource = self;
    self.dailyFitnessTableView.tableFooterView = [UIView new];
    self.dailyFitnessTableView.emptyDataSetSource=self;
    self.dailyFitnessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dailyFitnessTableView.showsVerticalScrollIndicator = NO;
   //self.dailyFitnessTableView.tableHeaderView =_headerView;
   
    [self addSubview:self.dailyFitnessTableView];
    
    [self refresh];
    LKWeakSelf
    [self.dailyFitnessTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.dailyFitnessTableView addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];

}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.dailyFitnessTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(160);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.responseDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRDailFitnessCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HRDailFitnessCell*cell=[HRDailFitnessCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRDailyFitnessDetailViewController*detail=[[HRDailyFitnessDetailViewController alloc]init];
    detail.dicData=self.responseDatas[indexPath.row];
    detail.statrTimeStr=self.headerView.statrTimeStr;
    detail.endTimeStr=self.headerView.endTimeStr;
    [self.navigationController pushViewController:detail animated:YES];
}

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
