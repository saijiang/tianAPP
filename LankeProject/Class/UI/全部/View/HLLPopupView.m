//
//  HLLPopupView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"

@implementation PopupContentView

- (void)dealloc
{
    self.popupParent = nil;
}

- (void)closePopup
{
    if (_outAnimation) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _outAnimation(self);
            
        } completion:^(BOOL finished) {
            [self.popupParent hide:YES];
        }];
    }
    else
    {
        if (self.popupParent)
        {
            [self.popupParent hide:YES];
        }
    }
}


// YES：点击空的区域可以hide
- (BOOL)isAlert
{
    return NO;
}

// YES：点击空的区域可以hide
-(BOOL)isJdAlert
{
    return YES;
}

// 点击空白区域
- (void)onTouchBlank
{
    [self closePopup];
}

- (void)setPopupParent:(HLLPopupView *)popupParent
{
    _popupParent = popupParent;
    
    CGRect showRect = [self showRect];
    
    self.frame = showRect;
}

- (void)setShowSize:(CGSize)showSize
{
    _showSize = showSize;
    if (_popupParent)
    {
        [_popupParent relayoutFrameOfSubViews];
        [self setNeedsLayout];
    }
}

- (void)setShowRect:(CGRect)showRect
{
    _showRect = showRect;
    
    if (_popupParent)
    {
        [_popupParent relayoutFrameOfSubViews];
        [self setNeedsLayout];
    }
}

@end


@interface HLLPopupView ()
{
    CGAffineTransform _rotationTransform;
    CGFloat _offset;
}

@end

@implementation HLLPopupView


#pragma mark -
#pragma mark Alert M

+ (HLLPopupView *)alertInWindow:(PopupContentView *)contentView
{
    
    return [HLLPopupView alert:contentView inView:KAPPDELEGATE.window];
}

+ (HLLPopupView *)alertInWindow:(PopupContentView *)contentView withAnimation:(void (^)(void))animation
{
    return [HLLPopupView alert:contentView inView:KAPPDELEGATE.window];
}


+ (HLLPopupView *)alert:(PopupContentView *)contentView inView:(UIView *)view
{
    HLLPopupView *pop = [[HLLPopupView alloc] initWithFrame:view.bounds];
    [pop setContentView:contentView];
    contentView.popupParent = pop;
    [view addSubview:pop];
    BOOL isAlert = [contentView isAlert];
    if (isAlert)
    {
        [pop addGestures];
    }
    [pop relayoutFrameOfSubViews];
    [pop show:YES];
    return pop;
}

+ (HLLPopupView *)alert:(PopupContentView *)contentView inView:(UIView *)view withAnimation:(void (^)(void))animation
{
    HLLPopupView *pop = [[HLLPopupView alloc] initWithFrame:view.bounds];
    [pop setContentView:contentView];
    contentView.popupParent = pop;
    [view addSubview:pop];
    BOOL isAlert = [contentView isAlert];
    if (isAlert)
    {
        [pop addGestures];
    }
    [pop relayoutFrameOfSubViews];
    [pop showWith:animation];
    return pop;
}


#pragma mark -
#pragma mark Tip M

+ (HLLPopupView *)tipInWindow:(PopupContentView *)contentView heightOffset:(CGFloat)offset{

    UIView * view = KAPPDELEGATE.window;

    CGRect rect = (CGRect){view.bounds.origin,{view.bounds.size.width,view.bounds.size.height - offset}};
    HLLPopupView *pop = [[HLLPopupView alloc] initWithFrame:rect];
    pop.dimBackground = NO;
    pop.offset = offset;
    [pop setContentView:contentView];
    contentView.popupParent = pop;
    [view addSubview:pop];
    
    BOOL isAlert = [contentView isAlert];
    if (isAlert)
    {
        [pop addGestures];
    }
    [pop relayoutFrameOfSubViews];
    [pop show:YES];
    
    return pop;
}

+ (HLLPopupView *)tipInWindow:(PopupContentView *)contentView
{
    return [HLLPopupView tip:contentView inView:KAPPDELEGATE.window];
}

+ (HLLPopupView *)tipInWindow:(PopupContentView *)contentView withAnimation:(void (^)(void))animation
{
    return [HLLPopupView tip:contentView inView:KAPPDELEGATE.window withAnimation:animation];
}

