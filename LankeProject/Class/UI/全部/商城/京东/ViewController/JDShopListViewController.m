//
//  JDShopListViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDShopListViewController.h"
#import "JDShopListCell.h"
#import "JDShopScreeningView.h"
#import "JDShopGoodsDetailViewController.h"
//#import "LKFilterView.h"
#import "JDFilterView.h"
#import "MallSectionHeaderView.h"

#import "ShoppingCarListViewController.h"
#import "CartNumView.h"
#import "JDShopClassificationViewController.h"
#import "LKHomeBannerView.h"
#import "AdvDetailViewController.h"
//#import "UIViewController+Page.h"
@interface JDShopListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,CommonHeaderViewDelegate>

@property(nonatomic,strong)SearchView *searchView;
@property(nonatomic,strong)JDShopScreeningView *topView;
@property (nonatomic ,strong)NSString * typeId;
@property(nonatomic,strong)CartNumView *cartNumView;

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSMutableArray *searchDataSource;
@property(nonatomic,strong)CommonHeaderView*bannerView;
@property (nonatomic ,strong) NSArray * priceFilter;


@property (nonatomic ,strong) NSMutableArray * bannerDatas;
@property (nonatomic ,strong) NSString * zkPriceLess;
@property (nonatomic ,strong) NSString * zkPriceGreat;
@property (nonatomic ,strong) NSString * typeStr;

//品类
@property (nonatomic ,strong) NSMutableArray * brandArray;
@property (nonatomic ,strong) NSMutableArray * dataArray;
@end

@implementation JDShopListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cartNumView getGoodsCartNum];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.searchItem = [[JDShopSearchItem alloc] init];
        self.priceFilter = @[[NSMutableSet setWithObjects:@(0), nil]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerDatas = [[NSMutableArray alloc]init];
    self.brandArray=[NSMutableArray array];
    self.dataArray= [[NSMutableArray alloc]init];
//    self.searchItem.sales =@"";
//    self.searchItem.sort=@"";

    
    [self requestBannerList];
    [self refresh];
    [self createSearchView];
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
-(void)createTypeId
{
    
    [UserServices getJDFirstCategoryListWithparentId:@"0" CompletionBlock:^(int result, id responseObject) {
        if (result==0)
        {
            NSArray *array=responseObject[@"data"];
            
            if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0){
                
                NSString*idStr=[NSString stringWithFormat:@"%@;",array[0][@"catId"]];
                self.typeId=idStr;
                [self getPingPaiIDDataSource];


            }else{
                
            }

//            if (![data isKindOfClass:[NSString class]]) {
//                NSString*imageStr=data[@"catId"];
//                if (imageStr.length!=0||imageStr!=nil) {
//                    self.typeId=responseObject[@"data"][0][@"catId"];
//                }
//
//            }
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(void)createSearchView
{
    NSArray *imageArray=@[[UIImage imageNamed:@"jd_icon_black"],[UIImage imageNamed:@"jd_gouwuche_black"],];
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
            [btn setTitleColor:BM_BLACK forState:UIControlStateNormal];
            btn.titleLabel.font=BM_FONTSIZE(13.0);
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        }
        else{
            
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];
            [btn setEnlargeEdgeWithTop:10 right:5 bottom:5 left:5];

            self.rightButton = btn;
            
        }
    }
    
    UIButton *btn1 = [view viewWithTag:100];
    UIButton *btn2 = [view viewWithTag:101];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn1];   

    self.navigationItem.rightBarButtonItems = @[item1,item2];
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
    }];
    
    self.searchView=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-44*3, 44)];
    if ([self.isSearch isEqualToString:@"search"]) {
        self.searchView.searchFD.text=self.searchItem.productCname ;
    }else{
        
    }
    self.searchView.searchFD.placeholder=@"查询京东商品";
    self.searchView.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
   // self.searchView.searchFD.textAlignment=NSTextAlignmentCenter;
    [self showNavBarCustomByView:self.searchView];
    [self.searchView receiveObject:^(id object) {
        
        self.searchItem.productCname = object;
        self.searchItem.sales = @"";
        self.searchItem.sort=@"";
        self.searchItem.categorySearchCode=nil;
        self.searchItem.typeName=@"";
        [self refresh];
        
        [self getPingPaiNameDataSource];

    }];
//    [self.searchView.searchFD mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.searchView);
//        make.right.mas_equalTo(-20);
//        make.left.mas_equalTo(10);
//        
//    }];
    
    
}

