//
//  LocationManger.m
//  LankeProject
//
//  Created by itman on 16/12/26.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CLLocationManager.h>

@implementation LocationManager

-(void)dealloc
{
    _locService.delegate=nil;
    _geoSearch.delegate = nil;
}

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate=self;
        _userlocationDefault = [[BMKUserLocation alloc] init];

        _geoSearch = [[BMKGeoCodeSearch alloc] init];
        _geoSearch.delegate = self;
    }
    return self;
}

+ (LocationManager *)sharedLocationManager
{
    static LocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;

}

-(void)locationServicesEnabled
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位失败，请检查是否打开了定位权限，您可以进入系统“设置>隐私>定位服务“,允许航服务访问您的位置。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                     }];
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self.topViewController presentViewController:alert animated:YES completion:nil];
    }
}

-(void)startUserLocationServiceBlock:(LocationBlock)location
{
    self.location=[location copy];
    [_locService startUserLocationService];
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = userLocation.location.coordinate;
    BOOL canReverseGeo = [self.geoSearch reverseGeoCode:option];
    DEF_DEBUG(@"%hhd",canReverseGeo);
    [_locService stopUserLocationService];
    
    if (self.location) {
        self.location(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号 -- 返回固定的坐标 北京
 */
- (void)didFailToLocateUserWithError:(NSError *)error;
{
   
    if (self.location)
    {
        self.location(39.5427,116.2317);
    }
}

#pragma mark -
#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{

    NSString * province = result.addressDetail.province;
    NSString * city = result.addressDetail.city;
    NSString * region = result.addressDetail.district;
    
    if ([province containsString:@"市"]) {
        province = [province substringToIndex:province.length - 1];
    }
    
    //异常处理
    if (province == nil)
    {
        province = @"北京";
    }
    if (city == nil)
    {
        city = @"北京";
    }
    if (region == nil)
    {
        region = @"北京";
    }
    
    self.city=city;
    NSDictionary * addressInfo = @{@"province":province,
                                   @"city":city,
                                   @"region":region};
    if (self.bGeoResultHandle) {
        self.bGeoResultHandle(addressInfo);
    }
}

@end
