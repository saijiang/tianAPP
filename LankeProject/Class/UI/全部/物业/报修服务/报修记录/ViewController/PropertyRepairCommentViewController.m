//
//  PropertyRepairCommentViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairCommentViewController.h"
#import "DishesDetailCommentCell.h"
#import "PropertyRepairCommentHeaderView.h"

@interface PropertyRepairCommentViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) PropertyRepairCommentHeaderView * headerView;
@property (nonatomic ,strong) UITableView * dishesDetailTableView;

@end

@implementation PropertyRepairCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价";

    [self refresh];
    
    LKWeakSelf
    [self.dishesDetailTableView addHeaderWithCallback:^{
        
        LKStrongSelf
        [_self refresh];
    }];
    [self.dishesDetailTableView addFooterWithCallback:^{
        
        LKStrongSelf
        [_self loadMore];
    }];
}

- (void) createUI{
    
    //
    _dishesDetailTableView = [[UITableView alloc] init];
    _dishesDetailTableView.dataSource = self;
    _dishesDetailTableView.delegate = self;
    _dishesDetailTableView.emptyDataSetSource = self;
    _dishesDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    footerView.backgroundColor = [UIColor clearColor];
    _dishesDetailTableView.tableFooterView = footerView;
    
    _dishesDetailTableView.tableHeaderView = [self tableHeaderView];
    
    _dishesDetailTableView.backgroundColor = [UIColor clearColor];
    [_dishesDetailTableView registerClass:[DishesDetailCommentCell class]
                   forCellReuseIdentifier:[DishesDetailCommentCell cellIdentifier]];
    
    [self addSubview:_dishesDetailTableView];
    
}

- (UIView *) tableHeaderView{

    self.headerView = [PropertyRepairCommentHeaderView view];
    self.headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 100);
    [self.headerView config:self.dataSource];
    return self.headerView;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [_dishesDetailTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
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
    
    return [DishesDetailCommentCell cellHeightWithData:self.responseDatas[indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishesDetailCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailCommentCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configForRepair:self.responseDatas[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        return;
    }
    //
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
     getRepairEvaluationWithRepairId:self.repairId
     repairUserId:self.dataSource[@"repairUserId"]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            id data = responseObject[@"data"];
            [self responseDataList:data];
            if (self.pageItem.isRefresh)
            {
                [self.dishesDetailTableView headerEndRefreshing];
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                [self.dishesDetailTableView footerEndRefreshing];
            }
            [self.dishesDetailTableView reloadData];
        }else{
            // error handle here
            if (self.pageItem.isRefresh) {
                
                [self.dishesDetailTableView headerEndRefreshing];
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                [self.dishesDetailTableView footerEndRefreshing];
            }
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
        

    }];
    
    
    
}

@end
