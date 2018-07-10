//
//  LocationManger.h
//  LankeProject
//
//  Created by itman on 16/12/26.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMapHeader.h"

typedef void(^LocationBlock)(float lat, float lon);

@interface LocationManager : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

+(LocationManager *)sharedLocationManager;

@property (nonatomic, strong) BMKUserLocation *userlocationDefault;

@property (nonatomic ,strong) BMKGeoCodeSearch * geoSearch;

@property(nonatomic,strong)BMKLocationService *locService;

@property(nonatomic,strong)LocationBlock location;

@property(nonatomic,copy)NSString * city;

//判读定位是否可用
-(void)locationServicesEnabled;

-(void)startUserLocationServiceBlock:(LocationBlock)location;

@property (nonatomic ,copy) void (^bGeoResultHandle)(id result);
@end
