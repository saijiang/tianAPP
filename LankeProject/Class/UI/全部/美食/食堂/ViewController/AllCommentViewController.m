//
//  AllCommentViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AllCommentViewController.h"
#import "DishesDetailCommentCell.h"
#import "UIViewController+Page.h"

@interface AllCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * dishesDetailTableView;

@end

@implementation AllCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论列表";
    
    [self creatUI];
    
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

- (void) creatUI{
    
    //
    _dishesDetailTableView = [[UITableView alloc] init];
    _dishesDetailTableView.dataSource = self;
    _dishesDetailTableView.delegate = self;
    _dishesDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    footerView.backgroundColor = [UIColor clearColor];
    _dishesDetailTableView.tableFooterView = footerView;
    
    _dishesDetailTableView.tableHeaderView = [UIView new];
    
    _dishesDetailTableView.backgroundColor = [UIColor clearColor];
    [_dishesDetailTableView registerClass:[DishesDetailCommentCell class]
                   forCellReuseIdentifier:[DishesDetailCommentCell cellIdentifier]];
    
    [self addSubview:_dishesDetailTableView];
    
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [_dishesDetailTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(5);
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
    
    [cell configCellWithData:self.responseDatas[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return;
    }
    //
}

#pragma mark -
#pragma mark Network M

- (void)initiateNetworkListRequest{
    
    if (self.isJD)
    {
        [self getJDGoodsEvaluationListRequest];
    }
    else
    {
        NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
        NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
        
        [UserServices evaluationListWithDishesId:self.dishesId pageIndex:pageIndex pageSize:pageSize completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                
                NSArray * data = responseObject[@"data"][@"list"];
                
                [self responseDataList:data];
                if (self.pageItem.isRefresh) {
                    [self.dishesDetailTableView headerEndRefreshing];
                }else{
                    
                    if (!self.pageItem.canLoadMore) {
                        [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                    }
                    [self.dishesDetailTableView footerEndRefreshing];
                }
                
                [self.dishesDetailTableView reloadData];
                
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
    
}

#pragma mark --- 京东商品评论列表请求
-(void)getJDGoodsEvaluationListRequest
{
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
   [UserServices jdGoodsEvaluateGoodsEvaluationListWithGoodsId:self.dishesId
                                                     pageIndex:pageIndex
                                                      pageSize:pageSize
                                               completionBlock:^(int result, id responseObject)
    {
        if (result == 0) {
            
            NSArray * data = responseObject[@"data"][@"result"];
            
            [self responseDataList:data];
            if (self.pageItem.isRefresh) {
                [self.dishesDetailTableView headerEndRefreshing];
            }else{
                
                if (!self.pageItem.canLoadMore) {
                    [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                }
                [self.dishesDetailTableView footerEndRefreshing];
            }
            
            [self.dishesDetailTableView reloadData];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
