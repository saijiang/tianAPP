//
//  LKHomeBannerView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLPageControl.h"
#import "LKPageScrollView.h"

@interface LKHomeBannerView : UIView

@property (strong, nonatomic, readonly) LKPageScrollView *myPageView;
@property (strong, nonatomic, readonly) HLLPageControl *myPageControl;

@property (strong, nonatomic) NSArray *curBannerList;

- (void) configureBannerViewWithBannerList:(NSArray *)bannerList;


@end
