//
//  AfterSalesOrderViewController.m
//  LankeProject
//
//  Created by itman on 17/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "AfterSalesOrderViewController.h"
#import "AfterSalesOrderCell.h"
#import "FillCourierNumberViewController.h"
#import "DQAlertViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AfterSalesOrderViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
{
    NSArray *dataSource;
}
@property (nonatomic, strong) UITableView *tableCtrl;
@end

@implementation AfterSalesOrderViewController

-(void)getReturnOrder
{
    [UserServices
     getReturnOrderWithUserId:[KeychainManager readUserId]
     pageIndex:@"1"
     pageSize:@"10000"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             dataSource=responseObject[@"data"];
             [self.tableCtrl reloadData];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"售后订单"];
    [self initUI];
    [self getReturnOrder];
    
}

- (void)initUI
{
    self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT) style:UITableViewStyleGrouped];
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.emptyDataSetSource=self;
    self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableCtrl addHeaderWithCallback:^{
        [self getReturnOrder];
        [self.tableCtrl headerEndRefreshing];

    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
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
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float hight=[AfterSalesOrderCell getCellWithDataSource:dataSource[indexPath.section]];
    return hight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AfterSalesOrderCell *cell=[AfterSalesOrderCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:dataSource[indexPath.section]];
    [cell receiveObject:^(id object)
    {
        DEF_DEBUG(@"%@",object);
        if ([object isEqualToString:@"  删除订单  "])
        {
            DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"是否删除订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    [self deleteReturnOrderWithOrderId:dataSource[indexPath.section][@"id"]];
                }
            }];
            [alert showAlert:self];
        }
        else
        {
            //填写快递单号
            FillCourierNumberViewController *fill=[[FillCourierNumberViewController alloc]init];
            fill.orderId=dataSource[indexPath.section][@"id"];
            [self.navigationController pushViewController:fill animated:YES];
            [fill receiveObject:^(id object) {
                [self getReturnOrder];
            }];
        }
       
    }];
    return cell;
}
-(void)deleteReturnOrderWithOrderId:(NSString *)orderId
{
    [UserServices
     deleteReturnOrderWithOrderId:orderId
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self getReturnOrder];
         }
         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
    }];
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
