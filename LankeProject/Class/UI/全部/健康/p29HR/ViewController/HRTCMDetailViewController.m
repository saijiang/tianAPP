//
//  HRTCMDetailViewController.m
//  LankeProject
//
//  Created by admin on 2017/10/25.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRTCMDetailViewController.h"
#import "HRTCMDetailCell.h"
#import "HRTCMDetailHeaderView.h"
@interface HRTCMDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * tcmTableView;

@property (nonatomic ,strong) NSMutableArray * tcmList;

@property (nonatomic ,strong) HRTCMDetailHeaderView * headerView;

@end

@implementation HRTCMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工中医体质检测情况";
    
    self.tcmList = [NSMutableArray array];
    
    [self requestHRIllInfo];
}

- (void) createUI{
    
    self.tcmTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tcmTableView.backgroundColor = [UIColor clearColor];
    self.tcmTableView.delegate = self;
    self.tcmTableView.dataSource = self;
    self.tcmTableView.tableFooterView = [UIView new];
    self.tcmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tcmTableView.showsVerticalScrollIndicator = NO;
    self.tcmTableView.emptyDataSetSource=self;
    [self addSubview:self.tcmTableView];
    
}

- (HRTCMDetailHeaderView *)headerView{
    
    if (!_headerView)
    {
        _headerView = [[HRTCMDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
    }
    return _headerView;
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.tcmTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tcmList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRTCMDetailCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HRTCMDetailCell*cell=[HRTCMDetailCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.tcmList[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
#pragma mark -
#pragma mark Network M

- (void) requestHRIllInfo{
    
    // hr中医体质检测情况详情
    
    [UserServices getPhysiquePerDetailWithUserId:[KeychainManager readUserId] physiqueType:self.dicData[@"physicalType"] completionBlock:^(int result, id responseObject) {
        if (result == 0)
        {
            id data = responseObject[@"data"];
      
            [self.tcmList removeAllObjects];
            if (data)
            {
                [self.tcmList addObjectsFromArray:data];
            }
            [self.tcmTableView reloadData];
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }

    }];
    }


@end
