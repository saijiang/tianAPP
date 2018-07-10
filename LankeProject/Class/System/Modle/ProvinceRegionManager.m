//
//  ProvinceRegionManager.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/19.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ProvinceRegionManager.h"

@interface ProvinceRegionManager ()

@property (nonatomic ,strong) NSArray * provinceList;

@end

@implementation ProvinceRegionManager

+ (ProvinceRegionManager *)sharedRegionManager
{
    static ProvinceRegionManager *skManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skManager = [[self alloc] init];
//        [skManager loadRegionInfo];
        [skManager getAddressInfoFromRequest];
    });
    return skManager;
}

- (void)loadRegionInfo{

    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"]];
    
    NSError * error = nil;
    
    NSArray * datas = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        return ;
    }
    
    self.provinceList = datas;
    
    DEF_DEBUG(@"count:%lu",(unsigned long)datas.count);
}

- (NSArray *)provinceRegionInfo{

    return self.provinceList;
}

- (void) getAddressInfoFromRequest{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserServices getAddressInfoCompletionBlock:^(int result, id responseObject) {
            
            if (result == 0)
            {
                id datas = responseObject[@"data"];
                
                
                self.provinceList = datas;
            }
            else
            {
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    });
   
}
@end

@interface Region ()

@property (nonatomic ,strong) NSMutableArray * provinceList;

@property (nonatomic ,strong) NSMutableArray * cityList;

@property (nonatomic ,strong) NSMutableArray * regionList;

@property (readwrite) NSInteger selectProvinceIndex;
@property (readwrite) NSInteger selectCityIndex;
@property (readwrite) NSInteger selectRegionIndex;
@end

@implementation Region

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.provinceList = [NSMutableArray array];
        
        [self.provinceList addObject:@{@"regionName":@"全部",
                                       @"regionId":@""}];
        [_provinceList addObjectsFromArray:[[ProvinceRegionManager sharedRegionManager] provinceRegionInfo]];
        
        _selectProvinceIndex = 0;
        _selectCityIndex = 0;
        _selectRegionIndex = 0;
        
        _cityList = [NSMutableArray array];
        _regionList = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark Getter

- (id) currentProvince{
    
    return [self provinceInfo][self.selectProvinceIndex];
}

- (id) currentCity{

    return [self cityInfo][self.selectCityIndex];
}

- (id) currentRegion{
    
    return [self regionInfo][self.selectRegionIndex];
}

- (NSArray *)provinceInfo{
    
    return self.provinceList;
}

- (NSArray *)cityInfo{
    
    if (!self.cityList.count) {
        [self selectProvinceAtIdex:0];
    }
    return self.cityList;
}

- (NSArray *)regionInfo{
    
    if (!self.regionList.count) {
        [self selectCityAtIdex:0];
    }
    return self.regionList;
}

- (void) clear{
    
    self.selectProvinceIndex = 0;
    self.selectCityIndex = 0;
    self.selectRegionIndex = 0;
    
    [self.cityList removeAllObjects];
    [self.regionList removeAllObjects];
}

#pragma mark -
#pragma mark Select

- (void) defaultSelectWithAddressInfo:(id)addressInfo{
    
    NSString * province = addressInfo[@"province"];
    NSString * city = addressInfo[@"city"];
    NSString * region = addressInfo[@"region"];
    
    NSInteger p_index = 0;
    NSInteger c_index = 0;
    NSInteger r_index = 0;
    
    for (NSInteger index = 0;index < self.provinceInfo.count;index ++) {
        
        NSDictionary * p_data = self.provinceInfo[index];
        if ([p_data[@"regionName"] isEqualToString: province]) {
            p_index = index;
            [self selectProvinceAtIdex:index];
            break;
        }
    }
    
    for (NSInteger index = 0;index < self.cityInfo.count;index ++) {
        
        NSDictionary * c_data = self.cityInfo[index];
        if ([c_data[@"regionName"] isEqualToString:city]) {
            c_index = index;
            [self selectCityAtIdex:index];
            break;
        }
    }
    // change for 20170328: 13.三级联动 第一进入 定位到当前城市 也就是说 上海 上海 全部
    /*for (NSInteger index = 0;index < self.regionInfo.count;index ++) {
        
        NSDictionary * r_data = self.regionInfo[index];
        if ([r_data[@"regionName"] isEqualToString:region]) {
            r_index = index;
             [self selectRegionAtIdex:r_index];
            break;
        }
    }*/
    [self selectRegionAtIdex:r_index];
    
}

