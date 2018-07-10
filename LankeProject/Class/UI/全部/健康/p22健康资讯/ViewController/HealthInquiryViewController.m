//
//  HealthInquiryViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HealthInquiryViewController.h"
#import "HeadlthInqurylCell.h"
#import "HealthDetailViewController.h"
#import "UIViewController+Page.h"

@interface HealthInquiryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableCtrl;

@end

@implementation HealthInquiryViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"资讯列表";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
  
    [self initUI];
    
    [self refresh];

    LKWeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.tableCtrl addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];
    

}

- (void)initUI
{
    self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT) style:UITableViewStylePlain];
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.separatorStyle = 0;
    self.tableCtrl.backgroundColor = BM_CLEAR;
    [self.view addSubview:self.tableCtrl];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    return [HeadlthInqurylCell cellHeightWithData:self.responseDatas[indexPath.section]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    HeadlthInqurylCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[HeadlthInqurylCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [cell configCellWithData:self.responseDatas[indexPath.section]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * data = self.responseDatas[indexPath.section];
    HealthDetailViewController *detail = [[HealthDetailViewController alloc] init];
    detail.adviceId = data[@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark Network M

- (void) initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    [UserServices
     healthAdviceListWithAdviceClassId:self.adviceClassId
     pageIndex:pageIndex
     pageSize:pageSize
     key:self.key
     completionBlock:^(int result, id responseObject)
     {
        
        if (result == 0) {
            
            NSArray * data = responseObject[@"data"];
            [self responseDataList:data];
            if (self.pageItem.isRefresh) {
                [self.tableCtrl headerEndRefreshing];
            }else{
                
                if (!self.pageItem.canLoadMore) {
                    [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                }
                [self.tableCtrl footerEndRefreshing];
            }
            
            [self.tableCtrl reloadData];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
