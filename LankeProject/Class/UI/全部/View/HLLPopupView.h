//
//  HLLPopupView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLLPopupView;
@class PopupContentView;

typedef void (^PopupContentViewAnimationBlock)(PopupContentView *popup);

typedef enum
{
    /** Opacity animation */
    EPopupViewAnimationFade,
    
    /** Opacity + scale animation */
    EPopupViewAnimationZoom,
    EPopupViewAnimationZoomOut = EPopupViewAnimationZoom,
    EPopupViewAnimationZoomIn,
    
    /** Opacity + position animation */
    EPopupViewAnimationDownFromTop,
    EPopupViewAnimationUpFromBottom,
    EPopupViewAnimationSlipFromLeft,
    EPopupViewAnimationSlipFromRight
}PopupViewAnimation;


@protocol PopupContentViewDelegate <NSObject>

@required

- (void)setPopupParent:(HLLPopupView *)popup;

- (CGRect)showRect;

- (void)closePopup;

// YES：点击空白的区域返回
- (BOOL)isAlert;

// 点击空白区域
- (void)onTouchBlank;

@optional

- (void)adjustShowRectOnRorate;

@end

@interface PopupContentView : UIView<PopupContentViewDelegate>
{
@protected
    __unsafe_unretained HLLPopupView *_popupParent;
    CGRect _showRect;
    CGSize _showSize;
    BOOL _isAlert;
}

@property (nonatomic, assign) HLLPopupView *popupParent;
@property (nonatomic, assign) CGRect showRect;
@property (nonatomic, assign) CGSize showSize;
@property (nonatomic, assign) BOOL isAlert;
@property (nonatomic,assign)BOOL isJdAlert;//京东售后

@property (nonatomic, copy) PopupContentViewAnimationBlock outAnimation;
@end

/** 
 显示的动画ok，但是隐藏的动画还不是很好，目前仅仅使用fade进行隐藏
 */
@interface HLLPopupView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic ,assign) CGFloat offset;

@property (assign) BOOL dimBackground;

@property (assign) PopupViewAnimation animationType;

@property (nonatomic, readonly) UIView<PopupContentViewDelegate> *contentView;

@property (nonatomic, assign) CGFloat animationDuration;

+ (HLLPopupView *)tipInWindow:(PopupContentView *)contentView heightOffset:(CGFloat)offset;

+ (HLLPopupView *)alertInWindow:(PopupContentView *)contentView;

+ (HLLPopupView *)alertInWindow:(PopupContentView *)contentView withAnimation:(void (^)(void))animation;

+ (HLLPopupView *)alert:(PopupContentView *)contentView inView:(UIView *)view;

+ (HLLPopupView *)alert:(PopupContentView *)contentView inView:(UIView *)view withAnimation:(void (^)(void))animation;


+ (HLLPopupView *)tipInWindow:(PopupContentView *)contentView;

+ (HLLPopupView *)tipInWindow:(PopupContentView *)contentView withAnimation:(void (^)(void))animation;

+ (HLLPopupView *)tip:(PopupContentView *)contentView inView:(UIView *)view;

+ (HLLPopupView *)tip:(PopupContentView *)contentView inView:(UIView *)view withAnimation:(void (^)(void))animation;


- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

- (void)relayoutFrameOfSubViews;



@end
