//
//  NetworkImageView.h
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkImageView : UIImageView

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

- (void) confiNetworkImageWith:(NSString *)imageURL;
@end

@protocol EGOImageViewDelegate;

@interface LKNetworkImageView : UIImageView<NSCopying>

{
    NSURL       *_imageURL;
    UIImage     *_placeholder;
    UIImage     *_adjustedPlaceholder;
}

/** imageURL */
@property (nonatomic, strong) NSURL *imageURL;
/** placeholder */
@property (nonatomic, strong) UIImage *placeholderImage;
/** ImageOptions,  */
@property (nonatomic, assign) NSUInteger cacheOptions;
/** Loading框 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
/** 是否展示加载中,default is YES */
@property (nonatomic, assign) BOOL shouldShowIndicator;
/** 设置为YES时，cache由NSURLCache管理*/
@property (nonatomic, assign) BOOL refreshCached;
/** 点击事件 */
@property (nonatomic,   copy) void (^bTouchEndBlock)(LKNetworkImageView *imageView);

@property(nonatomic, weak) id<EGOImageViewDelegate> delegate;

/** 用于加载完图片之后进行图片的blur等图像操作
    这样做在列表中很卡，待优化
 */
- (void) setImageURL:(NSURL *)imageUrl complete:(void(^)(UIImage *image))complete;

- (void) configNetworkImageWith:(NSURL *)imageURL;
@end

#define EGOImageView LKNetworkImageView

@protocol EGOImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImage:(EGOImageView*)imageView;
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error;
@end

@interface EGOPlaceholder : NSObject

+ (UIImage *)adjustPlaceholderImage:(UIImage *)image size:(CGSize)aSize;

@end