- (void) selectProvinceAtIdex:(NSInteger)index{
    
    //NSAssert(index < self.provinceList.count, @"index has great than provinceList count");
    
    self.selectProvinceIndex = index;
    self.selectCityIndex = 0;
    self.selectRegionIndex = 0;
    
    [self.cityList removeAllObjects];
    [self.regionList removeAllObjects];
    
    id provinceData = self.provinceList[self.selectProvinceIndex];
    
    NSArray * cityInfo = provinceData[@"cityList"];
    
    [self.cityList addObject:@{@"regionName":@"全部",
                               @"regionId":@""}];
    if (cityInfo) {
        [self.cityList addObjectsFromArray:cityInfo];
    }
}

- (void) selectCityAtIdex:(NSInteger)index{
    
    //NSAssert(index < self.cityList.count, @"index has great than cityList count");
    
    self.selectCityIndex = index;
    self.selectRegionIndex = 0;
    
    [self.regionList removeAllObjects];
    
    id cityData = self.cityList[self.selectCityIndex];
    
    NSArray * regionInfo = cityData[@"areaList"];
    
    [self.regionList addObject:@{@"regionName":@"全部",
                                 @"regionId":@""}];
    if (regionInfo) {
        [self.regionList addObjectsFromArray:regionInfo];
    }
}

- (void) selectRegionAtIdex:(NSInteger)index{
    
    self.selectRegionIndex = index;
}

@end

@interface District ()

@property (nonatomic ,strong) NSMutableArray * provinceList;

@property (nonatomic ,strong) NSMutableArray * cityList;

@property (nonatomic ,strong) NSMutableArray * regionList;

@property (nonatomic ,strong) NSMutableArray * districtList;


@property (readwrite) NSInteger selectProvinceIndex;
@property (readwrite) NSInteger selectCityIndex;
@property (readwrite) NSInteger selectRegionIndex;
@property (readwrite) NSInteger selectDistrictIndex;

@end

@implementation District

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _provinceList = [NSMutableArray array];
        _cityList = [NSMutableArray array];
        _regionList = [NSMutableArray array];
        _districtList = [NSMutableArray array];

        _selectProvinceIndex = 0;
        _selectCityIndex = 0;
        _selectRegionIndex = 0;
        _selectDistrictIndex = 0;
        
        [_provinceList addObjectsFromArray:[[ProvinceRegionManager sharedRegionManager] provinceRegionInfo]];
        
       
    }
    return self;
}


#pragma mark -
#pragma mark Getter

- (id) currentProvince{
    
    return [self provinceInfo][self.selectProvinceIndex];
}

- (id) currentCity{
    
    return [self cityInfo][self.selectCityIndex];
}

- (id) currentRegion{
    
    return [self regionInfo][self.selectRegionIndex];
}

- (id) currentDistrict{
    if ([[self districtInfo] count]>0) {
        return [self districtInfo][self.selectDistrictIndex];

    }
    return @{@"regionName":@"",@"regionId":@""};

 
}
- (NSArray *)provinceInfo{
    
    return self.provinceList;
}

- (NSArray *)cityInfo{
    
    if (!self.cityList.count) {
        [self selectProvinceAtIdex:0];
    }
    return self.cityList;
}

- (NSArray *)regionInfo{
    
    if (!self.regionList.count) {
        [self selectCityAtIdex:0];
    }
    return self.regionList;
}

- (NSArray *)districtInfo{
    if (!self.districtList.count) {
//        [self selectRegionAtIdex:0];
    }
    return self.districtList;
    
}
- (NSString *) currentProvinceID
{
    return [self currentProvince][@"regionId"];
}
- (NSString *) currentCityID
{
    return [self currentCity][@"regionId"];
}
- (NSString *) currentRegionID
{
    return [self currentRegion][@"regionId"];
}
- (NSString *) currentDistrictID
{
    return [self currentDistrict][@"regionId"];
}

