//
//  UMStatistical.h
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface UMManager : NSObject<UMSocialUIDelegate>

singleton_for_header(UMManager)

-(void)loadTheConfiguration;

///** 自动页面时长统计, 开始记录某个页面展示时长.
// 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
// 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
// @param pageName 统计的页面名称.
// @return void.
// */
//+ (void)beginLogPageView:(UIViewController *)pageName;
//
///** 自动页面时长统计, 结束记录某个页面展示时长.
// 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
// 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
// @param pageName 统计的页面名称.
// @return void.
// */
//+ (void)endLogPageView:(UIViewController *)pageName;

-(void)shareTitle:(NSString *)title shareUrl:(NSString *)url shareText:(NSString *)shareText shareImage:(UIImage *)shareImage;


@end
