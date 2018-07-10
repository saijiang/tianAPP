//
//  GPSLocationManager.m
//  MHProject
//
//  Created by MengHuan on 15/5/4.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "GPSLocationManager.h"
#import "MHLocationConverter.h"

@interface GPSLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;   // 定位管理器
@property (assign, nonatomic) CLLocationDistance longitude;         // 经度
@property (assign, nonatomic) CLLocationDistance latitude;          // 纬度
@property (strong, nonatomic) CLGeocoder *geocoder;                 // 位置反编译

@end

@implementation GPSLocationManager

singleton_for_class(GPSLocationManager)


#pragma mark - 开启GPS定位
- (void)startGPSLocation
{
    // 检查是否开启了定位服务
    if (![CLLocationManager locationServicesEnabled])
    {
        // 定位不可用
        DEF_DEBUG(@"定位服务没有开启");
        
        return;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    // 判斷是否 iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //        [self.locationManager requestAlwaysAuthorization];      // 永久授权
        [self.locationManager requestWhenInUseAuthorization];   //使用中授权
    }
    
    self.locationManager.delegate = self;
    
    // 所需的位置精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 指定用米的最小距离更新
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    // 开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    DEF_DEBUG(@"设备旋转指向:%u",status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DEF_DEBUG(@"定位失败:%@",error);
    
    // GPS 定位失败
    if (self.gpsFailureBlock)
    {
        self.gpsFailureBlock();
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // WGS-84坐标转为BD-09坐标
    CLLocationCoordinate2D coord = [MHLocationConverter wgs84ToBd09:newLocation.coordinate];
    
    DEF_DEBUG(@"GPS 定位转换为百度地图用的经度:%f, 纬度:%f", coord.longitude, coord.latitude);
    
    // 得到转换后的经纬度
    self.longitude  = coord.longitude;
    self.latitude   = coord.latitude;
    
    // GPS 定位成功
    if (self.gpsSuccessBlock)
    {
        self.gpsSuccessBlock(self.longitude, self.latitude);
    }
}

#pragma mark - 停止定位
- (void)stopGPSLocation
{
    [self.locationManager stopUpdatingLocation];
}

//#pragma mark - 通过经纬度坐标获取当前地理位置
//- (void)gpsLocationInfoByLong:(CLLocationDistance)longitude
//                          lat:(CLLocationDistance)latitude
//                 locationInfo:(void (^)(NSDictionary *gpsInfoDict))info
//{
//    /**
//     *  反编译经纬度
//     */
//
//    // 防止循环引用
//    __unsafe_unretained typeof(self) _self  = self;
//
//    _self.geocoder = [[CLGeocoder alloc] init];
//    [_self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:_self.latitude longitude:_self.longitude]
//                         completionHandler:^(NSArray *placemarks, NSError *error) {
//
//                             // 当前位置的数据信息
//                             NSDictionary *addressDict = [NSDictionary dictionary];
//
//                             if (error == nil && placemarks.count > 0)
//                             {
//                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
//
//                                 // 收到的结果
//                                 DEF_DEBUG(@"国家: %@", placemark.country);
//                                 DEF_DEBUG(@"邮政编码: %@", placemark.postalCode);
//                                 DEF_DEBUG(@"位置: %@", placemark.locality);
//                                 DEF_DEBUG(@"地理信息数据: %@", placemark.addressDictionary);
//                                 DEF_DEBUG(@"地址线: %@", [placemark.addressDictionary objectForKey:@"FormattedAddressLines"]);
//                                 DEF_DEBUG(@"详细地址: %@", [placemark.addressDictionary objectForKey:@"Name"]);
//                                 DEF_DEBUG(@"城市: %@", [placemark.addressDictionary objectForKey:@"State"]);
//                                 DEF_DEBUG(@"城市区域: %@", [placemark.addressDictionary objectForKey:@"SubLocality"]);
//                                 DEF_DEBUG(@"街道地址: %@", [placemark.addressDictionary objectForKey:@"Street"]);
//                                 DEF_DEBUG(@"街道名: %@", [placemark.addressDictionary objectForKey:@"Thoroughfare"]);
//                                 DEF_DEBUG(@"所在街道号段: %@", [placemark.addressDictionary objectForKey:@"SubThoroughfare"]);
//
//
//                                 addressDict = placemark.addressDictionary;
//                             }
//                             else if (error == nil && placemarks.count == 0)
//                             {
//                                 DEF_DEBUG(@"经纬度逆编译没有结果返回");
//                             }
//                             else if (error != nil)
//                             {
//                                 DEF_DEBUG(@"经纬度逆编译错误: %@", error);
//                             }
//
//                             // block回调
//                             if (info)
//                             {
//                                 info(addressDict);
//                             }
//                         }];
//}

#pragma mark - 通过经纬度坐标获取当前地理位置
- (void)gpsLocationInfoByLong:(CLLocationDistance)longitude
                          lat:(CLLocationDistance)latitude
                 locationInfo:(void (^)(CLPlacemark *gpsInfo))info
{
    /**
     *  反编译经纬度
     */
    
    // 传入的坐标系是BD-09的
    CLLocationCoordinate2D coord;
    coord.longitude = longitude;
    coord.latitude  = latitude;
    
    // 从BD-09坐标转回到GCJ-02，再进行位置转化
    CLLocationCoordinate2D newCoord = [MHLocationConverter bd09ToGcj02:coord];
    
    // 防止循环引用
    __unsafe_unretained typeof(self) _self  = self;
    
    _self.geocoder = [[CLGeocoder alloc] init];
    [_self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:newCoord.latitude longitude:newCoord.longitude]
                         completionHandler:^(NSArray *placemarks, NSError *error) {
                             
                             // 当前位置的数据信息
                             if (error == nil && placemarks.count > 0)
                             {
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 
                                 DEF_DEBUG(@"定位结果: %@", placemark);
                                 
                                 // block回调
                                 if (info)
                                 {
                                     info(placemark);
                                 }
                             }
                             else if (error == nil && placemarks.count == 0)
                             {
                                 DEF_DEBUG(@"经纬度逆编译没有结果返回");
                             }
                             else if (error != nil)
                             {
                                 DEF_DEBUG(@"经纬度逆编译错误: %@", error);
                             }
                         }];
}



#pragma mark - block
- (void)addGpsSuccessCallback:(void (^)(CLLocationDistance longitude, CLLocationDistance latitude))callback
{
    self.gpsSuccessBlock = callback;
}

- (void)addGpsFailureCallback:(void (^)())callback
{
    self.gpsFailureBlock = callback;
}


@end
