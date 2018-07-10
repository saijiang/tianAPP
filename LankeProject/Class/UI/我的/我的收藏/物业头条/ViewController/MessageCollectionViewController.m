//
//  MessageCollectionViewController.m
//  LankeProject
//
//  Created by itman on 17/5/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MessageCollectionViewController.h"
#import "CommunityHeadCell.h"
#import "CommunityHeadInfoViewController.h"

@interface MessageCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property (nonatomic,strong)UITableView *tableCtrl;

@end

@implementation MessageCollectionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTableCtrl];
}
-(void)loadTableCtrl
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
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
    return 0.1;
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
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        // Delete the row from the data source.
        [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId:self.responseDatas[indexPath.row][@"id"] collectType:@"06" completionBlock:^(int result, id responseObject)
         {
             if (result == 0)
             {
                 [self refresh];
                 [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];
             }else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
        
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

#pragma mark -
#pragma mark Network M

- (void)initiateNetworkListRequest{
    
    [UserServices
     getCollectNoticeAnnounceWithUserId:[KeychainManager readUserId]
     pageIndex:@"1"
     pageSize:@"1000"
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             id data = responseObject[@"data"];
             [self responseDataList:data];
             [self.tableCtrl reloadData];
         }else{
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
    
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
