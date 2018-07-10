//
//  tabbarItem.h
//  ZTFramework
//
//  Created by kzss on 15/10/24.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TabbarItem : UIButton
@property(nonatomic ,strong)UIButton *badgeView;
@property(nonatomic ,copy) NSString *badgeValue;
@end
