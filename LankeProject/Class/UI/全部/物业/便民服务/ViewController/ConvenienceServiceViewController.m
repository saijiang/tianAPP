//
//  ConvenienceServiceViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ConvenienceServiceViewController.h"
//cell
#import "ConServiceCustomCell.h"
//详情
#import "ConvenirntDetailViewController.h"

#import "MyPropertyInfoViewController.h"

@interface ConvenienceServiceViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView *tableCtrl;

@end

@implementation ConvenienceServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"便民服务";
    
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
#pragma mark -- 懒加载
- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.emptyDataSetSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}

#pragma mark ----- tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.responseDatas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConServiceCustomCell *cell=[ConServiceCustomCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.section]];
    [cell.serviceCallBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [UnityLHClass callTel:self.responseDatas[indexPath.section][@"merchantMobile"]];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConvenirntDetailViewController *detail = [[ConvenirntDetailViewController alloc]init];
    detail.merchantId=self.responseDatas[indexPath.section][@"id"];
    [self.navigationController pushViewController:detail animated:YES];
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
     getDistrictMerchantListWithDistrictId:[KeychainManager readlocalDistrictId]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             id data = responseObject[@"data"];
             [self responseDataList:data];
             if (self.pageItem.isRefresh)
             {
                 [self.tableCtrl headerEndRefreshing];
             }
             else
             {
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
