//
//  LoopScrollView.h
//  bannerScroll
//
//  Created by Appolls on 15-2-9.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPageControlView.h"
#import "HLLPageControl.h"
/**
 *  广告样式
 */

typedef NS_ENUM(NSInteger, AdBannerStyle) {
    AdBannerStyleDefault = 0,
    AdBannerStyleTitle
};

/**
 *  轮播代理
 */
@class LoopScrollView;
@protocol LoopScrollViewDelegate <NSObject>

@optional

// 广告页点击选中
- (void) loopScrollView : (LoopScrollView*) loopScrollView didSelectIndex : (NSInteger) index didSelectImage : (UIImage*) image;

// 设置广告页标题
- (void) loopScrollViewTitle : (LoopScrollView*) loopScrollView didSelectIndex : (NSInteger) index;

@end


@interface LoopScrollView : UIView <UIScrollViewDelegate>{
    UIScrollView    *myScrollView;
    
    UIView * shadow;
    
    UIImageView *firstView;
    UIImageView *secondView;
    UIImageView *thirdView;
    
    NSArray         *imageArray;
    NSMutableArray  *showArray;
    
    NSInteger             showIndex1;
    NSInteger             showIndex2;
    NSInteger             showIndex3;
    
    NSTimer         *myTimer;
    
}
@property (nonatomic , assign) BOOL loop;
@property (nonatomic , weak) id <LoopScrollViewDelegate> delegate;
@property (nonatomic,assign)AdBannerStyle bannerStyle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong)UIScrollView *currentScrollView;
@property (nonatomic,strong) HLLPageControl *pc;
#pragma mark - set LoopScrollView

- (id)initWithFrame:(CGRect)frame withBannerStyle:(AdBannerStyle )bannerStyle;

- (void) setImageArray : (NSArray*) _imageArray;
#pragma mark - timer
- (void) timerStart : (float) duration;
- (void) timerEnd;

#pragma mark - scrollView setting
- (void) setContentOffset : (CGPoint) point;
- (void) setContentOffset : (CGPoint) point animated : (BOOL) animated;
- (void) setBackgroundColor : (UIColor*) color;
- (void) setHidden : (BOOL) hidden;
- (void) setScrollEnabled : (BOOL) enabled;
- (void) setScrollsToTop : (BOOL) top;
- (void) setUserInteractionEnabled : (BOOL) enabled;

#pragma mark - pageControl setting
- (void) setPageControlHidden : (BOOL) hidden;
- (void) setPageControlOffset : (CGPoint) offset;
- (void) setPageControlCurrentPage : (NSInteger) index;
- (void) setPageControlNumberOfPages : (NSInteger) pages;
- (void) setPageControlCurrentImage : (UIImage*) currentImage;
- (void) setPageControlDefaultImage : (UIImage*) defaultImage;
- (void) setPageControlCurrentColor : (UIColor*) currentColor;
- (void) setPageControlDefaultColor : (UIColor*) defaultColor;

@end
