//
//  ProprietaryShopViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ProprietaryShopViewController.h"
#import "SelfSupportGoodsDetailViewController.h"
#import "NewSelfSupportGoodsDetailViewController.h"
#import "ProprietaryCell.h"
#import "ProprietaryTopView.h"
#import "MallSectionHeaderView.h"
//购物车列表
#import "ShoppingCarListViewController.h"
#import "SelfSupportCarViewController.h"
#import "LKFilterView.h"
#import "MallSearchClassificationViewController.h"
#import "CartNumView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface ProprietaryShopViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
{
    NSMutableArray *tableArray;
    NSMutableArray *currenArray;
}

@property(nonatomic,strong)SearchView *searchView;
@property(nonatomic,strong)ProprietaryTopView *topView;
@property(nonatomic,strong)MallSectionHeaderView *sectionHeader;
@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)CartNumView *cartNumView;

@property (nonatomic ,strong) NSArray * priceFilter;

@end

@implementation ProprietaryShopViewController


-(void)getCategoryName
{
    [UserServices
     getCategoryNameWithClassOneId:self.searchItem.classOneId
     classTwoId:self.searchItem.classTwoId
     classThridId:self.searchItem.classThridId
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.sectionHeader loadSectionWithTitle:responseObject[@"data"]];

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    }];
}

-(void)getRecommendGoods
{
    [self getCategoryName];

    // getSearchGoodsList
    //注：销量，价格，好评单独查询，其他在基础上进行查询，除了给的固定值，其他都传空字符串或者不传
    [UserServices
     getRecommendGoodsWithgoodsName:self.searchItem.goodsName
     goodsSales:self.searchItem.goodsSales
     isPrice:self.searchItem.isPrice
     goodsComment:self.searchItem.goodsComment
     brandId:self.searchItem.brandId
     marketPrice:self.searchItem.marketPrice
     classOneId:self.searchItem.classOneId
     classTwoId:self.searchItem.classTwoId
     classThridId:self.searchItem.classThridId
     pageIndex:[NSString stringWithFormat:@"%ld",(long)self.searchItem.pageIndex]
     pageSize:[NSString stringWithFormat:@"%ld",(long)self.searchItem.pageSize]
     type:@"1"
     merchantId:self.merchantId
     completionBlock:^(int result, id responseObject)
     {
         self.tableCtrl.hidden=NO;
         if (result==0)
         {
             if (self.searchItem.pageIndex==1)
             {
                 [tableArray removeAllObjects];
                 
             }
             [currenArray removeAllObjects];
             [currenArray addObjectsFromArray:responseObject[@"data"]];
             [tableArray addObjectsFromArray:currenArray];
             [self.tableCtrl reloadData];
             if (self.searchItem.pageIndex==1&&tableArray.count>0)
             {
                 [self.tableCtrl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
             }
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


    if (self.cartNumView)
    {
       
        [self.cartNumView getGoodsCartNum];
        
        
    }
}

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.searchItem=[[GoodSearchItem alloc]init];
        currenArray=[[NSMutableArray alloc]init];
        tableArray=[[NSMutableArray alloc]init];
        self.priceFilter = @[[NSMutableSet setWithObjects:@(0), nil],[NSMutableSet setWithObjects:@(0), nil]];
    }
    return self;
}
-(void)setGoodsName:(NSString *)goodsName
{
    _goodsName=goodsName;
    self.searchItem.goodsName=self.goodsName;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSearchView];

    [self getRecommendGoods];
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
            [btn setEnlargeEdgeWithTop:10 right:20 bottom:10 left:10];

            CGFloat f = (44-20)/2;
            [view addSubview:btn];
            if (i==0) {
                [btn setTitle:@"分类" forState:UIControlStateNormal];
                [btn setTitleColor:BM_GRAY forState:UIControlStateNormal];
                btn.titleLabel.font=BM_FONTSIZE(13.0);
                [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
            }
            else{
//                [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];
                
            }
            
        }
    
        UIButton *btn1 = [view viewWithTag:100];
        UIButton *btn2 = [view viewWithTag:101];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
        self.navigationItem.rightBarButtonItems = @[item1,item2];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
//        self.navigationItem.rightBarButtonItem = item;
        self.searchView=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-44*3, 44)];
        self.searchView.searchFD.text=self.goodsName;
        self.searchView.searchFD.placeholder = @"请输入关键词进行检索";
        self.searchView.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
        [self showNavBarCustomByView:self.searchView];
        [self.searchView receiveObject:^(id object) {
            self.searchItem.goodsName=object;
            self.searchItem.pageIndex=1;
            [self getRecommendGoods];
            
        }];
        UIButton*btn=[view viewWithTag:101];
        
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:^(){
            
        } normalHandle:^{
            self.cartNumView= [CartNumView CartNumView];
            [btn addSubview:self.cartNumView];
        }];
        
        self.cartNumView.frame=CGRectMake(DEF_WIDTH(btn)-5, 10, DEF_HEIGHT(self.cartNumView), DEF_HEIGHT(self.cartNumView));
    [self.cartNumView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(btn).mas_offset(-5);
        make.right.mas_equalTo(btn).mas_offset(5);
        make.height.mas_equalTo(DEF_HEIGHT(self.cartNumView));
        make.width.mas_equalTo(DEF_HEIGHT(self.cartNumView));
    }];
}
 

