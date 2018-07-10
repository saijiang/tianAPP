//
//  HLLPageControl.m
//  HLLPageControl
//
//  Created by Rocky Young on 16/11/14.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLPageControl.h"

static CGFloat const kPageControlDotViewSize = 4.0f;
static CGFloat const kPageControlRoundedRectangleViewWidth = 20.0f;
static CGFloat const kPageControlDotViewMargin = 5.0f;

@interface CAShapeLayer (DotLayer)

- (void) fillWithColor:(UIColor *)color;

@end

@interface HLLPageControl (){
    
    NSMutableArray * _paths;
    NSMutableArray * _shapLayers;
}

@property(nonatomic ,readwrite) NSInteger currentPage;


@end
@implementation HLLPageControl

#pragma mark -
#pragma mark Cyc

- (void)awakeFromNib{

    [super awakeFromNib];

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self defaultSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self defaultSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self defaultSetup];
    }
    return self;
}

- (void) defaultSetup{
    
    self.numberOfPages =
    self.currentPage = 0;
    
    self.hidePageControlWhenSinglePage = YES;
    
    self.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    _shapLayers = [NSMutableArray array];
    _paths = [NSMutableArray array];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self setupPageControl];
}

#pragma mark -
#pragma mark Setter

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    
    _numberOfPages = numberOfPages;
    
//    NSAssert(numberOfPages < 30, @"Your numberOfPages is bigger then ten ,It's not cool.");
    
    [[self layer] setSublayers:nil];
    
    [_shapLayers removeAllObjects];
    [_paths removeAllObjects];
    
    [self setNeedsLayout];
}

- (void) updatePageControlWithNumberOfPages:(NSInteger)numberOfPages{
    
    [[self layer] setSublayers:nil];
    
    [_shapLayers removeAllObjects];
    [_paths removeAllObjects];
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Method

- (CGRect) calculationDotViewRectWithNumberOfPages:(NSInteger)numberOfPages{
    
    CGSize size = [self sizeForNumberOfPages:numberOfPages];
    
    CGPoint point = CGPointMake(CGRectGetWidth(self.bounds) / 2 - size.width / 2,
                                CGRectGetHeight(self.bounds) - kPageControlDotViewSize - 10);
    
    return (CGRect){point,size};
}

- (void)setupPageControl{
    
    if (self.numberOfPages == 0) {
        return;
    }else if (self.numberOfPages == 1) {
        if (self.hidePageControlWhenSinglePage) {
            return;
        }
    }
    CGRect rect = [self calculationDotViewRectWithNumberOfPages:self.numberOfPages];
    
    CAShapeLayer * roundedRectangleLayer = [CAShapeLayer layer];
    roundedRectangleLayer.frame = rect;
    [roundedRectangleLayer fillWithColor:self.currentPageIndicatorTintColor];
    roundedRectangleLayer.cornerRadius = kPageControlDotViewSize * 0.5f;
    CGRect layerRect = CGRectMake(0, 0, self.numberOfPages == 1 ? kPageControlDotViewSize :  kPageControlRoundedRectangleViewWidth, kPageControlDotViewSize);
    UIBezierPath * roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:layerRect cornerRadius:kPageControlDotViewSize/2];
    roundedRectangleLayer.path = roundedRectanglePath.CGPath;
    
    [_shapLayers addObject:roundedRectangleLayer];
    [_paths addObject:roundedRectanglePath];
    
    [self.layer addSublayer:roundedRectangleLayer];
    
    for (NSInteger index = 1; index < self.numberOfPages; index ++) {
        
        CAShapeLayer * dotLayer = [CAShapeLayer layer];
        dotLayer.frame = rect;
        dotLayer.cornerRadius = kPageControlDotViewSize * 0.5f;
        [dotLayer fillWithColor:self.pageIndicatorTintColor];
        CGFloat x = kPageControlRoundedRectangleViewWidth + kPageControlDotViewMargin * index + (index - 1) * kPageControlDotViewSize;
        CGRect dotRect = CGRectMake(x, 0, kPageControlDotViewSize, kPageControlDotViewSize);
        UIBezierPath * dotPath = [UIBezierPath bezierPathWithRoundedRect:dotRect cornerRadius:kPageControlDotViewSize/2];
        dotLayer.path = dotPath.CGPath;
        [_shapLayers addObject:dotLayer];
        [_paths addObject:dotPath];
        
        [self.layer addSublayer:dotLayer];
    }
}

#pragma mark -
#pragma mark API

- (void)setupPageControlCurrentPage:(NSInteger)currentPage animation:(BOOL)animation{
    
    //NSAssert(currentPage >= 0, @"CurrentPage must be an number of bigger then zero.");
    
    if (currentPage >= 0) {
        self.currentPage = currentPage;
    }
    
    if (self.numberOfPages == 1) {
        return;
    }
    
    [_shapLayers enumerateObjectsUsingBlock:^(CAShapeLayer * shapLayer, NSUInteger index, BOOL * _Nonnull stop) {
        
        UIBezierPath * path = _paths[index];
        
        CGFloat x = kPageControlRoundedRectangleViewWidth + kPageControlDotViewMargin * index + (index - 1) * kPageControlDotViewSize;
        CGFloat width = kPageControlDotViewSize;
        
        if (index < currentPage) {// 左边的dot
            
            [shapLayer fillWithColor: self.pageIndicatorTintColor];
            x = index * (kPageControlDotViewMargin + kPageControlDotViewSize);
        }else if (currentPage == index) {// 圆角矩形
            
            [shapLayer fillWithColor: self.currentPageIndicatorTintColor];
            x = currentPage * (kPageControlDotViewMargin + kPageControlDotViewSize);
            width = kPageControlRoundedRectangleViewWidth;
        }else if(index > currentPage){// 右边的dot
            
            [shapLayer fillWithColor: self.pageIndicatorTintColor];
            CGFloat leftWidth = currentPage * (kPageControlDotViewSize + kPageControlDotViewMargin);
            x = leftWidth + kPageControlRoundedRectangleViewWidth + (index - currentPage) * (kPageControlDotViewSize + kPageControlDotViewMargin) - kPageControlDotViewSize;
        }
        CGRect dotRect = CGRectMake(x, 0, width, kPageControlDotViewSize);
        path = [UIBezierPath bezierPathWithRoundedRect:dotRect cornerRadius:kPageControlDotViewSize/2];
        
        shapLayer.path = path.CGPath;
        if (animation) {
            
            // to do ...
        }
    }];
}

- (void)setupPageControlCurrentPage:(NSInteger)currentPage{
    
    [self setupPageControlCurrentPage:currentPage
                            animation:NO];
}

- (CGSize) sizeForNumberOfPages:(NSUInteger)numberOfPages{

    CGFloat width = (numberOfPages - 1) * (kPageControlDotViewMargin + kPageControlDotViewSize) + kPageControlRoundedRectangleViewWidth;
    if (numberOfPages == 1) {
        width = kPageControlDotViewSize;
    }
    
    CGSize size = CGSizeMake(width, kPageControlDotViewSize + 20);
    
    return size;
}

@end

@implementation CAShapeLayer (DotLayer)

- (void) fillWithColor:(UIColor *)color{
    
    self.fillColor =
    self.strokeColor = color.CGColor;
}

@end
