//
//  JDFilterHeaderView.h
//  LankeProject
//
//  Created by zhounan on 2017/12/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDFilterHeaderView : UICollectionReusableView
- (void) configureHeaderViewWithData:(id)data;
@property (nonatomic ,strong) UIButton * filterButton;//选中的品牌

+ (NSString *) reuseIdentifier;
@end
