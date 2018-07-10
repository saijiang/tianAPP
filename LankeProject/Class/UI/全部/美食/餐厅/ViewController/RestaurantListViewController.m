//
//  RestaurantListViewController.m
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "RestaurantCell.h"
#import "RestaurantHeaderView.h"
#import "SearchView.h"
#import "RestaurantDetailViewController.h"
#import "LKSegmentView.h"
#import "LocationManager.h"
#import "ProvinceRegionManager.h"
#import "LKRestaurantSectionView.h"
#import "ChooseAddressPopupContentView.h"


@interface RestaurantListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableArray;
    NSMutableArray *currenArray;
    NSString *restaurantClassStr;
    NSString *restaurantNameStr;
    
}
@property (nonatomic ,assign) BOOL defaultLoadAddressInfo;

@property (nonatomic ,strong) LKSegmentView * segmentView;
@property (nonatomic ,strong) Region * region;

@property (nonatomic,strong) UITableView *tableCtrl;
@property (nonatomic,strong) RestaurantHeaderView *headerView;
@property (nonatomic,assign) NSInteger pageNum;


@end

@implementation RestaurantListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        tableArray = [[NSMutableArray alloc] init];
        currenArray = [[NSMutableArray alloc] init];
        self.pageNum = 1;
        self.region = [[Region alloc] init];
        self.defaultLoadAddressInfo = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    restaurantClassStr = @"";
    restaurantNameStr = @"";
    [self requestData];
}

- (void)createUI
{
    
    SearchView *search=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-120, 44)];
    search.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    search.bSendTextFieldHandle = ^(NSString *text){
        restaurantNameStr = text;
        [self requestData];
    };
    [self showNavBarCustomByView:search];
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    __weak RestaurantListViewController *week=self;
    [self.tableCtrl addHeaderWithCallback:^{
        week.pageNum=1;
        [week requestData];
        [week.tableCtrl headerEndRefreshing];
    }];
    
    [self.tableCtrl addFooterWithCallback:^{
        if (currenArray.count<10)
        {
            [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
        }
        else
        {
            week.pageNum++;
            [week requestData];

        }
        [week.tableCtrl footerEndRefreshing];


    }];
    
    [self requestCategory];
}
-(RestaurantHeaderView *)headerView
{
    if (!_headerView)
    {
        self.headerView = [[RestaurantHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/2.0+70)];
        LKWeakSelf
        self.headerView.bRestaurantIndex = ^(NSString * type){
            NSLog(@".....%@",type);
            LKStrongSelf
            //掉接口
            restaurantClassStr = type;
            [_self requestData];
        };
    }
    return _headerView;
}

