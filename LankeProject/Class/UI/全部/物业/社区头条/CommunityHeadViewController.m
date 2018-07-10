//
//  CommunityHeadViewController.m
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHeadViewController.h"
#import "CommunityHeadCell.h"
#import "CommunityHeadInfoViewController.h"
@interface CommunityHeadViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
{
    NSMutableArray *tableArray;
}

@property (nonatomic,strong)UITableView *tableCtrl;

@end

@implementation CommunityHeadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"社区头条";
    tableArray=[[NSMutableArray alloc]init];
    [self loadTableCtrl];
}
-(void)loadTableCtrl
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    LKWeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.tableCtrl addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];
    [self refresh];

}

- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.emptyDataSetSource=self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommunityHeadCell getCellHightWithDataSource:self.responseDatas[indexPath.row] tableView:tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityHeadCell *cell=[CommunityHeadCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityHeadInfoViewController *info=[[CommunityHeadInfoViewController alloc]init];
    info.titleId=self.responseDatas[indexPath.row][@"id"];
    [self.navigationController pushViewController:info animated:YES];
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
     getNoticeAnnounceWithDistrictId:[KeychainManager readlocalDistrictId]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             id data = responseObject[@"data"];
             
            [self responseDataList:data];
             
            if (self.pageItem.isRefresh) {
                 
                 [self.tableCtrl headerEndRefreshing];
             }else{
                 
                 [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 [self.tableCtrl footerEndRefreshing];
             }
             [self.tableCtrl reloadData];
         }else{
             // error handle here
             if (self.pageItem.isRefresh) {
                 
                 [self.tableCtrl headerEndRefreshing];
             }else{
                 
                 [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 [self.tableCtrl footerEndRefreshing];
             }
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }

    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
