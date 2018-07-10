//
//  NetworkImageView.m
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "NetworkImageView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface NetworkImageView ()
@property (nonatomic ,strong) NSString * imageURL;

@end
@implementation NetworkImageView

- (id)copyWithZone:(nullable NSZone *)zone
{
    NetworkImageView* contentView = [[NetworkImageView alloc] initWithFrame:self.frame];
    
    [contentView confiNetworkImageWith:self.imageURL];
    contentView.contentMode = UIViewContentModeScaleAspectFill;
    return contentView;
}


- (void)confiNetworkImageWith:(NSString *)imageURL{

    _imageURL = imageURL;
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

@end

@interface LKNetworkImageView ()

@property (nonatomic ,copy) void (^bCompleteBlock)(UIImage *img);

@property (nonatomic ,assign) BOOL completedLoadImage;

@end

@implementation LKNetworkImageView

- (void)dealloc
{
    _completedLoadImage = NO;
    [self sd_cancelCurrentImageLoad];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    LKNetworkImageView* contentView = [[LKNetworkImageView alloc] initWithFrame:self.frame];
    
    [contentView configNetworkImageWith:self.imageURL];
    return contentView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    self.placeholderImage = [UIImage imageNamed:@"default_restaurant"];
    self.shouldShowIndicator = YES;
    self.cacheOptions = (SDWebImageRetryFailed|SDWebImageContinueInBackground);
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.indicatorView.bounds = CGRectMake(0, 0, 20, 20);
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
}

#pragma mark -
#pragma mark Setter

- (void)setShouldShowIndicator:(BOOL)shouldShowIndicator{

    _shouldShowIndicator = shouldShowIndicator;

    if (shouldShowIndicator) {
        
        [self.indicatorView stopAnimating];
        [self.indicatorView setHidden:NO];
    }else{
        [self.indicatorView setHidden:YES];
    }
}

- (void)setBTouchEndBlock:(void (^)(LKNetworkImageView *))bTouchEndBlock{

    _bTouchEndBlock = [bTouchEndBlock copy];
    
    if (_bTouchEndBlock) {
        self.userInteractionEnabled = YES;
    }
}

- (void)setRefreshCached:(BOOL)refreshCached
{
    _refreshCached = refreshCached;
    if (_refreshCached) {
        self.cacheOptions |= SDWebImageRefreshCached;
    } else {
        self.cacheOptions &= (0xffff ^ SDWebImageRefreshCached);
    }
}

- (void)setImageURL:(NSURL *)imageURL
{
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
        
        if (self.shouldShowIndicator) [self.indicatorView startAnimating];
        
        if (self.completedLoadImage) {
            return;
        }
        LKWeakSelf
        [self sd_setImageWithURL:_imageURL placeholderImage:self.placeholderImage options:self.cacheOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            LKStrongSelf
            if (_self.shouldShowIndicator) [_self.indicatorView stopAnimating];
            
            if (image)
            {
                self.completedLoadImage = YES;
                if (self.bCompleteBlock) {
                    self.bCompleteBlock(image);
                }
                if ([_delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
                    [_delegate imageViewLoadedImage:_self];
                }
            }
            else
            {
                if ([_delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
                    [_delegate imageViewFailedToLoadImage:_self error:error];
                }
            }
        }];
        
    } else if (imageURL == nil) {
        
        self.image = self.placeholderImage;
    }
}

- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(self.frame.size, frame.size))
    {
        _adjustedPlaceholder = nil;
    }
    [super setFrame:frame];
}

- (void)setImage:(UIImage *)image
{
    if (image == self.placeholderImage)
    {
        if (!_adjustedPlaceholder) {
            _adjustedPlaceholder = [EGOPlaceholder adjustPlaceholderImage:image size:self.frame.size];
        }
        // bug here ,显示的图片尺寸不对，偏小了
//        image = _adjustedPlaceholder;
    }
    [super setImage:image];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage{

    _placeholderImage = placeholderImage;
    [self setImage:placeholderImage];
}

#pragma mark -
#pragma mark api

- (void)setImageURL:(NSURL *)imageURL complete:(void (^)(UIImage *))complete{

    self.bCompleteBlock = [complete copy];
    [self setImageURL:imageURL];
}

- (void)configNetworkImageWith:(NSURL *)imageURL{
    
    self.imageURL = imageURL;
}

#pragma mark - touches event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch)
    {
        CGPoint location = [touch locationInView:self];
        if (location.x < self.width && location.x > 0 &&
            location.y < self.height && location.y > 0)
        {
            [self callEvent];
        }
    }
}

- (void)callEvent
{
    if (_bTouchEndBlock) {
        _bTouchEndBlock(self);
    }
}

@end

@implementation EGOPlaceholder

+ (UIImage *)adjustPlaceholderImage:(UIImage *)image size:(CGSize)aSize
{
    if (!image) return nil;
    
    //更换了placeholder图片之后，要改下key
    NSString *key = [[NSString stringWithFormat:@"EGOPlaceholder-238-%@", NSStringFromCGSize(aSize)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UIImage *cachedImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    if (cachedImg) return cachedImg;
    
    CGFloat maxWidth = image.size.width*2;
    
    CGFloat width = aSize.width*2;
    CGFloat height = aSize.height*2;
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    
    CGRect imageRect = CGRectZero;
    if (width > height) {
        CGFloat s = MIN(maxWidth, height);
        imageRect = CGRectMake((width-s)/2, (height-s)/2, s, s);
    }else{
        CGFloat s = MIN(maxWidth, width);
        imageRect = CGRectMake((width-s)/2, (height-s)/2, s, s);
    }
    
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *resultImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (resultImage) [[SDImageCache sharedImageCache] storeImage:resultImage forKey:key];
    
    return resultImage;
}

@end
