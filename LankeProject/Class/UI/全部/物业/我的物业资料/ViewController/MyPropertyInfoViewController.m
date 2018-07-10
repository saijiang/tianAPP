//
//  MyPropertyInfoViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyPropertyInfoViewController.h"
//共用收货地址cell
#import "AddressCell.h"

@interface MyPropertyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableCtrl;
@property (nonatomic, strong) NSMutableArray *tableArr;

@end

@implementation MyPropertyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNavBarCustomByTitle:@"我的物业资料"];
    
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    LKWeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self refresh];

}

-(NSMutableArray *)tableArr
{
    if (!_tableArr)
    {
        _tableArr=[[NSMutableArray alloc]init];
    }
    return _tableArr;
}

-(UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.emptyDataSetSource = self;
        self.tableCtrl.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        self.tableCtrl.separatorStyle = 0;
    }
    
    return _tableCtrl;
}

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
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = BM_WHITE;
        
    }
    [cell configCellWithData:self.responseDatas[indexPath.section]];
    [cell receiveObject:^(id object) {
        [self refresh];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSeletedProperty) {
        [self sendObject:self.responseDatas[indexPath.section]];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark Network M

- (void)initiateNetworkListRequest{
    
    [UserServices
     getMypropertyWithUserId:[KeychainManager readUserId]
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
