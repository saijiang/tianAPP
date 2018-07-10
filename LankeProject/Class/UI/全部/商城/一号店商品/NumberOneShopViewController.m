//
//  NumberOneShopViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "NumberOneShopViewController.h"
#import "NumOneShopCell.h"
#import "ShopScreeningView.h"
#import "NumberOneGoodsDetailViewController.h"
#import "LKFilterView.h"
#import "MallSectionHeaderView.h"
#import "ShoppingCarListViewController.h"
#import "CartNumView.h"
#import "OneShopClassificationViewController.h"
@interface NumberOneShopViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)SearchView *searchView;
@property(nonatomic,strong)ShopScreeningView *topView;
@property (nonatomic ,strong) OneShopSearchItem * searchItem;
@property(nonatomic,strong)CartNumView *cartNumView;

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSMutableArray *searchDataSource;

@property (nonatomic ,strong) NSArray * priceFilter;

@end

@implementation NumberOneShopViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.searchItem = [[OneShopSearchItem alloc] init];
        self.priceFilter = @[[NSMutableSet setWithObjects:@(0), nil]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSearchView];
    [self refresh];
    
    LKWeakSelf
    [self.tableCtrl addHeaderWithCallback:^{
        
        LKStrongSelf
        [_self refresh];
    }];
    [self.tableCtrl addFooterWithCallback:^{
        
        LKStrongSelf
        [_self loadMore];
    }];

}
-(void)createSearchView
{
    NSArray *imageArray=@[[UIImage imageNamed:@"Mall_fenlei"],[UIImage imageNamed:@"Mall_gouwuche-1"],];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44*imageArray.count, 44)];
    for (int i=0; i<imageArray.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(44*i, 0, 44, 44);
        btn.tag=100+i;
       
        [btn setImage:imageArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(baseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat f = (44-20)/2;
        [view addSubview:btn];
        if (i==0) {
            [btn setTitle:@"分类" forState:UIControlStateNormal];
            [btn setTitleColor:BM_GRAY forState:UIControlStateNormal];
            btn.titleLabel.font=BM_FONTSIZE(13.0);
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        }
        else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];

        }
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
    
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:^(){
    
    } normalHandle:^{
        
        self.cartNumView= [CartNumView CartNumView];
        [self.rightButton addSubview:self.cartNumView];
//        self.cartNumView.frame=CGRectMake(DEF_WIDTH(self.rightButton)-5, 10, DEF_HEIGHT(self.cartNumView), DEF_HEIGHT(self.cartNumView));
        [self.cartNumView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(self.rightButton.mas_top).mas_offset(-5);
            make.right.mas_equalTo(self.rightButton.mas_right).mas_offset(5);
            make.height.mas_equalTo(DEF_HEIGHT(self.cartNumView));
            make.width.mas_equalTo(DEF_HEIGHT(self.cartNumView));
        }];
        [self.cartNumView getGoodsCartNum];

    }];
    
    self.searchView=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-44*3, 44)];
    self.searchView.searchFD.placeholder=@"查询1号店商品";
    self.searchView.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    [self showNavBarCustomByView:self.searchView];
    [self.searchView receiveObject:^(id object) {
        self.searchItem.productCname = object;
        self.searchItem.sales = @"2";
        self.searchItem.categorySearchCode=nil;
        [self refresh];
        
    }];
    
}
- (void)createUI
{
    LKWeakSelf
    self.topView=[[ShopScreeningView alloc]init];
    self.topView.item = self.searchItem;
    [self.view addSubview:self.topView];
    self.topView.bSelectFilterHandle = ^(){
        LKStrongSelf
        LKFilterView * filterView = [[LKFilterView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT)];
        filterView.priceFilter = _self.priceFilter;
        filterView.bConfirmHandle = ^(LKFilterView * view ,NSString * code){
            _self.searchItem.priceFilter = code;
            [_self refresh];
            
            _self.priceFilter = view.priceFilter;
            [_self.topView clearFilterState];
        };
        filterView.bCancelHandle = ^(LKFilterView *filter){
            _self.priceFilter = filter.priceFilter;
            [_self.topView clearFilterState];
        };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [filterView showWithView:_self.topView onViewController:_self];
        });
    };
    [self.topView receiveObject:^(id object) {
        LKStrongSelf
        [_self refresh];
    }];
    MallSectionHeaderView *sectionHeader=[[MallSectionHeaderView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.topView)+1.0, DEF_SCREEN_WIDTH, 35)];
    [self.view addSubview:sectionHeader];
    [sectionHeader loadSectionWithTitle:@"服务热线：010-68112299"];
    [sectionHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionHeader.mas_bottom).offset(-9.5);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
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
    return self.responseDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NumOneShopCell *cell=[NumOneShopCell cellWithTableView:tableView];
    
    [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NumberOneGoodsDetailViewController * detail = [[NumberOneGoodsDetailViewController alloc] init];
    
    detail.listGoodsInfo = self.responseDatas[indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
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
    NSString *text = @"暂无商品";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}


-(void)baseBackBtnAction:(UIButton *)btn
{

    //判断是否有选择状态
    if (self.searchItem.productCname.length>0||self.searchItem.sort.length>0||self.searchItem.priceFilter.length>0||self.searchItem.categorySearchCode.length>0||![self.searchItem.sales isEqualToString:@"2"])
    {
        self.searchView.searchFD.text=nil;
        self.searchItem = [[OneShopSearchItem alloc] init];
        self.priceFilter = @[[NSMutableSet setWithObjects:@(0), nil]];
        [self.topView clearFilterState];
        self.topView.item=self.searchItem;
        [self refresh];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)baseRightBtnAction:(UIButton *)btn
{

    if (btn.tag==100)
    {
        //分类
        OneShopClassificationViewController *searchClassification=[[OneShopClassificationViewController alloc]init];
        searchClassification.searchItem=self.searchItem;
        [self.navigationController pushViewController:searchClassification animated:YES];
        [searchClassification receiveObject:^(id object) {
            [self refresh];
        }];
    }
    else
    {
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            //购物车
            ShoppingCarListViewController *list = [[ShoppingCarListViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
        }];
    }

}

#pragma mark -
#pragma mark Network M

- (void)initiateNetworkListRequest{
    
    self.pageItem.pageSize=15;
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    [UserServices
     getProductListWithProductCname:self.searchItem.productCname
     sort:self.searchItem.sort
     goodsSales:self.searchItem.sales
     priceRange:self.searchItem.priceFilter
     categorySearchCode:self.searchItem.categorySearchCode
     pageIndex:pageIndex
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
            
            self.tableCtrl.emptyDataSetSource = self;
            [self.tableCtrl reloadData];
            if (self.pageItem.pageIndex==1&&self.responseDatas.count>0)
            {
                [self.tableCtrl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

            //pageIndex
            if (self.responseDatas.count>0) {
                self.pageItem.pageIndex=[self.responseDatas.lastObject[@"pageIndex"] integerValue];
            }
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
