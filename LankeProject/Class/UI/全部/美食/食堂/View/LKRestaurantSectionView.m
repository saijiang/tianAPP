//
//  LKRestaurantSectionView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKRestaurantSectionView.h"
#import "ProvinceRegionManager.h"


@interface LKRestaurantSectionView ()

@property (nonatomic ,strong) Region * region;
@end
@implementation LKRestaurantSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        self.region = [[Region alloc] init];
        
        LKSegmentView * segmentView = [[LKSegmentView alloc] init];
        segmentView.normalImage = [UIImage imageNamed:@"ding_xiala"];
        segmentView.selectImage = [UIImage imageNamed:@"ding_xiala"];
        [segmentView configSegmentViewWithItems:[self currentAddressInfo]];
        segmentView.bSegmentViewDidSelectedItem = ^(NSInteger index){
            
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
            if (self.bSelectSegmentHandle) {
                self.bSelectSegmentHandle(self,index,data,defaultSelectIndex);
            }
        };
        [self addSubview:segmentView];
        self.segmentView = segmentView;
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


- (void) updateSegmentView{
    
    [self.segmentView updateSegmentViewWithItems:[self currentAddressInfo]];
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
@end