- (void) clear
{
    
    self.selectProvinceIndex = 0;
    self.selectCityIndex = 0;
    self.selectRegionIndex = 0;
    self.selectDistrictIndex = 0;

    [self.cityList removeAllObjects];
    [self.regionList removeAllObjects];
    [self.districtList removeAllObjects];

}

#pragma mark -
-(void)lkReloadData:(LKReloadData)lkReloadData
{
    if (lkReloadData)
    {
        self.lkReloadData=lkReloadData;
    }
}
#pragma mark Select


- (void) defaultSelectWithAddressInfo:(id)addressInfo
{
    
    NSString * province = addressInfo[@"province"];
    NSString * city = addressInfo[@"city"];
    NSString * region = addressInfo[@"region"];
    
    NSInteger p_index = 0;
    NSInteger c_index = 0;
    NSInteger r_index = 0;
    NSInteger d_index = 0;

    for (NSInteger index = 0;index < self.provinceInfo.count;index ++) {
        
        NSDictionary * p_data = self.provinceInfo[index];
        NSString *regionName=p_data[@"regionName"];
        if ([province containsString:regionName]) {
            p_index = index;
            [self selectProvinceAtIdex:index];
            break;
        }
    }
    
    for (NSInteger index = 0;index < self.cityInfo.count;index ++) {
        
        NSDictionary * c_data = self.cityInfo[index];
        NSString *regionName=c_data[@"regionName"];
        if ([city containsString:regionName]) {
            c_index = index;
            [self selectCityAtIdex:index];
            break;
        }
    }
    for (NSInteger index = 0;index < self.regionInfo.count;index ++) {
        
        NSDictionary * c_data = self.regionInfo[index];
        NSString *regionName=c_data[@"regionName"];
        if ([region containsString:regionName]) {
            r_index = index;
            [self selectRegionAtIdex:index];
            break;
        }
    }
    // change for 20170328: 13.三级联动 第一进入 定位到当前城市 也就是说 上海 上海 全部
    /*for (NSInteger index = 0;index < self.regionInfo.count;index ++) {
     
     NSDictionary * r_data = self.regionInfo[index];
     if ([r_data[@"regionName"] isEqualToString:region]) {
     r_index = index;
     [self selectRegionAtIdex:r_index];
     break;
     }
     }*/
    [self selectDistrictAtIdex:d_index];
    
}

- (void) selectProvinceAtIdex:(NSInteger)index{
    
    //NSAssert(index < self.provinceList.count, @"index has great than provinceList count");
    
    self.selectProvinceIndex = index;
    self.selectCityIndex = 0;
    self.selectRegionIndex = 0;
    self.selectDistrictIndex = 0;

    [self.cityList removeAllObjects];
    [self.regionList removeAllObjects];
    
    id provinceData = self.provinceList[self.selectProvinceIndex];
    
    NSArray * cityInfo = provinceData[@"cityList"];
    if (cityInfo) {
        [self.cityList addObjectsFromArray:cityInfo];
    }
}
- (void) selectCityAtIdex:(NSInteger)index{
    
    self.selectCityIndex = index;
    self.selectRegionIndex = 0;
    self.selectDistrictIndex = 0;

    [self.regionList removeAllObjects];
    
    id cityData = self.cityList[self.selectCityIndex];
    
    NSArray * regionInfo = cityData[@"areaList"];
    
    if (regionInfo) {
        [self.regionList addObjectsFromArray:regionInfo];
    }
}
- (void) selectRegionAtIdex:(NSInteger)index 
{
    //NSAssert(index < self.cityList.count, @"index has great than cityList count");
    self.selectRegionIndex = index;
    self.selectDistrictIndex = 0;
    [self.districtList removeAllObjects];

    [UserServices
     getDistrictListWithProvinceId:[self currentProvinceID]
     cityId:[self currentCityID]
     countyId:[self currentRegionID]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.districtList removeAllObjects];
             NSDictionary *dataSource=responseObject[@"data"];
             for (NSDictionary *data in dataSource)
             {
                 NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                 [dic setValue:data[@"districtId"] forKey:@"regionId"];
                 [dic setValue:data[@"districtName"] forKey:@"regionName"];
                 [self.districtList addObject:dic];
                 
             }
            self.lkReloadData();
             
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
   
   
}
- (void) selectDistrictAtIdex:(NSInteger)index
{
    self.selectDistrictIndex = index;

}

@end

