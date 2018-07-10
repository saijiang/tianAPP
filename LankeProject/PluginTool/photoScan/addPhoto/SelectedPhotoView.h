//
//  SelectedPhotoView.h
//  图片选择
//
//  Created by itman on 15/10/19.
//  Copyright (c) 2015年 zhangtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"

#pragma mark---imageArrayBlock;

typedef void(^selectedPhotoBlock)(NSMutableArray *imageArray);


#pragma mark---ZTAddImageDelegate

@protocol SelectedPhotoDelegate <NSObject>

-(void)selectedImageArrayWith:(NSMutableArray *)imageArray;

@end

@interface SelectedPhotoView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>

/**
 *  存储所有的照片(UIImage)
 */
@property (nonatomic, strong) NSMutableArray *images;

/**
 *  每行显示数量
 */
@property (nonatomic, assign) int maxColumn;

/**
 *  最多显示图片个数
 */
@property (nonatomic, assign) int maxImageCount;

/**
 *  图片回传block
 */
@property (nonatomic, strong)selectedPhotoBlock selectedPhoto;

/**
 *  ZTAddImageDelegate
 */
@property (nonatomic, strong) id<SelectedPhotoDelegate>delegate;

/**
 *  图片回传block方法
 *
 *  @param imageArrayBlock 图片回传block
 */
-(void)selectedPhotoArrBlock:(selectedPhotoBlock )imageArrayBlock;

/**
 *  显示图片方法 浏览功能
 *
 *  @param frame    frame 这里初始化frame 会随着 每行显示数量 最多显示图片个数 去适应高度
 *  @param imageArr 图片数组 是ur 对象
 *
 *  @return self
 */
-(instancetype)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr;

@end

@interface DisplayImageView : UIView{
    NSInteger maxImagesCount;
    NSMutableArray * images;
}

@property (nonatomic ,assign) NSInteger maxColumn;

@property (nonatomic ,assign) CGFloat margin_h;
@property (nonatomic ,assign) CGFloat margin_v;

- (void) configImages:(NSArray *)images;

@end
