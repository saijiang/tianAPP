//
//  CommonHeaderView.m
//  LankeProject
//
//  Created by itman on 16/10/11.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "CommonHeaderView.h"

@interface CommonHeaderView ()<LoopScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray * bannerImages;

@end

@implementation CommonHeaderView

-(void)dealloc
{
    [self.bannerView timerEnd];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.bannerImages = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bannerImages = [NSMutableArray array];
        CGRect bannerFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.bannerView=[[LoopScrollView alloc]initWithFrame:bannerFrame
                                             withBannerStyle:AdBannerStyleDefault];
        self.bannerView.delegate = self;
        
        self.bannerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.bannerView];
    }
    return self;
}

#pragma mark - LoopScrollViewDelegate
// 广告页点击选中
- (void) loopScrollView : (LoopScrollView*) loopScrollView didSelectIndex : (NSInteger) index didSelectImage : (UIImage*) image
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(commonHeaderView:didSelectedBannerImageAtIndex:)])
    {
        [self.delegate commonHeaderView:self didSelectedBannerImageAtIndex:index];
    }
}

// 设置广告页标题
- (void) loopScrollViewTitle : (LoopScrollView*) loopScrollView didSelectIndex : (NSInteger) index
{
 
}

#pragma mark - API

- (void)confiBannerViewWithImageData:(NSArray *)imageData fotKeyPath:(NSString *)keyPath{

    NSMutableArray * temp = [NSMutableArray array];
    
    for (NSDictionary * data in imageData) {
        [temp addObject:data[keyPath]];
    }
    
    [self configureBannerViewWithImageData:temp];
}
/**
 *  配置banner视图的图片以及需要跳转的视图
 */
- (void) configureBannerViewWithImageData:(NSArray*)imageDatas
{
    [self.bannerImages removeAllObjects];
    
    if (imageDatas.count > 0)
    {
        [self.bannerImages addObjectsFromArray:imageDatas];
    }
    else
    {
        //测试用
        [self.bannerImages addObject:[UIImage imageNamed:@"default_restaurant"]];
        [self.bannerImages addObject:[UIImage imageNamed:@"default_restaurant"]];
        [self.bannerImages addObject:[UIImage imageNamed:@"default_restaurant"]];
        [self.bannerImages addObject:[UIImage imageNamed:@"default_restaurant"]];
    }
    
    if (self.bannerImages.count > 1)
    {
        [self.bannerView timerStart:5];
    }
    [self.bannerView setImageArray:self.bannerImages];
    [self.bannerView setPageControlNumberOfPages:self.bannerImages.count];
    
}
///移除定时器
-(void)timerEnd
{
    [self.bannerView timerEnd];
}

@end
