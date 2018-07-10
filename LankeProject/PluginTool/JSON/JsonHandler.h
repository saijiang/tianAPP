//
//  JsonHandler.h
//  BlueMobiProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Json解析Handler类
 */
@interface JsonHandler : NSObject

/**
 *  json解析
 *
 *  @param string               数据源
 *
 *  @return 解析后的数据
 */
+ (id)JSONValue:(NSString *)string;

@end
