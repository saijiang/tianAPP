//
//  MyNewsViewController.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyNewsViewController.h"
#import "MyNewCell.h"
#import "MyNewInfoViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "LKEmptyView.h"
#import "MyNewsModel.h"
@interface MyNewsViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
{
    NSMutableArray *tableArray;
    NSMutableArray *currentArray;

}

@property (nonatomic,strong)UITableView *tableCtrl;
@property (nonatomic,assign)int page;

@end

@implementation MyNewsViewController

-(void)getMessageList
{
    [UserServices
     getMessageListWithuserId:[KeychainManager readUserId]
     pageIndex:[NSString stringWithFormat:@"%d",_page]
     pageSize:@"10"
     completionBlock:^(int result, id responseObject)
    {
        [self.tableCtrl footerEndRefreshing];
        [self.tableCtrl headerEndRefreshing];
        if (result==0)
        {
            NSArray *array=responseObject[@"data"];
            [currentArray removeAllObjects];
            for (NSDictionary *dic in array) {
                MyNewsModel *model=[MyNewsModel initMyNewsModelWithData:dic];
                [currentArray addObject:model];
            }
            if (_page==1)
            {
                [tableArray removeAllObjects];
            }
            [tableArray addObjectsFromArray:currentArray];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
        
        [self.tableCtrl reloadData];
    }];
}

-(void)baseRightBtnAction:(UIButton *)btn
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定清空我的消息？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1)
        {
            [UserServices
             cleanMessageWithuserId:[KeychainManager readUserId]
             messageId:nil
             completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
                 {
                     [tableArray removeAllObjects];
                     [self.tableCtrl reloadData];
                 }
                 else
                 {
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     
                 }
             }];
        }
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的消息";
    [self showRightBarButtonItemHUDByName:@"清空"];
    _page=1;
    tableArray=[[NSMutableArray alloc]init];
    currentArray=[[NSMutableArray alloc]init];
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    WeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        weakSelf.page=1;
        [weakSelf getMessageList];
    }];
    [self.tableCtrl addFooterWithCallback:^{
        if(currentArray.count<10)
        {
            [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
            [weakSelf.tableCtrl footerEndRefreshing];
        }
        else
        {
            weakSelf.page++;
            [weakSelf getMessageList];
        }
       

    }];
    [self getMessageList];

   
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
        self.tableCtrl.emptyDataSetSource = self;
        
    }
    return _tableCtrl;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNewsModel *model=tableArray[indexPath.row];
    return model.hight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNewsModel *model=tableArray[indexPath.row];
    MyNewCell *cell=[MyNewCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:model];
    return cell;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定删除我的消息？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                MyNewsModel *model=tableArray[indexPath.row];
                [UserServices
                 cleanMessageWithuserId:[KeychainManager readUserId]
                 messageId:model.messageId
                 completionBlock:^(int result, id responseObject)
                 {
                     if (result==0)
                     {
                         [tableArray removeObjectAtIndex:indexPath.row];
                         [tableView reloadData];
                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                         
                     }
                 }];
            }
        }];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNewsModel *model=tableArray[indexPath.row];
    MyNewInfoViewController *info=[[MyNewInfoViewController alloc]init];
    info.dataSource=model.data;
    [self.navigationController pushViewController:info animated:YES];
    
    [UserServices readMessageId:model.messageId completionBlock:^(int result, id responseObject) {
        if (result==0) {
            model.readingFlg=YES;
            [tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
