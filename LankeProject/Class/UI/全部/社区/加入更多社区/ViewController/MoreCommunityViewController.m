//
//  MoreCommunityViewController.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MoreCommunityViewController.h"
#import "MoreCommunityCell.h"
#import "MoreCommunityheaderView.h"

#import "CreateCommunityViewController.h"
#import "CommunityBBSViewController.h"
#import "CommunityTermsViewController.h"

#import "MoreCommunityDetailViewController.h"

@interface MoreCommunityViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,copy)NSString *classId;
@end

@implementation MoreCommunityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"社区论坛";
//    [self showRightBarButtonItemHUDByName:@"创建社群"];
}

- (void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    

   MoreCommunityheaderView *headerView=[[MoreCommunityheaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 100)];
  
    self.tableCtrl.tableHeaderView=headerView;
    [headerView receiveObject:^(id object) {
        self.classId=object;
        [self refresh];
        
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
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
    [cell loadCellWithDataSource:self.responseDatas[indexPath.section]];
    [cell receiveObject:^(id object) {
        // 申请加入社群
    }];
    return cell;
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCommunityModel *model= self.responseDatas[indexPath.section];
    if ([model.isAdd integerValue]==1)
    {
        CommunityBBSViewController *bbs=[[CommunityBBSViewController alloc]init];
        bbs.associationId=model.associationId;
        bbs.title=model.associationTitle;
        [self.navigationController pushViewController:bbs animated:YES];
    }
    else
    {
        
        NSDictionary *dataSource=[model dictionaryRepresentation];
        MoreCommunityDetailViewController *terms=[[MoreCommunityDetailViewController alloc]init];
        terms.data=dataSource;
        [self.navigationController pushViewController:terms animated:YES];
        [terms receiveObject:^(id object) {
            //[self refresh];
        }];
        
//        NSDictionary *dataSource=[model dictionaryRepresentation];
//        CommunityTermsViewController *terms=[[CommunityTermsViewController alloc]init];
//        terms.style=TermsStyleReading;
//        terms.data=dataSource;
//        [self.navigationController pushViewController:terms animated:YES];
//        [terms receiveObject:^(id object) {
//            //[self refresh];
//        }];
    }
   
  
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
    CreateCommunityViewController *create=[[CreateCommunityViewController alloc]init];
    [self.navigationController pushViewController:create animated:YES];
}

- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    [UserServices
     getAssociationListWithuserId:[KeychainManager readUserId]
     classId:self.classId
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
