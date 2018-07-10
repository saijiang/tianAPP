//
//  LKHomeBannerView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKHomeBannerView.h"

@interface LKHomeBannerView ()

@property (readwrite) HLLPageControl *myPageControl;
@property (readwrite) LKPageScrollView *myPageView;

@property (strong, nonatomic) NSMutableArray * contentViewList;
@end

@implementation LKHomeBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat pageControlHeight = 20.0f;
        
        if (!_myPageControl) {
            _myPageControl = ({
                CGRect pageControlFrame = CGRectMake(0,
                                                     CGRectGetHeight(frame) - pageControlHeight,
                                                     CGRectGetWidth(frame),
                                                     pageControlHeight);
                HLLPageControl *pageControl = [[HLLPageControl alloc] initWithFrame:pageControlFrame];
                pageControl.userInteractionEnabled = NO;
                pageControl.backgroundColor = [UIColor clearColor];
                pageControl.numberOfPages = _curBannerList.count;
                pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#7E7787"];
                pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ffffff"];
                pageControl;
            });
            [self addSubview:_myPageControl];
            [_myPageControl mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-50);
                make.height.mas_equalTo(pageControlHeight);
            }];
        }
        
        if (!_myPageView) {
            
            __weak typeof(self) weakSelf = self;
            
            CGRect pageViewFrame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(frame),
                                              CGRectGetHeight(frame));
            
            _myPageView = [[LKPageScrollView alloc] initPageViewWithFrame:pageViewFrame];
            _myPageView.duration = 2;
            _myPageView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                if (weakSelf.curBannerList.count > pageIndex) {
                    
                    NetworkImageView * contnetView = (NetworkImageView *)[weakSelf p_reuseViewForIndex:pageIndex];
                    return contnetView;
                }else{
                    return [UIView new];
                }
            };
            //
            _myPageView.currentPageIndexChangeBlock = ^(NSInteger currentPageIndex){
                
                [weakSelf.myPageControl setupPageControlCurrentPage:currentPageIndex];
            };
            
            [self addSubview:_myPageView];
            [_myPageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.mas_equalTo(self);
            }];
        }
        [self bringSubviewToFront:_myPageControl];
    }
    return self;
}
- (void) configureBannerViewWithBannerList:(NSArray *)bannerList{
    
    _curBannerList = bannerList;
    self.hidden = _curBannerList.count <= 0;
    if (_curBannerList.count <= 0) {
        return;
    }
    [self reloadBannerViewWithData:bannerList];
    NSLog(@"%@", _curBannerList);
}

-(UIView *)p_reuseViewForIndex:(NSInteger)pageIndex{
    
    if (!_contentViewList) {
        
        _contentViewList = [[NSMutableArray alloc] initWithCapacity:_curBannerList.count];
        for (NSInteger i = 0; i < _curBannerList.count; i++) {
            
            NetworkImageView * contnetView = [[NetworkImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.myPageView.frame), CGRectGetHeight(self.myPageView.frame))];
            contnetView.backgroundColor = [UIColor clearColor];
            contnetView.clipsToBounds = YES;
            contnetView.contentMode = UIViewContentModeScaleAspectFill;
            [_contentViewList addObject:contnetView];
        }
    }
    
    NSString * imageName = _curBannerList[pageIndex];
    
    NetworkImageView * contnetView = _contentViewList[pageIndex];
    [contnetView confiNetworkImageWith:imageName];
    
    
    return contnetView;
}

- (void)reloadBannerViewWithData:(NSArray *)bannerList{
    
    self.hidden = _curBannerList.count <= 0;
    if (_curBannerList.count <= 0) {
        return;
    }
    
    NSInteger currentPageIndex = MIN(self.myPageView.currentPageIndex, _curBannerList.count - 1) ;
    _myPageControl.numberOfPages = _curBannerList.count;
    [_myPageControl setupPageControlCurrentPage:currentPageIndex];
    
    //
    [_myPageView reloadPageViewWithData:bannerList];
}

@end