- (UIView *) tableHeaderView{
    
    LKWeakSelf
    CGFloat height = DEF_SCREEN_WIDTH/2.0+70;
    
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 60);
    [headerView addSubview:self.headerView];
    
    LKSegmentView * segmentView = [[LKSegmentView alloc] init];
    segmentView.frame = CGRectMake(0, self.headerView.bottom + 10, DEF_SCREEN_WIDTH, 50);
    segmentView.normalImage = [UIImage imageNamed:@"ding_xiala"];
    segmentView.selectImage = [UIImage imageNamed:@"ding_xiala"];
    [segmentView configSegmentViewWithItems:[self currentAddressInfo]];
    segmentView.bSegmentViewDidSelectedItem = ^(NSInteger index){
        
        [self selectAtIndex:index complete:^(NSArray *data, NSInteger defaultSelectIndex) {
            
            NSString * title;
            if (index == 0) {
                title = @"选择省份";
            }
            if (index == 1) {
                title = @"选择城市";
            }
            if (index == 2) {
                title = @"选择区";
            }
            ChooseAddressPopupContentView * choosepopupContentView = [[ChooseAddressPopupContentView alloc] init];
            choosepopupContentView.toolView.titleLabel.text = title;
            [choosepopupContentView configChooseViewWithData:data withTitleKey:@"regionName"];
            LKStrongSelf
            choosepopupContentView.bSureHandle = ^(id data , NSInteger row){
                self.defaultLoadAddressInfo = NO;
                
                [self.tableCtrl setContentOffset:CGPointMake(0, 0) animated:YES];
                
                [self regionSelectAtIndex:index row:row];
                
                [self.segmentView updateSegmentViewWithItems:[self currentAddressInfo]];
                
                [self requestData];
            };
            HLLPopupView * popupView = [HLLPopupView tipInWindow:choosepopupContentView];
            popupView.animationType = EPopupViewAnimationUpFromBottom;
            popupView.dimBackground=YES;
            [popupView show:YES];
        }];
    };
    self.segmentView = segmentView;
    
    [headerView addSubview:segmentView];

    return headerView;
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
        self.tableCtrl.tableHeaderView=[self tableHeaderView];
       
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
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantCell *cell=[RestaurantCell cellWithTableView:tableView];
    
    [cell loadCellWithDataSource:tableArray[indexPath.row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RestaurantDetailViewController *detail=[[RestaurantDetailViewController alloc]init];
    detail.restaurantData = tableArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark Address M


- (void) selectAtIndex:(NSInteger)index complete:(void(^)(NSArray * data,NSInteger defaultSelectIndex))bCompleteHandle{
    
    NSInteger defaultSelectIndex = 0;
    
    NSArray * data ;
    if (index == 0) {
        data = [self.region provinceInfo];
        defaultSelectIndex = self.region.selectProvinceIndex;
    }
    if (index == 1) {
        data = [self.region cityInfo];
        defaultSelectIndex = self.region.selectCityIndex;
    }
    if (index == 2) {
        data = [self.region regionInfo];
        defaultSelectIndex = self.region.selectRegionIndex;
    }
    if (bCompleteHandle) {
        bCompleteHandle(data,defaultSelectIndex);
    }
}

- (void) regionSelectAtIndex:(NSInteger)index row:(NSInteger)row{
    
    if (index == 0) {
        [self.region selectProvinceAtIdex:row];
    }
    if (index == 1) {
        [self.region selectCityAtIdex:row];
    }
    if (index == 2) {
        [self.region selectRegionAtIdex:row];
    }
}
- (NSArray *) currentAddressInfo{
    
    return @[[self.region currentProvince][@"regionName"],
             [self.region currentCity][@"regionName"],
             [self.region currentRegion][@"regionName"]];
}

- (NSString *) currentProvinceID{
    
    return [self.region currentProvince][@"regionId"];
}
- (NSString *) currentCityID{
    
    return [self.region currentCity][@"regionId"];
}
- (NSString *) currentRegionID{
    
    return [self.region currentRegion][@"regionId"];
}

#pragma mark -
#pragma mark Network M


- (void)requestData
{    
    [self.view endEditing:YES];

    [[LocationManager sharedLocationManager] startUserLocationServiceBlock:^(float lat, float lon) {
        //根据获取的经纬度
        [UserServices getBackPasswordWithRestaurantType:@"02"
                                    restaurantLongitude:[NSString stringWithFormat:@"%f",lon]
                                     restaurantLatitude:[NSString stringWithFormat:@"%f",lat]
                                             provinceId:[self currentProvinceID]
                                                 cityId:[self currentCityID]
                                             districtId:[self currentRegionID]
                                         restaurantName:restaurantNameStr
                                        restaurantClass:restaurantClassStr
                                              pageIndex:[NSString stringWithFormat:@"%d",self.pageNum]
                                               pageSize:@"10"
                                        completionBlock:^(int result, id responseObject)
         {
             if (self.defaultLoadAddressInfo) {
                 return ;
             }
             if ([responseObject[@"status"] integerValue] == 0)
             {
                 if (self.pageNum==1)
                 {
                     [currenArray removeAllObjects];
                 }
                 [tableArray removeAllObjects];
                 [currenArray addObjectsFromArray:responseObject[@"data"]];
                 [tableArray addObjectsFromArray:currenArray];
                 [self.tableCtrl reloadData];
             }else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }]; 
    }];
    
    
    [LocationManager sharedLocationManager].bGeoResultHandle = ^(NSDictionary * data){
        
        if (self.defaultLoadAddressInfo) {
            
            [self.region defaultSelectWithAddressInfo:data];
            
            [self.segmentView updateSegmentViewWithItems:[self currentAddressInfo]];
            
            [self requestData];
        }
        self.defaultLoadAddressInfo = NO;
    };

}


- (void)requestCategory{

    [UserServices restaurantRestaurantCompletionBlock:^(int result, id responseObject) {
       
        if ([responseObject[@"status"] integerValue] == 0)
        {
            [self.headerView config:responseObject[@"data"]];
        }else
        {

        }
    }];
}
@end
