//
//  SelectAddressViewController.m
//  LankeProject
//
//  Created by itman on 16/12/23.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "SelectAddressViewController.h"

#import "BaiduMapHeader.h"
#import "NearAddressView.h"
#import "SearchView.h"

#import "ChooseCityViewController.h"
#import "LocationManager.h"

@interface SelectAddressViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)NearAddressView *nearAddressView;
@property(nonatomic,strong)BMKPoiSearch*searcher;//根据关键字搜索
@property(nonatomic,strong)BMKNearbySearchOption *option;//附近搜索
@property(nonatomic,strong)BMKGeoCodeSearch *codeSearch;//根据城市获取位置信息
@property(nonatomic,strong)SearchView *search;
@property(nonatomic,strong)UIButton *cityBtn;
@property(nonatomic,strong)NSString *city;

@end

@implementation SelectAddressViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _searcher.delegate = self;
    _locService.delegate = self;
    _codeSearch.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _searcher.delegate = nil;
    _locService.delegate = nil;
    _codeSearch.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
//根据城市搜索
-(void)citySearch:(NSString *)city
{
    //初始化检索对象
    if (!_codeSearch)
    {
        _codeSearch =[[BMKGeoCodeSearch alloc]init];
    }
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= city;
    geoCodeSearchOption.address= city;
    BOOL flag = [_codeSearch geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}

//名称搜索
-(void)geoCodeSearch:(NSString *)address
{
    
    //根据搜索的结果发起检索
    self.option.keyword =address;
    BOOL flag = [_searcher poiSearchNearBy:self.option];
    if(flag)
    {
        DEF_DEBUG(@"周边检索发送成功");
    }
    else
    {
        DEF_DEBUG(@"周边检索发送失败");
        
    }
    
}

//周边搜索
-(void)poiSearchNearBy
{
    //发起检索
    self.option.keyword = @"房子";
    self.option.location=self.mapView.centerCoordinate;
    BOOL flag = [_searcher poiSearchNearBy:self.option];
    if(flag)
    {
        DEF_DEBUG(@"周边检索发送成功");
    }
    else
    {
        DEF_DEBUG(@"周边检索发送失败");
    }
    
}

//添加大头针
-(void)addAnnotation:(BMKUserLocation *)addAnnotation
{
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = addAnnotation.location.coordinate.latitude;
    coor.longitude = addAnnotation.location.coordinate.longitude;
    annotation.coordinate = coor;
    annotation.title = addAnnotation.title;
    [_mapView addAnnotation:annotation];
    
}
-(NSString *)city
{
    if (!_city)
    {
        _city=[LocationManager sharedLocationManager].city;
    }
    return _city;
}

-(void)setData:(NSDictionary *)data
{
    _data=data;
    if (data)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.cityBtn setTitle:data[@"city"] forState:UIControlStateNormal];
            [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([data[@"addressLatitude"] floatValue], [data[@"addressLongitude"] floatValue]) animated:NO];
            _search.searchFD.text=data[@"areaInfo"];
            [self geoCodeSearch:_search.searchFD.text];
            [_search.searchFD becomeFirstResponder];
        });
 
    }
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustom];
    [self initBMKMapView];
    [[LocationManager sharedLocationManager] locationServicesEnabled];
}
-(void)showNavBarCustom
{
    [self showRightBarButtonItemHUDByName:@"取消"];
    [self.rightButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-90, 44)];
    self.cityBtn=[UnityLHClass masonryButton:self.city imageStr:@"ding_dingwei" font:16.0 color:BM_Color_Blue];
    [topView addSubview:self.cityBtn];
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.left.mas_equalTo(topView.mas_left);
        make.width.mas_equalTo(60);
    }];
    _search=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-120, 44)];
    _search.searchFD.placeholder=@"输入地点进行搜索";
    [topView addSubview:_search];
    [_search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.left.mas_equalTo(self.cityBtn.mas_right).offset(10);
        make.right.mas_equalTo(topView.mas_right);
        make.height.mas_equalTo(44);
    }];
    
    [self showNavBarCustomByView:topView];
    [_search receiveObject:^(id object)
    {
        [self geoCodeSearch:object];
    }];
    

     [self.cityBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
         ChooseCityViewController *city=[[ChooseCityViewController alloc]init];
         [self.navigationController pushViewController:city animated:YES];
         [city receiveObject:^(id object) {
             [self.cityBtn setTitle:object forState:UIControlStateNormal];
             [self citySearch:object];
         }];
     }];
}
-(void)initBMKMapView
{
    //初始化BMKMapView
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.5);
    }];
    LocalhostImageView *locationImage=[[LocalhostImageView alloc]init];
    locationImage.image=[UIImage imageNamed:@"ding_dingwei"];
    [_mapView addSubview:locationImage];
    [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_mapView);
        make.width.and.height.mas_equalTo(30);
    }];
    
    
    //底部附近列表
    _nearAddressView=[[NearAddressView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_nearAddressView];
    [_nearAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mapView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    //BMKPoiInfo 返回地理位置信息
    [_nearAddressView receiveObject:^(id object)
    {
        BMKPoiInfo *info=(BMKPoiInfo *)object;
        [self sendObject:info];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
    
    
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showsUserLocation = NO;//显示定位图层
    _mapView.zoomLevel=18.0;
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    //启动LocationService
    [_locService startUserLocationService];
    
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    self.option = [[BMKNearbySearchOption alloc]init];
    self.option.pageIndex = 0;
    self.option.pageCapacity = 10;
    self.option.radius=2000;
    self.option.sortType=BMK_POI_SORT_BY_DISTANCE;
    self.option.keyword = @"房子";
   
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

/**
 *地图初始化完毕时会调用此接口
 *@param mapview 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    
}
/**
 *地图区域改变时会调用此接口
 *@param mapview 地图View
 */
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self poiSearchNearBy];
 
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) animated:NO];
    [self poiSearchNearBy];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)location errorCode:(BMKSearchErrorCode)error
{
    [_mapView setCenterCoordinate:location.location animated:NO];
    //发起检索
    self.option.location = location.location;
    //根据地址检索地理位置
    //发起检索
    BOOL flag = [_searcher poiSearchNearBy:self.option];
    if(flag)
    {
        DEF_DEBUG(@"检索发送成功");
    }
    else
    {
        DEF_DEBUG(@"检索发送失败");
        
    }
    
    
    
}

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        //在此处理正常结果
        [self.nearAddressView loadNearAddressWithDataSource:poiResult.poiInfoList];
    }
    else
    {
        [UnityLHClass showAlertView:@"抱歉，未找到结果"];
        [self.nearAddressView loadNearAddressWithDataSource:nil];

    }

}
-(void)didBeginEditing
{
    [_nearAddressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mapView.mas_top);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

-(void)baseRightBtnAction:(UIButton *)btn
{
    [self.search.searchFD endEditing:NO];
    self.search.searchFD.text=nil;
    [self poiSearchNearBy];
    [_nearAddressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mapView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
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