+ (HLLPopupView *)tip:(PopupContentView *)contentView inView:(UIView *)view
{
    HLLPopupView *pop = [[HLLPopupView alloc] initWithFrame:view.bounds];
    pop.dimBackground = NO;
    [pop setContentView:contentView];
    contentView.popupParent = pop;
    [view addSubview:pop];
    
    BOOL isAlert = [contentView isAlert];
    BOOL isJdAlert = [contentView isJdAlert];
    if (isAlert)
    {
        [pop addGestures];
    }
    else if(isJdAlert)
    {
        [pop addGestures];
    }
    [pop relayoutFrameOfSubViews];
    [pop show:YES];
    
    return pop;
}

+ (HLLPopupView *)tip:(PopupContentView *)contentView inView:(UIView *)view withAnimation:(void (^)(void))animation
{
    HLLPopupView *pop = [[HLLPopupView alloc] initWithFrame:view.bounds];
    [pop setContentView:contentView];
    contentView.popupParent = pop;
    [view addSubview:pop];
    BOOL isAlert = [contentView isAlert];
    if (isAlert)
    {
        [pop addGestures];
    }
    [pop relayoutFrameOfSubViews];
    [pop showWith:animation];
    return pop;
}

- (void)setContentView:(UIView<PopupContentViewDelegate> *)contentView
{
    if (_contentView)
    {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    [self addSubview:contentView];
}

- (void)dealloc
{
    [self unregisterFromNotifications];
    [self unregisterFromKVO];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Set default values for properties
        self.animationType = EPopupViewAnimationFade;
        self.dimBackground = NO;
        _animationDuration = .75;
        
        // Transparent background
        self.backgroundColor = [UIColor colorWithWhite:0. alpha:0.7];
        self.alpha = 0;
        _rotationTransform = CGAffineTransformIdentity;
        
        [self setTransformForCurrentOrientation:NO];
        
        [self registerForKVO];
        [self registerForNotifications];
    }
    return self;
}

- (void)addGestures
{
    UITapGestureRecognizer *tapget = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlank:)];
    tapget.delegate = self;
    tapget.numberOfTapsRequired = 1;
    tapget.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapget];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return touch.view == self;
}
- (void)onTapBlank:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self.contentView onTouchBlank];
    }
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated
{
    [[UIApplication sharedApplication].keyWindow resignFirstResponder];
    [self showUsingAnimation:animated];
    [self setNeedsDisplay];
}

- (void)hide:(BOOL)animated
{
    [self hideUsingAnimation:animated];
}

#pragma mark - View Hierrarchy

- (void)didMoveToSuperview
{
    // We need to take care of rotation ourselfs if we're adding the HUD to a window
    [self setTransformForCurrentOrientation:NO];
}

#pragma mark - Internal show & hide operations

- (void) showAnimationHandle{

    if (self.animationType == EPopupViewAnimationZoomIn)
    {
        self.contentView.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
    }
    else if (_animationType == EPopupViewAnimationZoomOut)
    {
        self.contentView.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
    }
    else if (_animationType == EPopupViewAnimationDownFromTop)
    {
        CGFloat height = self.frame.size.height;
        self.contentView.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(0, -height));
    }
    else if (_animationType == EPopupViewAnimationUpFromBottom)
    {
        CGFloat height = self.contentView.frame.size.height;
        self.contentView.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(0, height));
    }
    else if (_animationType == EPopupViewAnimationSlipFromLeft)
    {
        CGFloat width = self.contentView.frame.size.width;
        self.contentView.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(-width, 0));
    }
    else if (_animationType == EPopupViewAnimationSlipFromRight)
    {
        CGFloat width = self.contentView.frame.size.width;
        self.contentView.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(width, 0));
    }
}

- (void) hideAnimationHandle{
    
    if (_animationType == EPopupViewAnimationZoomIn)
    {
        self.contentView.transform = _rotationTransform;//CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
    }
    else if (_animationType == EPopupViewAnimationZoomOut)
    {
        self.contentView.transform = _rotationTransform;//CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
    }
    else if (_animationType == EPopupViewAnimationDownFromTop)
    {
        //CGFloat height = 100;
        self.contentView.transform = _rotationTransform;//CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(0, height));
    }
    else if (_animationType == EPopupViewAnimationUpFromBottom)
    {
        self.transform = _rotationTransform;//CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(0, height));
    }
    else if (_animationType == EPopupViewAnimationSlipFromLeft)
    {
        //CGFloat height = 100;
        self.contentView.transform = _rotationTransform;//CGAffineTransformMakeTranslation(0, height);//CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(0, height));
    }
    else if (_animationType == EPopupViewAnimationSlipFromRight)
    {
        //CGFloat height = -100;
        self.contentView.transform = _rotationTransform;//CGAffineTransformMakeTranslation(0, height);//CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeTranslation(0, height));
    }
}

