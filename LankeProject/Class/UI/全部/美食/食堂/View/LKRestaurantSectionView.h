//
//  LKRestaurantSectionView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSegmentView.h"

@interface LKRestaurantSectionView : UIView

@property (nonatomic ,strong) LKSegmentView * segmentView;

@property (nonatomic ,copy) void (^bSelectSegmentHandle)(LKRestaurantSectionView * sectionView ,NSInteger index,NSArray * data,NSInteger defaultSelectIndex);

- (void) updateSegmentView;
- (void) regionSelectAtIndex:(NSInteger)index row:(NSInteger)row;
- (NSArray *) currentAddressInfo;


- (NSString *) currentProvinceID;
- (NSString *) currentCityID;
- (NSString *) currentRegionID;

@end
