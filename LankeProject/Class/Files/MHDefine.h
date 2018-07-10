//
//  MHDefine.h
//  PerfectProject
//
//  Created by Meng huan on 14/12/3.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//




#import "MHLogDefine.h"
#import "MHPathDefine.h"
#import "MHViewDefine.h"
#import "MHLabelDefine.h"
#import "MHPersistentDefine.h"
#import "MHNotificationDefine.h"
#import "ColorDefine.h"
#import "ObjectEmptyDefine.h"

#ifndef PerfectProject_MHDefine_h
#define PerfectProject_MHDefine_h

/**
 *  在此处定义宏
 */

// 此App中使用的自定义字体名称
#define DEF_Font_DFShaoNvW5     @"DFShaoNvW5"
#define DEF_Font_8              @"8"
#define DEF_Font_akaDylanPlain  @"akaDylanPlain"
#define DEF_Font_MBXS           @"2.0-"

// 判断屏幕尺寸
#define IPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断ipad还是iphone
#define IPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IPhone  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// 获得工程信息
#define DEF_Version      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define DEF_BuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define DEF_AppName      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define DEF_ProjectName  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

// 获得设备ios版本
#define IOSVersion  [[[UIDevice currentDevice] systemVersion] floatValue]


// 此App中使用的自定义字体颜色
#define BM_RED [UIColor redColor]
#define BM_DARKGRAY [UIColor darkGray]
#define BM_LIGHTGRAY [UIColor lightGrayColor]
#define BM_WHITE [UIColor whiteColor]
#define BM_GRAY [UIColor grayColor]
#define BM_FONTGRAY [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]
#define BM_GREEN [UIColor greenColor]
#define BM_BLUE [UIColor blueColor]
#define BM_CYAN [UIColor cyanColor]
#define BM_YELLOW [UIColor yellowColor]
#define BM_MAGENTA [UIColor magentaColor]
#define BM_ORANGE [UIColor orangeColor]
#define BM_PURPLE [UIColor purpleColor]
#define BM_BROWN [UIColor brownColor]
#define BM_CLEAR [UIColor clearColor]
#define BM_BLACK [UIColor blackColor]


/**
 *  字体大小
 */
#define BM_FONTSIZE(f) [UIFont systemFontOfSize:f]
#define BM_FONTSIZE8 [UIFont systemFontOfSize:8.0]
#define BM_FONTSIZE9 [UIFont systemFontOfSize:9.0]
#define BM_FONTSIZE10 [UIFont systemFontOfSize:10.0]
#define BM_FONTSIZE11 [UIFont systemFontOfSize:11.0]
#define BM_FONTSIZE12 [UIFont systemFontOfSize:12.0]
#define BM_FONTSIZE13 [UIFont systemFontOfSize:13.0]
#define BM_FONTSIZE14 [UIFont systemFontOfSize:14.0]
#define BM_FONTSIZE15 [UIFont systemFontOfSize:15.0]
#define BM_FONTSIZE16 [UIFont systemFontOfSize:16.0]
//#define macro


#pragma mark -
#pragma mark Commom Color

/** 用于登录注册、以及其他底部的蓝色按钮颜色 */
#define BM_Color_Blue               [UIColor colorWithHexString:@"#53B1D9"]
/** 黑色，用于导航栏文字的颜色 */
#define BM_Color_NaviBarTitleColor  [UIColor colorWithHexString:@"#1F1F1F"]
/** textField的占位字符串颜色 */
#define BM_Color_Placeholder        [UIColor colorWithHexString:@"cdcdcd"]
/** 分割线的颜色 */
#define BM_Color_SeparatorColor     [UIColor colorWithHexString:@"#E6E6E6"]

#define BM_Color_GrayColor          [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1]
/** 99灰，用于不显著的副标题、订单信息等 */
#define BM_Color_huiColor [UIColor colorWithHexString:@"#999999"]
/** 33黑，用于主要标题 */
#define BM_Color_BlackColor         [UIColor colorWithHexString:@"#333333"]
/** 用于分割线 */
#define BM_Color_LineColor         [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]

#pragma mark - Weak Object

/**
 * @code
 * LKWeak(imageView, weakImageView);
 * [self testBlock:^(UIImage *image) {
 *         LKStrong(weakImageView, strongImageView);
 *         strongImageView.image = image;
 * }];
 *
 * // `LKWeak_(imageView)` will create a var named `weak_imageView`
 * LKWeak_(imageView);
 * [self testBlock:^(UIImage *image) {
 *         LKStrong_(imageView);
 *   _imageView.image = image;
 * }];
 *
 * // weak `self` and strong `self`
 * LKWeakSelf;
 * [self testBlock:^(UIImage *image) {
 *         LKStrongSelf;
 *         _self.image = image;
 * }];
 * @endcode
 */

#define LKWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define LKStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define LKStrong(weakVar, _var) LKStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define LKWeak_(var) LKWeak(var, weak_##var);
#define LKStrong_(var) LKStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define LKWeakSelf      LKWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define LKStrongSelf    LKStrong(__weakSelf, _self);

//
#define WeakSelf __weak __typeof(&*self) weakSelf = self;


#endif
