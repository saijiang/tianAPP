//
//  ReplyToListViewController.m
//  LankeProject
//
//  Created by itman on 17/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ReplyToListViewController.h"
#import "BBSCommentsCell.h"


@interface ReplyToListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;


@end

@implementation ReplyToListViewController

//拉黑用户
-(void)delAssociationUserWithPublishUserId:(NSString *)publishUserId
{
    [UserServices
     delAssociationUserWithassociationId:self.topicId
     userId:[KeychainManager readUserId]
     publishUserId:publishUserId
     completionBlock:^(int result, id responseObject)
     {
         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         if (result==0)
         {
             [self refresh];
             [self sendObject:@"reload"];

         }
         else
         {
         }
     }];
}
//删除用户评论
-(void)delTopicEvaluateWithevalId:(NSString *)evalId
{
    [UserServices
     delTopicEvaluateWithassociationId:self.topicId
     userId:[KeychainManager readUserId]
     evalId:evalId
     completionBlock:^(int result, id responseObject)
     {
         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         if (result==0)
         {
             [self refresh];
             [self sendObject:@"reload"];
             
         }
         else
         {
         }
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
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"回复列表"];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseDatas.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight= [BBSCommentsCell getCellHightWithDataSource:self.responseDatas[indexPath.row]];
    return hight;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BBSCommentsCell *cell=[BBSCommentsCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
    if (!self.isGroup)
    {
        //非群主身份隐藏操作按钮
        [cell  hideCaoZuoView];
    }
    [cell receiveObject:^(id object) {
        DEF_DEBUG(@"%@",object);
        //0删除评论  1拉黑
        if ([object integerValue]==0)
        {
            [self delTopicEvaluateWithevalId:self.responseDatas[indexPath.row][@"evalId"]];
        }
        else
        {
            [self delAssociationUserWithPublishUserId:self.responseDatas[indexPath.row][@"publishUserId"]];
        }
    }];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    [UserServices
     getTopicEvaluateWithassociationId:self.topicId
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             
             NSArray * data = responseObject[@"data"][@"list"];
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