- (void)showWith:(void (^)(void))animations
{
    [self showAnimationHandle];
    
    if (animations)
    {
        [UIView animateWithDuration:self.animationDuration animations:^{
            self.alpha = 1.0f;
            if (_animationType == EPopupViewAnimationZoomIn || _animationType == EPopupViewAnimationZoomOut)
            {
                self.contentView.transform = _rotationTransform;
            }
            animations();
        } completion:nil];
    }
    else
    {
        self.alpha = 1.0f;
        if (_animationType == EPopupViewAnimationZoomIn || _animationType == EPopupViewAnimationZoomOut)
        {
            self.contentView.transform = _rotationTransform;
        }
    }
}

- (void)setTransform:(CGAffineTransform)transform
{
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        [super setTransform:transform];
    }
}

- (void)showUsingAnimation:(BOOL)animated
{
    if (animated) {
        [self showAnimationHandle];
    }
    
    // Fade in
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:self.animationDuration];
        self.alpha = 1.0f;
        
        self.contentView.transform = _rotationTransform;
        [UIView commitAnimations];
    }
    else
    {
        self.alpha = 1.0f;
        if (_animationType == EPopupViewAnimationZoomIn || _animationType == EPopupViewAnimationZoomOut)
        {
        }
        self.contentView.transform = _rotationTransform;
    }
    [self setNeedsDisplay];
    
}

- (void)hideUsingAnimation:(BOOL)animated
{
    // Fade out
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideRemove)];
        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
        // in the done method
        
        [self hideAnimationHandle];
        
        self.alpha = 0.02f;
        [UIView commitAnimations];
    }
    else
    {
        self.alpha = 0.0f;
        [self removeFromSuperview];
    }
}

- (void)hideRemove
{
    [self removeFromSuperview];
}

#pragma mark - Layout

- (void)relayoutFrameOfSubViews
{
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // Entirely cover the parent view
    UIView *parent = self.superview;
    if (parent)
    {
        self.frame = parent.bounds;
        if (self.offset > 0) {
            self.frame = CGRectMake(0, 0,  parent.width, parent.height - _offset);
        }
    }
    
    CGRect rect = [self.contentView showRect];
    self.contentView.frame = rect;
    //self.contentView.transform = _rotationTransform;
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    if (self.dimBackground)
    {
        //Gradient colours
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        
        CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        
        CGColorSpaceRelease(colorSpace);
        //Gradient center
        CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        //Gradient radius
        float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
        //Gradient draw
        CGContextDrawRadialGradient (context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
    UIGraphicsPopContext();
}

#pragma mark - KVO

- (void)registerForKVO
{
    for (NSString *keyPath in [self observableKeypaths])
    {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO
{
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths
{
    return @[@"contentView"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    }
    else
    {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath
{
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)registerForNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(deviceOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIView *superview = self.superview;
    if (!superview)
    {
        return;
    }
    else if([superview isKindOfClass:[UIWindow class]])
    {
        [self setTransformForCurrentOrientation:YES];
    }
    else
    {
        self.frame = self.superview.bounds;
        [self setNeedsDisplay];
    }
}

- (void)setTransformForCurrentOrientation:(BOOL)animated
{
    // Stay in sync with the superview
    if (self.superview)
    {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationFaceUp ||
        orientation == UIDeviceOrientationFaceDown)
    {
        orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    }
    CGFloat radians = 0;
    if (UIDeviceOrientationIsLandscape(orientation))
    {
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            radians = -(CGFloat)M_PI_2;
        }
        else
        {
            radians = (CGFloat)M_PI_2;
        }
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    }
    else
    {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            radians = (CGFloat)M_PI;
        }
        else
        {
            radians = 0;
        }
        self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    _rotationTransform = CGAffineTransformMakeRotation(radians);
    
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
    }
    
    [self setTransform:_rotationTransform];
    self.contentView.transform = _rotationTransform;
    [self setNeedsDisplay];
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}

@end
