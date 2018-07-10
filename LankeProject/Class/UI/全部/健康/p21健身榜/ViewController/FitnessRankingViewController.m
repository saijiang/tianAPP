//
//  FitnessRankingViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessRankingViewController.h"
#import "FitnessRankingCell.h"
#import "FitnessRankingHeaderView.h"
#import "FitnessHistoryViewController.h"
#import "FitnessRankingSegmentView.h"
#import "UIViewController+Page.h"

@interface FitnessRankingViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) FitnessRankingSegmentView * segmentView;
@property (nonatomic ,strong) UITableView * rankingTableView;

@end

@implementation FitnessRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本日健身榜";
    
    [self showRightBarButtonItemHUDByName:@"历史"];
    LKWeakSelf
    [self.rankingTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.rankingTableView addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];
    
    [self refresh];
}

- (void)createUI{

    LKWeakSelf
    self.segmentView = [FitnessRankingSegmentView new];
    self.segmentView.bSwitchOptionHandle = ^(NSInteger index){
        LKStrongSelf
        [_self refresh];
    };
    [self addSubview:self.segmentView];
    
    self.rankingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.rankingTableView.dataSource = self;
    self.rankingTableView.delegate = self;
    self.rankingTableView.emptyDataSetSource = self;
    self.rankingTableView.tableHeaderView = [self headerView];
    self.rankingTableView.tableHeaderView.hidden=YES;
    self.rankingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rankingTableView registerClass:[FitnessRankingCell class]
                  forCellReuseIdentifier:[FitnessRankingCell cellIdentifier]];
    self.rankingTableView.tableFooterView = [UIView new];
    [self addSubview:self.rankingTableView];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    [self.rankingTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(80);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (UIView *) headerView{
    
    FitnessRankingHeaderView * headerView = [FitnessRankingHeaderView view];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 200);
    headerView.bZanMySelfHandle = ^(){
        
    };
    WeakSelf
    headerView.bShareMineRankingHandle = ^(){
        
        UIImage *image=[weakSelf curentImage];
        [[UMManager sharedUMManager] shareTitle:@"本日健身榜" shareUrl:nil shareText:nil shareImage:image];
        
    };
    return headerView;
}

-(UIImage *)curentImage
{
    UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
    return viewImage;
}

- (void)baseRightBtnAction:(UIButton *)btn{

    FitnessHistoryViewController * history = [[FitnessHistoryViewController alloc] init];
    [self.navigationController pushViewController:history animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.responseDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FitnessRankingCell * cell = [tableView dequeueReusableCellWithIdentifier:[FitnessRankingCell cellIdentifier] forIndexPath:indexPath];
    self.rankingTableView.tableHeaderView.hidden=NO;
    id data = self.responseDatas[indexPath.row];
    [cell configCellWithData:data atIndexPath:indexPath];
    
    cell.bZanHandle = ^(FitnessRankingItem *item ,BOOL cancelZan){
        
        if (cancelZan) {
            [self requestUnZan:item];
        }else{
            [self requestZan:item];
        }
    };
    cell.bAttendHandle = ^(FitnessRankingItem *item ,BOOL cancelAttend){
        
        if (cancelAttend) {
            [self requestAttend:item];
        }else{
            [self requestUnAttend:item];
        }
    };
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [FitnessRankingCell cellHeight];
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
    
    [UserServices getFitnessPlanListWithUserId:[KeychainManager readUserId] type:self.segmentView.segmentType pageIndex:pageIndex pageSize:pageSize completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            id data = responseObject[@"data"][@"list"];
            
            NSMutableArray * temp = [NSMutableArray array];
            for (NSDictionary * item in data) {
                FitnessRankingItem * itemObj = [[FitnessRankingItem alloc] initItemWith:item];
                [temp addObject:itemObj];
            }
            
            [self responseDataList:temp];
            
            FitnessRankingHeaderView * headerView = (FitnessRankingHeaderView *)self.rankingTableView.tableHeaderView;
            [headerView config:responseObject[@"data"]];

            CGRect frame = headerView.frame;
            if ([responseObject[@"data"][@"rowNum"] integerValue] == 0) {
                frame.size.height = 100;
            }else{
                frame.size.height = 180;
            }
            headerView.frame = frame;
            
            if (self.pageItem.isRefresh) {
                
                [self.rankingTableView headerEndRefreshing];
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                [self.rankingTableView footerEndRefreshing];
            }
            [self.rankingTableView reloadData];
        }else{
            // error handle here
            if (self.pageItem.isRefresh) {
                
                [self.rankingTableView headerEndRefreshing];
            }else{
                
                [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                [self.rankingTableView footerEndRefreshing];
            }
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestZan:(FitnessRankingItem *)item{
    
    // 点赞接口
    [UserServices addClickWithUserId:[KeychainManager readUserId] concernedUserId:item.userId userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            id data = responseObject[@"data"];
            
            item.zanCount = [NSString stringWithFormat:@" %@",data];
            
            item.didZan = YES;
            [self.rankingTableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:100];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestUnZan:(FitnessRankingItem *)item{
    
    // 取消点赞接口
    [UserServices cancelClickWithUserId:[KeychainManager readUserId] concernedUserId:item.userId completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            id data = responseObject[@"data"];

            item.zanCount = [NSString stringWithFormat:@" %@",data];
            item.didZan = NO;
            [self.rankingTableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:100];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestAttend:(FitnessRankingItem *)item{
    
    // 关注接口
    [UserServices attentFriendWithUserId:[KeychainManager readUserId] concernedUserId:item.userId userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            item.hasAttention = YES;
            
            [self.rankingTableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:100];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestUnAttend:(FitnessRankingItem *)item{
    
    // 取消接口
    [UserServices cancelAttentFriendWithUserId:[KeychainManager readUserId] concernedUserId:item.userId completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            if ([self.segmentView.segmentType  isEqual: @"01"]) {
                [self refresh];
            }else{
            
                item.hasAttention = NO;
                [self.rankingTableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:100];
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
