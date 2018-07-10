//
//  HLLPageControl.h
//  HLLPageControl
//
//  Created by Rocky Young on 16/11/14.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLPageControl : UIView

@property (nonatomic ,assign) IBInspectable BOOL hidePageControlWhenSinglePage; // default is YES

@property(nonatomic) IBInspectable NSInteger numberOfPages;          // default is 0
@property(nonatomic ,readonly) NSInteger currentPage;

@property(nullable, nonatomic,strong) IBInspectable UIColor * pageIndicatorTintColor;
@property(nullable, nonatomic,strong) IBInspectable UIColor * currentPageIndicatorTintColor;


/** 设置当前控件的value */
- (void) setupPageControlCurrentPage:(NSInteger)currentPage;
- (void) setupPageControlCurrentPage:(NSInteger)currentPage animation:(BOOL)animation;

- (CGSize) sizeForNumberOfPages:(NSUInteger)numberOfPages;
@end
