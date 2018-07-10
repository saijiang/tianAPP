//
//  CommunitySeeMemberViewController.m
//  LankeProject
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunitySeeMemberViewController.h"
#import "SeeMemberCell.h"
@interface CommunitySeeMemberViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,copy)NSString *classId;

@end

@implementation CommunitySeeMemberViewController

- (void)createUI
{
    self.title=@"成员列表";
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(5);
    }];
    
    LKWeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        
        LKStrongSelf
        [_self refresh];
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
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SeeMemberCell *cell=[SeeMemberCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.section]];
    [cell.pullBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [UserServices getDeleteMemberListWithAssociationId:self.associationId userId:self.responseDatas[indexPath.section][@"userId"] completionBlock:^(int result, id responseObject) {
            if (result == 0)
            {
                NSString * strStatus = responseObject[@"status"];
                
                if ([strStatus integerValue]==0)
                {
//                   [self.responseDatas removeObjectAtIndex:indexPath.section];
//                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
//                    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                   [self refresh];
                }
                else
                {
                    [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                    
                }
            }
            else
            {
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
            
        }];
    }];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}


- (void)initiateNetworkListRequest{
    
    
    [UserServices getMemberListWithAssociationId:self.associationId pageIndex:nil pageSize:nil completionBlock:^(int result, id responseObject) {
        if (result == 0)
        {
            
            NSArray * data = responseObject[@"data"];
            
            [self responseDataList:data];
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
