//
//  LKCustomViewProtocol.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKProtocolExtension.h"

@protocol LKCustomViewProtocol <NSObject>

@optional;

/**
 *  初始化控件
 *  @return view
 */
+ (instancetype) view;

/**
 *  加载数据
 *  @return
 */
- (void) config:(id)data;

/**
 *  视图高度
 *  @return height
 */
+ (CGFloat) height;

/**
 *  根据数据返回视图高度
 *  @return height
 */
+ (CGFloat) height:(id)data;

@end

/*
 @defs(LKCustomViewProtocol)
 
 + (instancetype) view{
 
 return [[self alloc] init];
 }
 
 + (CGFloat) height{
 
 return 100.0f;
 }
 
 + (CGFloat) height:(id)data{
 
 return [self height];
 }
 
 @end
 */
