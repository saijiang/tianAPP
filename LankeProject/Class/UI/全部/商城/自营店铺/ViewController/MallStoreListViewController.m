//
//  MallStoreListViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallStoreListViewController.h"
#import "SearchView.h"
#import "MallStoreCell.h"
#import "MallStoreDetailViewController.h"
//#import "NewMallStoreDetailViewController.h"


@interface MallStoreListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableArray;
    NSMutableArray *currenArray;
}

@property(nonatomic,strong)SearchView *searchView;
@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,assign)NSInteger pageIndex;

@end

@implementation MallStoreListViewController

-(void)getMerchantInfo
{
    [UserServices
     getMerchantInfoWithMerchantName:self.searchView.searchFD.text
     pageIndex:[NSString stringWithFormat:@"%ld",(long)self.pageIndex]
     pageSize:@"10"
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            if (self.pageIndex==1)
            {
                [tableArray removeAllObjects];
            }
            [currenArray removeAllObjects];
            [currenArray addObjectsFromArray:responseObject[@"data"]];
            [tableArray addObjectsFromArray:currenArray];
            [self.tableCtrl reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
        
    }];
}
-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.pageIndex=1;
        currenArray=[[NSMutableArray alloc]init];
        tableArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSearchView];
    [self getMerchantInfo];
}
-(void)createSearchView
{
    [self showRightBarButtonItemHUDByName:@"搜索"];
    self.searchView=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-44*2, 44)];
    self.searchView.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    self.searchView.searchFD.text=self.searchTitle;
    self.searchView.searchFD.placeholder=@"输入关键词进行搜索";
    [self showNavBarCustomByView:self.searchView];
    [self.searchView receiveObject:^(id object) {
        [self baseRightBtnAction:nil];
    }];
    
    
}
- (void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    __weak MallStoreListViewController *week=self;
    [self.tableCtrl addHeaderWithCallback:^{
        week.pageIndex=1;
        [week getMerchantInfo];
        [week.tableCtrl headerEndRefreshing];
        
    }];
    [self.tableCtrl addFooterWithCallback:^{
        if (currenArray.count<10)
        {
            [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
        }
        else
        {
            week.pageIndex++;
            [week getMerchantInfo];
        }
        [week.tableCtrl footerEndRefreshing];
        
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallStoreCell *cell=[MallStoreCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:tableArray[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MallStoreDetailViewController * detail = [[MallStoreDetailViewController alloc] init];
//    detail.merchantId=tableArray[indexPath.row][@"merchantId"];
//    [self.navigationController pushViewController:detail animated:YES];
    
    [self requestShopDetailWithmerchantId:tableArray[indexPath.row][@"merchantId"]];
}

//2017.12.25---更改
- (void) requestShopDetailWithmerchantId:(NSString *)merchantId{
    
    [UserServices
     getMerchantDetailInfoWithUserId:[KeychainManager readUserId]
     merchantId:merchantId
     completionBlock:^(int result, id responseObject)
     {
         
         if (result == 0)
         {
             id data = responseObject[@"data"];
             
             //前两个自己添加的固定数据
             MallStoreDetailViewController * detail = [[MallStoreDetailViewController alloc] init];
             //             detail.merchantId=merchantSource[[object integerValue]-3][@"merchantId"];
             detail.merchantId=merchantId;
             detail.webData = data;
             [self.navigationController pushViewController:detail animated:YES];
             
             //             self.tempConetnt.data = data;
             
             //             [self.collectionView reloadData];
             //
             //             [self refresh];
         }
         else
         {
             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}


-(void)baseRightBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    self.pageIndex=1;
    [self getMerchantInfo];
    
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
