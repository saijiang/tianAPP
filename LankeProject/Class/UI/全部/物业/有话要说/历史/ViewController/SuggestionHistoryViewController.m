//
//  SuggestionHistoryViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SuggestionHistoryViewController.h"
#import "SuggestionHistoryCell.h"
#import "SuggestionHistoryImageCell.h"

@interface SuggestionHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * historyTableView;

@end

@implementation SuggestionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
}

- (void)createUI{

    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:self.historyTableView];
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.emptyDataSetSource = self;

    UIView * headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, 0, 0.1);
    [self.historyTableView setTableHeaderView:headerView];
    [self.historyTableView setTableFooterView:[UIView new]];
    [self.historyTableView registerClass:[SuggestionHistoryCell class]
                  forCellReuseIdentifier:[SuggestionHistoryCell cellIdentifier]];
    [self.historyTableView registerClass:[SuggestionHistoryImageCell class]
                  forCellReuseIdentifier:[SuggestionHistoryImageCell cellIdentifier]];
    
    LKWeakSelf
    [self.historyTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.historyTableView addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];
    
    [self refresh];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray*imageArr=self.responseDatas[indexPath.row][@"imageArr"];
    if (imageArr.count==0){
    return [SuggestionHistoryImageCell cellHeightWithData:self.responseDatas[indexPath.row]];
    }else{
        return [SuggestionHistoryCell cellHeightWithData:self.responseDatas[indexPath.row]];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSArray*imageArr=self.responseDatas[indexPath.row][@"imageArr"];
    if (imageArr.count==0) {
         SuggestionHistoryImageCell * cell = [tableView dequeueReusableCellWithIdentifier:[SuggestionHistoryImageCell cellIdentifier] forIndexPath:indexPath];
         [cell configCellWithData:self.responseDatas[indexPath.row]];
           return cell;
    }else{
           SuggestionHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:[SuggestionHistoryCell cellIdentifier] forIndexPath:indexPath];
         [cell configCellWithData:self.responseDatas[indexPath.row]];
           return cell;
    }
    
   
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -100);
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

- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    [UserServices
     getTopicComplainListWithUserId:[KeychainManager readUserId]
     districtId:[KeychainManager readDistrictId]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             id data = responseObject[@"data"];
             [self responseDataList:data];
             if (self.pageItem.isRefresh)
             {
                 [self.historyTableView headerEndRefreshing];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 [self.historyTableView footerEndRefreshing];
             }
             [self.historyTableView reloadData];
         }else{
             // error handle here
             if (self.pageItem.isRefresh) {
                 
                 [self.historyTableView headerEndRefreshing];
             }else{
                 
                 [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 [self.historyTableView footerEndRefreshing];
             }
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
         
     }];
    
    
}

@end
