//
//  CitySelectionView.h
//  LankeProject
//
//  Created by itman on 16/12/20.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

// 最后选择的结果是“四川 成都 武侯区”
typedef void(^CitySelectedResult)(id result);

@interface CitySelectionView : UIView

@property (nonatomic ,copy) CitySelectedResult resultBlock;


- (void) showCitySelectViewAtView:(UIView *)view;
/**
 *  一种情况是已经有了区域再展示该视图，可以让选择是否滚动到该区域所在的位置
 *
 *  @param cityInfo “四川 成都 武侯区” or "北京 西城"
 */
- (void) scrollToCityLocationWithCityInfo:(NSString *)cityInfo;

- (void) citySelectLocation:(CitySelectedResult)resultBlock;

@end
