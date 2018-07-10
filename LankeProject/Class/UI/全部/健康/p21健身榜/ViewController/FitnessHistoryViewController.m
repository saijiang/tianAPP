//
//  FitnessHistoryViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessHistoryViewController.h"
#import "GridTableViewCell.h"
#import "GridHeaderContentView.h"

@interface FitnessHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * fitnessHistoryTableView;
//@property (nonatomic ,strong) NSArray * historyDatas;
@end

@implementation FitnessHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史健身数据";

    LKWeakSelf
    [self.fitnessHistoryTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.fitnessHistoryTableView addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];
    
    [self refresh];
}

- (void) createUI{
    
    self.fitnessHistoryTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.fitnessHistoryTableView.backgroundColor = [UIColor clearColor];
    self.fitnessHistoryTableView.delegate = self;
    self.fitnessHistoryTableView.dataSource = self;
    self.fitnessHistoryTableView.emptyDataSetSource = self;
    self.fitnessHistoryTableView.tableFooterView = [UIView new];
    self.fitnessHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.fitnessHistoryTableView.showsVerticalScrollIndicator = NO;
    self.fitnessHistoryTableView.rowHeight = [GridTableViewCell cellHeight];
    [self.fitnessHistoryTableView registerNib:[GridTableViewCell nib]
                       forCellReuseIdentifier:[GridTableViewCell cellIdentifier]];
    [self addSubview:self.fitnessHistoryTableView];
    
}

- (UIView *)headerView{
    
    GridHeaderContentView * headerView = [GridHeaderContentView view];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 200);
    [headerView configFitnessHistory:nil];
    [headerView setupContentView:^UIView *{
        
        LocalhostImageView * imageView = [[LocalhostImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"health_header_fitness_history"];
        return imageView;
    }];
    return headerView;
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.fitnessHistoryTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}



#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.responseDatas.count==0) {
        return 0;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.responseDatas.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GridTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[GridTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell configFitnessHistory:self.responseDatas[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark -
#pragma mark DZNEmptyDataSetSource

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

-(void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    // 历史健身数据接口
    [UserServices getFitnessPlanHistoryUserId:[KeychainManager readUserId] pageIndex:pageIndex pageSize:pageSize completionBlock:^(int result, id responseObject) {
        
        
        if (result == 0) {
            id data = responseObject[@"data"];
            
            [self responseDataList:data];
            
            if (self.pageItem.isRefresh) {
                
                [self.fitnessHistoryTableView headerEndRefreshing];
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                [self.fitnessHistoryTableView footerEndRefreshing];
            }
            [self.fitnessHistoryTableView reloadData];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
