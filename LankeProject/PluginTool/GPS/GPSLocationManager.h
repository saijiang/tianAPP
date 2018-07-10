//
//  GPSLocationManager.h
//  MHProject
//
//  Created by MengHuan on 15/5/4.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//


/**
 // GPS定位获取经纬度
 #import <CoreLocation/CoreLocation.h>
 
// 定位用法
- (void)gpsLocate
{
    // 防止循环引用
    __unsafe_unretained typeof([GPSLocationManager sharedGPSLocationManager]) gps = [GPSLocationManager sharedGPSLocationManager];
    
    // 开启定位
    [gps startGPSLocation];
    
    // 定位结果
    gps.gpsFailureBlock = ^() {
        // 定位失败
        self.longitude  = [DEF_PERSISTENT_GET_OBJECT(@"gps_longitude") doubleValue];
        self.latitude   = [DEF_PERSISTENT_GET_OBJECT(@"gps_latitude") doubleValue];
        
        NSLog(@"定位失败，取上一次记录的经纬度: %f,%f", self.longitude, self.latitude);
    };
    
    gps.gpsSuccessBlock = ^(CLLocationDistance longitude, CLLocationDistance latitude) {
        
        // 停止定位
        [gps stopGPSLocation];
        
        // 定位成功
        self.longitude  = longitude;
        self.latitude   = latitude;
        
        NSLog(@"定位成功，经度:%f, 纬度:%f", self.longitude, self.latitude);
 
        // 逆编译地区
        [gps gpsLocationInfoByLong:longitude lat:latitude locationInfo:^(CLPlacemark *gpsInfo) {
            //
            NSLog(@"写法一，当前地理位置信息: %@", gpsInfo);
            
            // 获取城市
            NSString *city = gpsInfo.locality;
            if (!city)
            {
                
                // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = gpsInfo.administrativeArea;
            }
            
            NSLog(@"city = %@", city);
            
            NSMutableString *mutable = [[NSMutableString alloc] initWithString:city];
            
            if ([mutable rangeOfString:@"市辖区"].location != NSNotFound)
            {
                [mutable deleteCharactersInRange:NSMakeRange([mutable length]-3, 3)];
                city = mutable;
            }
        }];
    };
}
 */



/**
 *  GPSLocationManager GPS定位
 *
 *  iOS8的情况下，info里需设置
 *  key: NSLocationAlwaysUsageDescription value: 为空即可
 *  key: NSLocationWhenInUseUsageDescription value: “这里设置自定义定位提示语”
 *
 * 	@framework
 *
 *      MapKit.framework
 */


#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"

// GPS定位
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GPSLocationManager : NSObject <CLLocationManagerDelegate>

singleton_for_header(GPSLocationManager)


#pragma mark - GPS定位成功与失败的回调block
/**
 *  GPS 定位成功与失败的block
 */
@property (nonatomic, copy) void (^gpsSuccessBlock)(CLLocationDistance longitude, CLLocationDistance latitude);
@property (nonatomic, copy) void (^gpsFailureBlock)();

- (void)addGpsSuccessCallback:(void (^)(CLLocationDistance longitude, CLLocationDistance latitude))callback;
- (void)addGpsFailureCallback:(void (^)())callback;

#pragma mark - 开启/停止 GPS定位
/**
 *  开启GPS定位
 *  停止GPS定位
 */
- (void)startGPSLocation;
- (void)stopGPSLocation;


#pragma mark - 通过经纬度坐标获取当前地理位置
/**
 *  通过经纬度坐标获取当前地理位置
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 */
- (void)gpsLocationInfoByLong:(CLLocationDistance)longitude
                          lat:(CLLocationDistance)latitude
                 locationInfo:(void (^)(CLPlacemark *gpsInfo))info;

@end
