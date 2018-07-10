//
//  MallSearchViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSearchViewController.h"
#import "MallTopSearchView.h"
#import "HistorySearchCell.h"
#import "MallSearchManager.h"
#import "DQAlertViewController.h"

#import "ProprietaryShopViewController.h"
#import "MallStoreListViewController.h"

@interface MallSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MallTopSearchView *searchView;
@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSMutableArray *searchDataSource;

@end

@implementation MallSearchViewController

-(NSMutableArray *)searchDataSource
{
    if (!_searchDataSource)
    {
        _searchDataSource=[[NSMutableArray alloc]init];
    }
    
    [_searchDataSource removeAllObjects];
    if (self.searchView.leftButtonIndex == 0) {
        [_searchDataSource addObjectsFromArray:[MallSearchManager goodsData]];
    }else{
        [_searchDataSource addObjectsFromArray:[MallSearchManager shopData]];
    }
    
    return _searchDataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSearchView];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.searchView.search.searchFD.text = @"";
}

-(void)createSearchView
{
    LKWeakSelf
    [self showRightBarButtonItemHUDByName:@"搜索"];
    self.searchView=[[MallTopSearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-44*2, 44)];
    self.searchView.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    [self showNavBarCustomByView:self.searchView];
    [self.searchView receiveObject:^(id object) {
        [self baseRightBtnAction:nil];
    }];
    self.searchView.bChangeFilterOptionHandle = ^(NSInteger index){
        LKStrongSelf

        [_self.tableCtrl reloadData];
    };
}
- (void)createUI
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
    if (self.searchDataSource.count==0)
    {
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallSearchManager * searchModel = self.searchDataSource[indexPath.row];
    
    HistorySearchCell *cell=[HistorySearchCell cellWithTableView:tableView];
    
    [cell loadCellWithDataSource:searchModel];
    
    cell.bSearchHistoryDeleteHandle = ^(){
        
        if ([MallSearchManager saveData:searchModel]) {            
            [self.searchDataSource removeObject:searchModel];
            [self.tableCtrl reloadData];
        }
    };
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 60)];
    baseView.backgroundColor = [UIColor clearColor];
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 50)];;
    View.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:View];
    
    LocalhostImageView *leftImage=[[LocalhostImageView alloc]init];
    leftImage.image=[UIImage imageNamed:@"Mall_lishi"];
    [View addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(View.mas_centerY);
    }];
    
    UILabel *searceTitle=[UnityLHClass masonryLabel:@"历史搜索记录" font:15.0 color:BM_BLACK];
    [View addSubview:searceTitle];
    [searceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImage.mas_right).offset(10);
        make.centerY.mas_equalTo(View.mas_centerY);
    }];
    
    UIButton *rightDel=[UnityLHClass masonryButton:@"" imageStr:@"Mall_del" font:15.0 color:BM_BLACK];
    [rightDel setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [View addSubview:rightDel];
    [rightDel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(View.mas_centerY);
    }];
    [rightDel handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        DEF_DEBUG(@"删除历史记录");
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定清除搜索历史？" buttons:@[@"取消",@"清除"] afterDismiss:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                if (self.searchView.leftButtonIndex == 0) {
                    
                    [MallSearchManager clearAllGoodsData];
                }else{
                
                    [MallSearchManager clearAllShopData];
                }
                [self.searchDataSource removeAllObjects];
                [self.tableCtrl reloadData];
            }
        }];
        [alert showAlert:self];
    }];
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [baseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(baseView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    return baseView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallSearchManager *searchModel=self.searchDataSource[indexPath.row];
    if (searchModel.type==0)
    {
        //所有商品列表
        ProprietaryShopViewController *searchGood=[[ProprietaryShopViewController alloc]init];
        searchGood.goodsName=searchModel.searchTitle;
        [self.navigationController pushViewController:searchGood animated:YES];
    }
    else
    {
        //店铺
        MallStoreListViewController *searchStore=[[MallStoreListViewController alloc]init];
        searchStore.searchTitle=searchModel.searchTitle;
        [self.navigationController pushViewController:searchStore animated:YES];
    }

}


-(void)baseRightBtnAction:(UIButton *)btn
{
    [self.searchView.search.searchFD resignFirstResponder];
    
    if (self.searchView.leftButtonIndex==0)
    {
        //所有商品列表
        ProprietaryShopViewController *searchGood=[[ProprietaryShopViewController alloc]init];
        searchGood.goodsName=self.searchView.search.searchFD.text;
        [self.navigationController pushViewController:searchGood animated:YES];
    }
    else
    {
        //店铺
        MallStoreListViewController *searchStore=[[MallStoreListViewController alloc]init];
        searchStore.searchTitle=self.searchView.search.searchFD.text;
        [self.navigationController pushViewController:searchStore animated:YES];
    }

    if (self.searchView.search.searchFD.text.length>0)
    {
        MallSearchManager *searchModel=[[MallSearchManager alloc]init];
        searchModel.searchTitle=self.searchView.search.searchFD.text;
        searchModel.time = [[NSDate date] timeIntervalSince1970];//[UnityLHClass getCurrentTime];
        searchModel.type=self.searchView.leftButtonIndex;
        [MallSearchManager saveData:searchModel];
        
        [self.tableCtrl reloadData];
    }
}

@end
