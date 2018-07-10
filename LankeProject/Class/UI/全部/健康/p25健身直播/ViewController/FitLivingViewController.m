//
//  FitLivingViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/7/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitLivingViewController.h"
#import "FitCustomCell.h"
#import "FitLivingChooseTimeView.h"
#import "AdvDetailViewController.h"
@interface FitLivingViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>


@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) FitLivingChooseTimeView * topView;

@end

@implementation FitLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健身直播";
    [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"navigation_bar_call"]];
    //初始化选择条
    [self configTopView];
    [self configTableView];
    [self refresh];

}

#pragma mark -- 初始化选择条
-(void)configTopView
{
    self.topView = [[FitLivingChooseTimeView alloc]init];
    self.topView.backgroundColor = BM_WHITE;
    [self.view addSubview:self.topView];
    [self.topView receiveObject:^(id object) {
        [self refresh];
    }];
   
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(50);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.topView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
}

#pragma mark -- 初始化collectionview
-(void)configTableView
{
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[FitCustomCell class] forCellReuseIdentifier:@"FitCustomCell"];
    [self addSubview:_tableView];
    LKWeakSelf
    [self.tableView addHeaderWithCallback:^{
        
        LKStrongSelf
        [_self refresh];
    }];
    [self.tableView addFooterWithCallback:^{
        
        LKStrongSelf
        [_self loadMore];
    }];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.responseDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [FitCustomCell getCellHeightWithDataSource:self.responseDatas[indexPath.section]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FitCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FitCustomCell" forIndexPath:indexPath];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.section]];
    [cell.stateBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if ([cell.stateBtn.titleLabel.text isEqualToString:@"预约"])
        {
            //调接口
            [self requestAddHealthAppointWithLiveId:self.responseDatas[indexPath.section][@"id"]];
              [cell.stateBtn setTitle:@"已预约" forState:UIControlStateNormal];
        }
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AdvDetailViewController *adv=[[AdvDetailViewController alloc]init];
    adv.advType=3;
    adv.externalUrl=self.responseDatas[indexPath.section][@"liveAddress"];
    adv.title=self.responseDatas[indexPath.section][@"title"];
    [self.navigationController pushViewController:adv animated:YES];
}
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



#pragma mark -- 逻辑处理
#pragma amrk --- 拨打电话
- (void)baseRightBtnAction:(UIButton *)btn{
    
    [UnityLHClass callTel:@"010-68118899"];
}

#pragma marlk -- 请求数据
#pragma mark Network M

- (void) initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    // 健身直播接口
    [UserServices getHealthFitnessNewListWithUserId:[KeychainManager readUserId]
                                          startTime:self.topView.startTime
                                            endTime:self.topView.endTime
                                          pageIndex:pageIndex
                                           pageSize:pageSize
                                    completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            [self responseDataList:responseObject[@"data"]];
            if (self.pageItem.isRefresh) {
                [self.tableView headerEndRefreshing];
            }else{
                
                if (!self.pageItem.canLoadMore) {
                    [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                }
                [self.tableView footerEndRefreshing];
            }
            
            [self.tableView reloadData];
            
        }else{
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
        
    }];
}

//预约接口
- (void) requestAddHealthAppointWithLiveId:(NSString *)liveId{
    
    // 预约接口
    [UserServices addHealthAppointWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] healthLiveId:liveId completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            //id data = responseObject[@"data"];
            
            [self initiateNetworkListRequest];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
