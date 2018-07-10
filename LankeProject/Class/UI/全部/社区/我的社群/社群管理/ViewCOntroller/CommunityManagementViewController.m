//
//  CommunityManagementViewController.m
//  LankeProject
//
//  Created by itman on 17/4/24.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityManagementViewController.h"
#import "MoreCommunityCell.h"
#import "CommunityApplyListViewController.h"
#import "CommunityTermsViewController.h"
#import "CommunityBBSViewController.h"
#import "CommunitySeeMemberViewController.h"


@interface CommunityManagementViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView *tableCtrl;

@end

@implementation CommunityManagementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"社群管理";
}

- (void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
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
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
        self.tableCtrl.emptyDataSetSource=self;
    }
    return _tableCtrl;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.responseDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MoreCommunityCell *cell=[MoreCommunityCell cellWithTableView:tableView];
    MoreCommunityModel *model=self.responseDatas[indexPath.section];
    [cell loadMangerCellWithDataSource:model];
    [cell receiveObject:^(id object) {
        //0 社群条款 1 申请列表片
        if ([object integerValue]==0)
        {
            CommunityTermsViewController *terms=[[CommunityTermsViewController alloc]init];
            terms.data=[model dictionaryRepresentation];
            terms.style=TermsStyleEditor;
            [self.navigationController pushViewController:terms animated:YES];
            [terms receiveObject:^(id object) {
                [self refresh];
            }];
        }
        else if ([object integerValue]==1)
        {
            CommunityApplyListViewController *applyList=[[CommunityApplyListViewController alloc]init];
            applyList.associationId=model.associationId;
            [self.navigationController pushViewController:applyList animated:YES];
            [applyList receiveObject:^(id object) {
                [self refresh];
            }];
        }
        else if ([object integerValue]==2)
        {
            CommunitySeeMemberViewController *seeMemberVC=[[CommunitySeeMemberViewController alloc]init];
            seeMemberVC.associationId=model.associationId;
            [self.navigationController pushViewController:seeMemberVC animated:YES];
            [seeMemberVC receiveObject:^(id object) {
                [self refresh];
            }];
        }
        

    }];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCommunityModel *model= self.responseDatas[indexPath.section];
    CommunityBBSViewController *bbs=[[CommunityBBSViewController alloc]init];
    bbs.associationId=model.associationId;
    bbs.title=model.associationTitle;
    [self.navigationController pushViewController:bbs animated:YES];

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
-(void)baseRightBtnAction:(UIButton *)btn
{
    
}

- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    [UserServices
     getMyAssociationWithUserId:[KeychainManager readUserId]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             
             NSArray * data = responseObject[@"data"];
             NSMutableArray *mutableArray=[[NSMutableArray alloc]init];
             for (NSDictionary *dataSource in data) {
                 MoreCommunityModel *model=[[MoreCommunityModel alloc]init];
                 [model setValuesForKeysWithDictionary:dataSource];
                 [mutableArray addObject:model];
             }
             [self responseDataList:mutableArray];
             if (self.pageItem.isRefresh)
             {
                 [self.tableCtrl headerEndRefreshing];
             }
             else
             {
                 
                 if (!self.pageItem.canLoadMore)
                 {
                     [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 }
                 [self.tableCtrl footerEndRefreshing];
             }
             
             [self.tableCtrl reloadData];
             
         }
         else
         {
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
