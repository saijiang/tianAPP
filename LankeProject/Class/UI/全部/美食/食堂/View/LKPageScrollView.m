//
//  LKPageScrollView.m
//  YOUMENG
//
//  Created by Rocky Young on 16/11/24.
//  Copyright © 2016年 KZQ. All rights reserved.
//

#import "LKPageScrollView.h"

@interface LKPageScrollView () <UIScrollViewDelegate>

@property (nonatomic ,assign ,readwrite) NSInteger currentPageIndex;
@property (nonatomic ,assign) NSInteger sourcePageIndex;
@property (nonatomic ,assign) NSInteger targetPageIndex;

@property (nonatomic ,assign) CGPoint startScrollPoint;

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<UIView *>* contentArray;

@property (nonatomic ,assign) BOOL isEndDragging;
@property (nonatomic ,assign) BOOL canChangeRect;

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation LKPageScrollView


-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

-(instancetype)initPageViewWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)reloadPageViewWithData:(NSArray *)bannerList{

    NSMutableArray * contentViews = [NSMutableArray arrayWithCapacity:bannerList.count];
    
    for (NSInteger index = 0; index < bannerList.count; index ++) {
        if (self.fetchContentViewAtIndex) {
            UIView * contentView = self.fetchContentViewAtIndex(index);
            [contentViews addObject:contentView];
        }else{
            UIView * contentView = [UIView new];
            [contentViews addObject:contentView];
        }
    }
    self.contentArray = contentViews;
}

#pragma mark -
#pragma mark Setup M

-(void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;

    [self.timer invalidate];
    
    [self startTimer];
}

-(void)setContentArray:(NSArray<UIView *> *)contentArray
{
    if (!contentArray && contentArray.count==0) {
        return;
    }
    _contentArray = contentArray;
    _numberOfPage = contentArray.count;
    
    [self setUpScrollView:contentArray];
    [self setUpContentView:contentArray];
    
    [self.timer invalidate];
    [self startTimer];
}


/**
 *  设置scrollView
 */
-(void)setUpScrollView:(NSArray *)array
{
    if (self.scrollView) {
        [self.scrollView removeAllSubviews];
        [self.scrollView setContentOffset:CGPointZero];
        return;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewClick:)];
    [scrollView addGestureRecognizer:tabGesture];
    
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    recognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    [scrollView addGestureRecognizer:recognizer];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)pageViewClick:(UITapGestureRecognizer *)tap
{
    if (self.didSelectPageViewAtIndex){
        self.didSelectPageViewAtIndex(self.currentPageIndex);
    }
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)tap
{
    [self.timer invalidate];

    if(tap.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x  + CGRectGetWidth(self.scrollView.frame), 0);
        [self.scrollView setContentOffset:newOffset animated:YES];
        [self startTimer];
    }
}

-(void)setUpContentView:(NSArray <UIView *>*)array
{
    CGSize contentSize = CGSizeZero;;
    CGPoint startPoint = CGPointZero;
    CGFloat rateContentHeight = 0.0f;

    if (array.count > 1) {     //多张图片
        for (int i = 0 ; i < array.count + 2; i++) {
            UIView* curPageView;
            
            if (i == 0) {
                //第一个imageview放最后一张
                curPageView = [[array lastObject] copy];
            }else if(i == array.count + 1){
                //最后一个imageview放第一张
                curPageView = [[array firstObject] copy];
                
                rateContentHeight = curPageView.height;
            }else{
                //4，1，2，3，4，1类似
                curPageView = array[i - 1];
            }
            
            curPageView.frame = CGRectMake(i * self.frame.size.width, 0, curPageView.width, curPageView.height);
            curPageView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:curPageView];

            contentSize = CGSizeMake((array.count + 2) * self.frame.size.width,0);
            startPoint = CGPointMake(self.frame.size.width, 0);
            
        }
    }else{ //1张图片
        UIView* curPageView = [array firstObject];
        curPageView.frame = CGRectMake(0, 0, curPageView.width, curPageView.height);
        curPageView.backgroundColor = [UIColor whiteColor];

        [self addSubview:curPageView];
        [self bringSubviewToFront:curPageView];

        contentSize = CGSizeMake(self.frame.size.width, curPageView.height);
        startPoint = CGPointZero;

        rateContentHeight = curPageView.height;
    }
    //开始的偏移量跟内容尺寸
    self.scrollView.contentOffset = startPoint;
    self.scrollView.contentSize = contentSize;
    
    if (self.contentPageRateChangeBlock) {
        self.contentPageRateChangeBlock(rateContentHeight);
    }
}

