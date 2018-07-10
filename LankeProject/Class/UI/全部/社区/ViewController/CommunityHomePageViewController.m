//
//  CommunityHomePageViewController.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHomePageViewController.h"
#import "CommunityHomeHeaderCell.h"
#import "CommunityHomePageCell.h"

#import "MyAddCommunityViewController.h"
#import "CommunityBBSViewController.h"
#import "CommunityDetailViewController.h"

@interface CommunityHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSArray *associationUserArray;

@end

@implementation CommunityHomePageViewController

-(void)getAssociationUser
{
    [UserServices
     getAssociationUserWithUserId:[KeychainManager readUserId]
     pageIndex:@"1"
     pageSize:@"3"
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            self.associationUserArray=[NSArray arrayWithArray:responseObject[@"data"]];
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
    self.title = @"社区论坛";
    [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"navigation_bar_call"]];
}

-(void)baseRightBtnAction:(UIButton *)btn
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您如果想建立社群可以拨打010-65571001 联系管理员" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打电话", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1)
        {
            [UnityLHClass callTel:@"010-65571001"];
        }
    }];
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
        [_self getAssociationUser];
        [_self refresh];
    }];
    
    [self.tableCtrl addFooterWithCallback:^{
        
        LKStrongSelf
        [_self loadMore];
    }];
    
    [self refresh];
    [self getAssociationUser];

    
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
    }
    return _tableCtrl;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return self.responseDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 230;
    }
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        CommunityHomeHeaderCell *cell=[CommunityHomeHeaderCell cellWithTableView:tableView];
        [cell loadCellWithDataSource:self.associationUserArray];
        [cell receiveObject:^(id object) {
            CommunityBBSViewController *bbs=[[CommunityBBSViewController alloc]init];
            bbs.associationId=object[@"associationId"];
            bbs.title=object[@"associationTitle"];
            [self.navigationController pushViewController:bbs animated:YES];
        }];
        return cell;
    }
    else
    {
        CommunityHomePageCell *cell=[CommunityHomePageCell cellWithTableView:tableView];
        [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
        return cell;
    }
  
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
    sectionView.backgroundColor=BM_WHITE;
    sectionView.bottomlineWithColor=[UIColor groupTableViewBackgroundColor];
    UILabel *titlelable=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    [sectionView addSubview:titlelable];
    [titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.left.mas_equalTo(sectionView.mas_left).offset(15);
    }];
    titlelable.text=@"社区活动";
    if (section==0)
    {
        titlelable.text=@"我的社群";
        UIButton *more=[UnityLHClass masonryButton:@"更多" imageStr:@"right_arrow" font:14.0 color:BM_BLACK];
        [more setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
        [more layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:1];
        [sectionView addSubview:more];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sectionView.mas_centerY);
            make.right.mas_equalTo(sectionView.mas_right).offset(-15);

        }];
        
        [more handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            MyAddCommunityViewController *myAddCommunity=[[MyAddCommunityViewController alloc]init];
            [self.navigationController pushViewController:myAddCommunity animated:YES];
        }];
    }
   
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        NSDictionary *dataSource= self.responseDatas[indexPath.row];
        CommunityDetailViewController *detail=[[CommunityDetailViewController alloc]init];
        detail.activiyId=dataSource[@"id"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
   [UserServices
    getCommunityActiviyWithpageIndex:pageIndex
    pageSize:pageSize
    completionBlock:^(int result, id responseObject)
    {
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
