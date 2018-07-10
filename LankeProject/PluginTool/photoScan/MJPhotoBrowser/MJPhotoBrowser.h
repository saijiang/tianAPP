//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^PhotoOffBlock)(NSUInteger  currentPhotoIndex);

typedef void(^PhotoSelectedBlock)(NSMutableArray *selectedArray);

@protocol MJPhotoBrowserDelegate;
@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

//偏移block
@property (copy,nonatomic)PhotoOffBlock offBlock;


@property (copy,nonatomic)PhotoSelectedBlock seletedBlock;

/**
 *  添加
 */
@property (assign,nonatomic)BOOL  isShowButton;

@property (strong,nonatomic)NSMutableArray *selectArray;

// 显示
- (void)show;
@end

@protocol MJPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end