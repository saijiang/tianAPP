//
//  ProvinceRegionManager.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/19.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceRegionManager : NSObject

+ (ProvinceRegionManager *)sharedRegionManager;

- (NSArray *) provinceRegionInfo;
@end


@interface Region : NSObject

@property (nonatomic ,assign ,readonly) NSInteger selectProvinceIndex;
@property (nonatomic ,assign ,readonly) NSInteger selectCityIndex;
@property (nonatomic ,assign ,readonly) NSInteger selectRegionIndex;


- (void) defaultSelectWithAddressInfo:(id)addressInfo;

- (id) currentProvince;
- (id) currentCity;
- (id) currentRegion;

- (NSArray *) provinceInfo;
- (NSArray *) cityInfo;
- (NSArray *) regionInfo;

- (void) selectProvinceAtIdex:(NSInteger)index;
- (void) selectCityAtIdex:(NSInteger)index;
- (void) selectRegionAtIdex:(NSInteger)index;

@end

typedef void(^LKReloadData)();
@interface District : NSObject




@property (nonatomic ,assign ,readonly) NSInteger selectProvinceIndex;
@property (nonatomic ,assign ,readonly) NSInteger selectCityIndex;
@property (nonatomic ,assign ,readonly) NSInteger selectRegionIndex;
@property (nonatomic ,assign ,readonly) NSInteger selectDistrictIndex;

@property(nonatomic,strong)LKReloadData lkReloadData;

-(void)lkReloadData:(LKReloadData)lkReloadData;


- (void) defaultSelectWithAddressInfo:(id)addressInfo;

- (id) currentProvince;
- (id) currentCity;
- (id) currentRegion;
- (id) currentDistrict;

- (NSArray *) provinceInfo;
- (NSArray *) cityInfo;
- (NSArray *) regionInfo;
- (NSArray *) districtInfo;

- (void) selectProvinceAtIdex:(NSInteger)index;
- (void) selectCityAtIdex:(NSInteger)index;
- (void) selectRegionAtIdex:(NSInteger)index;
- (void) selectDistrictAtIdex:(NSInteger)index;

@end
