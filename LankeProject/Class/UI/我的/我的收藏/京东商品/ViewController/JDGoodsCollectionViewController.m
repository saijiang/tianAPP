//
//  JDGoodsCollectionViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/20.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDGoodsCollectionViewController.h"
#import "JDGoodsCollectionCell.h"
#import "SelfSupportGoodsDetailViewController.h"
#import "NewSelfSupportGoodsDetailViewController.h"
#import "JDShopGoodsDetailViewController.h"
@interface JDGoodsCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSMutableArray *tableArray;

@end

@implementation JDGoodsCollectionViewController
-(void)getGoodsCollect
{
    [UserServices
     getJDGoodsCollectWithUserId:[KeychainManager readUserId]
     pageIndex:@"1"
     pageSize:@"1000"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.tableArray removeAllObjects];
             NSDictionary*dicData=responseObject[@"data"];
             [self.tableArray addObjectsFromArray:dicData[@"result"]];
             [self.tableCtrl reloadData];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getGoodsCollect];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableArray=[[NSMutableArray alloc]init];
    [self getGoodsCollect];
    
}
-(void)createUI
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
    return self.tableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDGoodsCollectionCell *cell=[JDGoodsCollectionCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.tableArray[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDShopGoodsDetailViewController * detail = [[JDShopGoodsDetailViewController alloc] init];
    
    detail.listGoodsInfo = self.tableArray[indexPath.row][@"zkJdProductDetail"];
    
    [self.navigationController pushViewController:detail animated:YES];
//    NSDictionary * data = self.tableArray[indexPath.row];
//    SelfSupportGoodsDetailViewController * detail = [[SelfSupportGoodsDetailViewController alloc] init];
//    detail.goodsId=data[@"result"][@"sku"];
//  [self.navigationController pushViewController:detail animated:YES];
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
        [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId:self.tableArray[indexPath.row][@"goodsId"] collectType:@"01" completionBlock:^(int result, id responseObject)
         {
             if (result == 0)
             {
                 [self getGoodsCollect];
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
