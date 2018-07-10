//
//  LKWeatherView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKWeatherView : UIView

- (void) updateWeatherData;

- (void) configWeatherViewWithData:(id)data;

- (void) show;
- (void) hide;
@end