- (void)createUI
{
    LKWeakSelf
    self.topView=[[ProprietaryTopView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 40)];
    self.topView.item = self.searchItem;
    self.topView.bSelectFilterHandle = ^(){
        LKStrongSelf
        LKFilterView * filterView = [[LKFilterView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT)];
        filterView.searchItem=_self.searchItem;
        filterView.isProShop=YES;
        filterView.priceFilter = _self.priceFilter;
        filterView.bConfirmHandle = ^(LKFilterView * view ,NSString * code){

            NSArray *codeArr=[code componentsSeparatedByString:@","];
            _self.priceFilter = view.priceFilter;
            _self.searchItem.marketPrice = codeArr[0];//商品价格
            _self.searchItem.brandId=codeArr[1];//新增字段 品牌id
            [_self getRecommendGoods];
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
    [self.view addSubview:self.topView];
  
    [self.topView receiveObject:^(id object) {
        self.searchItem.pageIndex=1;
        [self getRecommendGoods];
    }];
    
    MallSectionHeaderView *sectionHeader=[[MallSectionHeaderView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.topView)+1.0, DEF_SCREEN_WIDTH, 35)];
    [self.view addSubview:sectionHeader];
    self.sectionHeader=sectionHeader;
    [self.sectionHeader loadSectionWithTitle:@"全部分类"];
    
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(sectionHeader.mas_bottom).offset(10);
    }];
    
    __weak ProprietaryShopViewController *week=self;
    [self.tableCtrl addHeaderWithCallback:^{
        week.searchItem.pageIndex=1;
        [week getRecommendGoods];
        [week.tableCtrl headerEndRefreshing];

    }];
    
    [self.tableCtrl addFooterWithCallback:^{
        if (currenArray.count<self.searchItem.pageSize)
        {
            [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
        }
        else
        {
            week.searchItem.pageIndex++;
            [week getRecommendGoods];
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
        self.tableCtrl.emptyDataSetSource=self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
        self.tableCtrl.hidden=YES;
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
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProprietaryCell *cell=[ProprietaryCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:tableArray[indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   SelfSupportGoodsDetailViewController * detail = [[SelfSupportGoodsDetailViewController alloc] init];
  //  NewSelfSupportGoodsDetailViewController * detail = [[NewSelfSupportGoodsDetailViewController alloc] init];
    
    detail.goodsId=tableArray[indexPath.row][@"goodsId"];
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


-(void)baseRightBtnAction:(UIButton *)btn
{
  
    if (btn.tag==100)
    {
        //分类
        MallSearchClassificationViewController *searchClassification=[[MallSearchClassificationViewController alloc]init];
        searchClassification.item=self.searchItem;
        [self.navigationController pushViewController:searchClassification animated:YES];
        [searchClassification receiveObject:^(id object) {
            self.searchItem.pageIndex=1;
            [self getRecommendGoods];
        }];
    }
    else
    {
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            
            
            ShoppingCarListViewController *list = [[ShoppingCarListViewController alloc] init];
                  list.isZiYingShop=YES;
            [self.navigationController pushViewController:list animated:YES];
            //购物车
//            SelfSupportCarViewController *list = [[SelfSupportCarViewController alloc] init];
////            list.isZiYingShop=YES;
//            [self.navigationController pushViewController:list animated:YES];
        }];
    }
}

@end