#pragma mark -
#pragma mark Scroller M

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray* content=nil;
    if (_contentArray) {
        content = _contentArray;
    }
    
    if (!content) {
        return;
    }
    
    if (scrollView.contentOffset.x < self.frame.size.width) {// 去第n-1个视图
        
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * (content.count + 1), 0) animated:NO];
        self.startScrollPoint = self.scrollView.contentOffset;
    }
    //偏移超过
    if (scrollView.contentOffset.x > self.frame.size.width * (content.count + 1)) {// 去第0个视图
        
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        self.startScrollPoint = self.scrollView.contentOffset;
    }
    
    self.currentPageIndex = [self getCurrentPageIndexWhenScrollViewDidScroll:scrollView];
    
    UIView * sourceContentView = self.contentArray[self.currentPageIndex];
    CGFloat sourceHeight = CGRectGetHeight(sourceContentView.bounds);
    
    UIView * targetContentView = nil;
    CGFloat targetHeight = sourceHeight;
    CGRect targetContentViewFrame = CGRectZero;
    
    CGFloat rateOffset = 0.0f;
    CGFloat rateContentHeight = sourceHeight;
    
    CGPoint contentOffset = scrollView.contentOffset;
    if (contentOffset.x >= self.startScrollPoint.x) {// 向左滑动
        rateOffset = (contentOffset.x - self.startScrollPoint.x) / CGRectGetWidth([UIScreen mainScreen].bounds);
        // 获取下一个视图
        NSInteger nextPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        targetContentView = self.contentArray[nextPageIndex];
        targetContentViewFrame = targetContentView.frame;
        targetHeight = CGRectGetHeight(targetContentView.bounds);
        
    }else{// 向右滑动
        
        rateOffset = (self.startScrollPoint.x - contentOffset.x) / CGRectGetWidth([UIScreen mainScreen].bounds);
        // 获取前一个视图
        // bug here 🐛
        for (NSInteger index = 0 ;index < self.contentArray.count - 1; index ++) {
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        }
        sourceContentView = self.contentArray[self.currentPageIndex];
        sourceHeight = CGRectGetHeight(sourceContentView.bounds);
        
        NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        targetContentView = self.contentArray[previousPageIndex];
        targetContentViewFrame = targetContentView.frame;
        targetHeight = CGRectGetHeight(targetContentView.bounds);

    }
    
    rateContentHeight = sourceHeight - (sourceHeight - targetHeight) * rateOffset;

    if (self.contentPageRateChangeBlock) {
        
        self.contentPageRateChangeBlock(rateContentHeight);
    }
    
    if ((self.contentPageChangeBlock && self.isEndDragging && self.canChangeRect) ) {
        
        targetContentView = self.contentArray[self.targetPageIndex];
//
        CGRect frame = targetContentView.frame;
        frame.size = CGSizeMake(targetContentView.width, targetContentView.height);
        targetContentView.frame = frame;
//
        self.contentPageChangeBlock(sourceContentView.height,
                                    targetContentView.height);
        
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height = targetContentView.height;
        self.scrollView.contentSize = contentSize;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    self.startScrollPoint = scrollView.contentOffset;
}

//开始拖动时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isEndDragging = NO;
    
    self.startScrollPoint = scrollView.contentOffset;
    
    [self.timer invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

    self.targetPageIndex = [self getTargetPageIndexWithTargetContentOffsetX:targetContentOffset->x];
    self.canChangeRect = self.currentPageIndex != self.targetPageIndex;
    
    if (self.currentPageIndexChangeBlock) {
        self.currentPageIndexChangeBlock(self.targetPageIndex);
    }
}
//结束拖动时
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isEndDragging = YES;
    
    [self startTimer];
}

#pragma mark - Timer M

-(void)startTimer{
    
    if (!_duration) {
        return;
    }else{
        self.timer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)updateTimer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x  + CGRectGetWidth(self.scrollView.frame), 0);
    [self.scrollView setContentOffset:newOffset animated:YES];
    
    self.targetPageIndex = [self getTargetPageIndexWithTargetContentOffsetX:newOffset.x];
    
    if (self.currentPageIndexChangeBlock) {
        self.currentPageIndexChangeBlock(self.targetPageIndex);
    }
}


#pragma mark -
#pragma mark Privete M

- (NSInteger)getCurrentPageIndexWhenScrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger currentPageIndex = scrollView.contentOffset.x / self.frame.size.width;
    
    if (currentPageIndex > _contentArray.count) {
        currentPageIndex = 0;
    }else if (currentPageIndex == 0){
        currentPageIndex = _contentArray.count - 1;
    }else{
        currentPageIndex--;
    }
    return [self getValidNextPageIndexWithPageIndex:currentPageIndex];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)pageIndex;
{
    if(pageIndex == -1) {
        return self.numberOfPage - 1;
    } else if (pageIndex == self.numberOfPage) {
        return 0;
    } else {
        return pageIndex;
    }
}

- (NSInteger)getSourcePageIndexWithSourceContentOffsetX:(CGFloat)sourceContentOffsetX{

    return [self getTargetPageIndexWithTargetContentOffsetX:sourceContentOffsetX];
}


- (NSInteger)getTargetPageIndexWithTargetContentOffsetX:(CGFloat)targetContentOffsetX{
    
    NSInteger targetPageIndex = targetContentOffsetX / CGRectGetWidth([UIScreen mainScreen].bounds);
    
    if (targetPageIndex > self.numberOfPage) {
        targetPageIndex = 0;
    }else{
        targetPageIndex -= 1;
    }
    return targetPageIndex;
}
@end
