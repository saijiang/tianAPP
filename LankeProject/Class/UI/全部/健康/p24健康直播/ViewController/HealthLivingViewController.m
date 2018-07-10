//
//  HealthLivingViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthLivingViewController.h"
#import "UIViewController+Page.h"
#import "HealthLivingCell.h"
#import "AdvDetailViewController.h"
@interface HealthLivingViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * healthLivingTableView;

@property (nonatomic ,assign) NSInteger testIndex;
@end

@implementation HealthLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"健康直播";
    
    self.testIndex = 0;
    
    [self refresh];
    
    LKWeakSelf
    [self.healthLivingTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
//    [self.healthLivingTableView addFooterWithCallback:^{
//        LKStrongSelf
//        [_self loadMore];
//    }];
}

- (void)createUI{

    self.healthLivingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT) style:UITableViewStyleGrouped];
    self.healthLivingTableView.delegate = self;
    self.healthLivingTableView.dataSource = self;
    self.healthLivingTableView.emptyDataSetSource = self;
    self.healthLivingTableView.separatorStyle = 0;
    self.healthLivingTableView.backgroundColor = BM_CLEAR;
//    self.healthLivingTableView.estimatedRowHeight = 300;
    [self.healthLivingTableView registerClass:[HealthLivingCell class] forCellReuseIdentifier:[HealthLivingCell cellIdentifier]];
    [self addSubview:self.healthLivingTableView];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    [self.healthLivingTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(0);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.testIndex;
    return self.responseDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HealthLivingCell cellHeightWithData:self.responseDatas[indexPath.section]];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 300;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthLivingCell * cell = [tableView dequeueReusableCellWithIdentifier:[HealthLivingCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configCellWithData:self.responseDatas[indexPath.section]];
    
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

- (void) initiateNetworkListRequest{
    
//    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
//    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    [UserServices healthLivingListCompletionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            
            NSArray * data = responseObject[@"data"];
            [self responseDataList:data];

            if (self.pageItem.isRefresh) {
                
                [self.healthLivingTableView headerEndRefreshing];
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                [self.healthLivingTableView footerEndRefreshing];
            }
            
            [self.healthLivingTableView reloadData];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }

    }];
}

@end