- (void)createUI
{
    [self createTypeId];
    
    
    self.typeStr=@"全部";
    
 
    self.topView=[[JDShopScreeningView alloc]init];
    //self.searchItem.typeId=self.typeId;
    self.topView.item = self.searchItem;
    self.topView.userInteractionEnabled = NO;
    [self.view addSubview:self.topView];
    
    self.bannerView = [[CommonHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_WIDTH/3)];
    self.bannerView.delegate=self;
    [self addSubview:self.bannerView];
    //
    //    self.bannerView = [[LKHomeBannerView alloc] initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 150)];
    //
    //    [ self.bannerView.myPageControl mas_updateConstraints:^(MASConstraintMaker *make){
    //        make.bottom.mas_equalTo(-20);
    //    }];
    //    self.bannerView.myPageView.didSelectPageViewAtIndex = ^(NSInteger index)
    //    {
    //        LKStrongSelf
    //        [_self navigationToAdDetailWithData:_self.bannerDatas[index]];
    //    };
    //    self.bannerView.backgroundColor = [UIColor clearColor];
    //    [self addSubview:self.bannerView];
    
    //    MallSectionHeaderView *sectionHeader=[[MallSectionHeaderView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.topView)+1.0, DEF_SCREEN_WIDTH, 35)];
    //    [self.view addSubview:sectionHeader];
    //    [sectionHeader loadSectionWithTitle:@"服务热线：010-68112299"];
    //    [sectionHeader mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(10);
    //        make.left.and.right.mas_equalTo(0);
    //        make.height.mas_equalTo(40);
    //    }];
    //
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(-9.5);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}

