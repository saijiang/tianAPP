//
//  LKPageScrollView.h
//  YOUMENG
//
//  Created by Rocky Young on 16/11/24.
//  Copyright © 2016年 KZQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKPageScrollView : UIView

//滑动间隔时间
@property (nonatomic ,assign) NSTimeInterval duration;

@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger numberOfPage;

@property (nonatomic , copy) void (^contentPageRateChangeBlock)(CGFloat rateContentHeight);
@property (nonatomic , copy) void (^contentPageChangeBlock)(CGFloat fromContentHeight,CGFloat toContentHeight);

@property (nonatomic , copy) void (^didSelectPageViewAtIndex)(NSInteger currentPageIndex);

@property (nonatomic , copy) void (^currentPageIndexChangeBlock)(NSInteger currentPageIndex);
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

-(instancetype)initPageViewWithFrame:(CGRect)frame;

- (void) reloadPageViewWithData:(NSArray *)bannerList;

@end