-(void)createTopViewUI{
    self.topView.userInteractionEnabled = YES;
       LKWeakSelf
    self.topView.bSelectFilterHandle = ^(){
        
        LKStrongSelf
        //获取品牌数据
        JDFilterView * filterView = [[JDFilterView alloc] initWithFrame:CGRectZero withBrandArray:_self.brandArray];
        filterView.priceFilter = _self.priceFilter;
        filterView.dataArray = _self.dataArray;
        
        //        [filterView getBrandList:_self.typeId];
        filterView.typeStr=_self.typeStr;
        filterView.isRight = YES;
        
        
        filterView.bConfirmHandle = ^(JDFilterView * view ,NSString * code){
            
            if([code rangeOfString:@","].location !=NSNotFound)//_roaldSearchText
            {
                NSLog(@"yes");
                NSArray  *array = [code componentsSeparatedByString:@","];
                if ([array[1] isEqualToString:@"全部"]) {
                    _self.searchItem.typeName=@"";
                    
                }else{
                    _self.searchItem.typeName = array[1];
                    
                }
                NSString*priceStr=array[0];
                if ([priceStr rangeOfString:@"-"].location !=NSNotFound) {
                    NSArray  *priceArray = [priceStr componentsSeparatedByString:@"-"];
                    _self.zkPriceLess=priceArray[1];
                    _self.zkPriceGreat=priceArray[0];
                    
                }else if([priceStr rangeOfString:@"以上"].location !=NSNotFound){
                    priceStr=[priceStr substringToIndex:[priceStr length] - 2];
                    _self.zkPriceGreat=priceStr;
                    _self.zkPriceLess=@"";
                    
                }else{
                    _self.zkPriceGreat=@"";
                    _self.zkPriceLess=@"";
                }
                
                
                _self.typeStr= array[1];
            }
            else
            {
                NSLog(@"no");
            }
            
            
            [_self refresh];
            
            _self.priceFilter = view.priceFilter;
            [_self.topView clearFilterState];
        };
        filterView.bCancelHandle = ^(JDFilterView *filter){
            _self.priceFilter = filter.priceFilter;
            // _self.typeStr=@"";
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
}


-(void)getPingPaiNameDataSource
{
    [UserServices
     getJDBrandListWithcategoryId:@""
     goodsName:self.searchView.searchFD.text
     completionBlock:^(int result, id responseObject)
     {
         
         if (result==0)
         {
             [self.dataArray removeAllObjects];
             [self.brandArray removeAllObjects];
             NSMutableArray *tempArray=[[NSMutableArray alloc]init];
             
             [tempArray addObject:@{@"name":@"全部",
                                    @"code":@""}];
             NSArray *dataArr=responseObject[@"data"];
             
             [self.dataArray addObjectsFromArray:dataArr];
             NSInteger num;
             if (dataArr.count>5) {
                 num=5;
             }else{
                 num=dataArr.count;
             }
             for (int i=0; i<num; i++) {
                 NSMutableDictionary *dataSource=[[NSMutableDictionary alloc]init];
                 [dataSource setValue:dataArr[i] forKey:@"name"];
                 [dataSource setValue:[NSString stringWithFormat:@"%d",i] forKey:@"code"];
                 [tempArray addObject:dataSource];
             }
             
             NSDictionary *brandList=@{@"filterSection":@"品牌",
                                       @"filterItems":tempArray
                                       };
             NSArray*filterDatas = @[@{@"filterSection":@"价格",
                                       @"filterItems":@[@{@"name":@"全部",
                                                          @"code":@""},
                                                        @{@"name":@"0-50",
                                                          @"code":@"0"},
                                                        @{@"name":@"50-100",
                                                          @"code":@"1"},
                                                        @{@"name":@"100-200",
                                                          @"code":@"2"},
                                                        @{@"name":@"200-500",
                                                          @"code":@"3"},
                                                        @{@"name":@"500以上",
                                                          @"code":@"4"}]}];
             NSArray*array=@[filterDatas.firstObject,brandList];
             [self.brandArray addObjectsFromArray:array];
             
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}
-(void)getPingPaiIDDataSource
{
    [UserServices
     getJDBrandListWithcategoryId:self.typeId
     goodsName:@""
     completionBlock:^(int result, id responseObject)
     {
         
         if (result==0)
         {
             [self.dataArray removeAllObjects];
             [self.brandArray removeAllObjects];
             NSMutableArray *tempArray=[[NSMutableArray alloc]init];
             
             [tempArray addObject:@{@"name":@"全部",
                                    @"code":@""}];
             NSArray *dataArr=responseObject[@"data"];
             [self.dataArray addObjectsFromArray:dataArr];
             NSInteger num;
             if (dataArr.count>5) {
                 num=5;
             }else{
                 num=dataArr.count;
             }
             for (int i=0; i<num; i++) {
                 NSMutableDictionary *dataSource=[[NSMutableDictionary alloc]init];
                 [dataSource setValue:dataArr[i] forKey:@"name"];
                 [dataSource setValue:[NSString stringWithFormat:@"%d",i] forKey:@"code"];
                 [tempArray addObject:dataSource];
             }
             
             NSDictionary *brandList=@{@"filterSection":@"品牌",
                                       @"filterItems":tempArray
                                       };
             NSArray*filterDatas = @[@{@"filterSection":@"价格",
                                    @"filterItems":@[@{@"name":@"全部",
                                                       @"code":@""},
                                                     @{@"name":@"0-50",
                                                       @"code":@"0"},
                                                     @{@"name":@"50-100",
                                                       @"code":@"1"},
                                                     @{@"name":@"100-200",
                                                       @"code":@"2"},
                                                     @{@"name":@"200-500",
                                                       @"code":@"3"},
                                                     @{@"name":@"500以上",
                                                       @"code":@"4"}]}];
           NSArray*array=@[filterDatas.firstObject,brandList];
             [self.brandArray addObjectsFromArray:array];
             [self createTopViewUI];

        }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}
//广告位delegate
-(void)commonHeaderView:(CommonHeaderView *)comonHeaderView didSelectedBannerImageAtIndex:(NSInteger)index
{
    [self navigationToAdDetailWithData:self.bannerDatas[index]];
    
    
}
-(void)updateFrame
{
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.and.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(DEF_SCREEN_WIDTH, 100));
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(-9.5);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}
- (void) navigationToAdDetailWithData:(id)data{
    
    if ([data[@"source"]  isEqual: @"03"])
    {
        JDShopGoodsDetailViewController * detail = [[JDShopGoodsDetailViewController alloc] init];
        
        detail.listGoodsInfo = data;
        
        [self.navigationController pushViewController:detail animated:YES];
       
    }else{

    // 跳转至banner详情界面
    AdvDetailViewController * detail = [[AdvDetailViewController alloc] init];
         detail.title=data[@"advertName"];
    if ([data[@"source"]  isEqual: @"02"])
    {
        
        detail.data = data[@"advertContent"];
        detail.advType = 4;
       
    }
    if([data[@"source"]  isEqual: @"01"])
    {
        
        detail.advType = 3;
        detail.externalUrl = data[@"externalUrl"];
    }
    [self.navigationController pushViewController:detail animated:YES];
        
    }
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
    JDShopListCell *cell=[JDShopListCell cellWithTableView:tableView];
    
    [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
    [cell receiveObject:^(id object) {
        [self.cartNumView getGoodsCartNum];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JDShopGoodsDetailViewController * detail = [[JDShopGoodsDetailViewController alloc] init];
    
    detail.listGoodsInfo = self.responseDatas[indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
}


-(void)baseBackBtnAction:(UIButton *)btn
{
    
    if ([self.isSearch isEqualToString:@"search"]) {
        self.searchItem.productCname=@"";
    }
    
    //判断是否有选择状态
    if (self.searchItem.productCname.length>0||self.searchItem.sort.length>0||self.searchItem.priceFilter.length>0||self.searchItem.categorySearchCode.length>0||![self.searchItem.sales isEqualToString:@"asc"])
    {
        self.searchView.searchFD.text=nil;
        self.searchItem = [[JDShopSearchItem alloc] init];
        self.priceFilter = @[[NSMutableSet setWithObjects:@(0), nil]];
        [self.topView clearFilterState];
        self.topView.item=self.searchItem;
       // [self refresh];
        [self.navigationController popViewControllerAnimated:YES];

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
        JDShopClassificationViewController *searchClassification=[[JDShopClassificationViewController alloc]init];
        searchClassification.searchItem=self.searchItem;
        [self.navigationController pushViewController:searchClassification animated:YES];
        [searchClassification receiveObject:^(id object) {
            
                self.typeId=self.searchItem.categorySearchCode;
                self.searchItem.productCname = @"";
                self.searchView.searchFD.text=@"";
                self.searchItem.typeName=@"";

                [self refresh];
                [self getPingPaiIDDataSource];


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
    
   // self.pageItem.pageSize=10;
    //self.pageItem.pageIndex=self.indeStr+1;
   // NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex
];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
#pragma mark 京东商品列表接口
    /*
     参数名	必选	类型	说明
     userId	是	string	用户ID 未登录可不传
     name	否	string	商品名称
     category	否	string	类别
     brandName	否	string	品牌
     zkPriceLess	否	string	价格小于等于
     zkPriceGreat	否	string	价格大于等于
     priceOrder	否	string	价格排序（desc降序 asc升序）
     salesVolumeOrder	否	string	销量排序（desc降序 asc升序）
     imageSize	是	string	图片大小 n0(最大图)、n1(350350px)、n2(160160px)、n3(130130px)、n4(100100px)
     pageIndex	是	string	当前页
     pageSize	是	stri
     ng	每页条数
     */
    [UserServices getJDProductListWithname:self.searchItem.productCname  category:self.searchItem.categorySearchCode brandName:self.searchItem.typeName zkPriceLess:self.zkPriceLess zkPriceGreat:self.zkPriceGreat priceOrder:self.searchItem.sort salesVolumeOrder:self.searchItem.sales imageSize:@"n0" pageIndex:pageIndex pageSize:pageSize completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            NSDictionary * data = responseObject[@"data"];
            
            NSArray*listArray=data[@"result"];
            [self responseDataList:listArray];
            if (self.pageItem.isRefresh)
            {
                if (self.responseDatas.count==0) {
                    self.tableCtrl.emptyDataSetSource = self;
                }
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
        
            
            if (listArray.count>0) {
                self.pageItem.pageIndex=[self.responseDatas.lastObject[@"currentPage"] integerValue];
            }
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }

    }];

}

#pragma mark -
#pragma mark Network M

- (void) requestBannerList
{

    [UserServices JDadvertAdvertListCompletionBlock:^(int result, id responseObject)
     {
         
         if (result == 0)
         {
             
             self.bannerView.hidden=NO;
             [self  updateFrame];
             NSArray * data = responseObject[@"data"];
            
             [self.bannerDatas removeAllObjects];
             NSMutableArray * temp = [NSMutableArray arrayWithCapacity:data.count];

             [self.bannerDatas addObjectsFromArray:data];

             if ([data count]==0)
             {
                [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                 self.bannerView.hidden=YES;
                 
             }else{
                 self.bannerView.hidden=NO;

                 for (NSDictionary * banner in self.bannerDatas)
                 {
                     [temp addObject:banner[@"advertImage"]];
                 }
             }
           
             [self.bannerView configureBannerViewWithImageData:temp];
         }
         else
         {

             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    
         
     }];
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

@end

