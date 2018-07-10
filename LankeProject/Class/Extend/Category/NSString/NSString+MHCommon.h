//
//  NSString+MHCommon.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSString 通用Category
 */
@interface NSString (MHCommon)


#pragma mark - 过滤html特殊字符
/**
 *  过滤html特殊字符
 *
 *  @return 过滤后的string
 */
- (NSString *)ignoreHTMLSpecialString;


#pragma mark - 过滤.net接口返回值的xml外包装
/**
 *  过滤.net接口返回值的xml外包装，例如：
 *  <?xml version="1.0" encoding="utf-8"?>
 *  <string xmlns="http://tempuri.org/">{"result":"1","data":[{"User_Id":"32","User_Name":"nanq@bluemobi.cn"}]}</string>
 *  服务器返回的数据格式是xml中包JSON，所以要过滤掉外层的xml，直接返回json字符串
 *
 *  @return 过滤后的string
 */
- (NSString *)ignoreDotNetSpecialString;


#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @return MD5加密后的新字段
 */
- (NSString *)md5;


#pragma mark - URL编码
/**
 *  URL编码，http请求遇到汉字的时候，需要转化成UTF-8
 *
 *  @return 编码的字符串
 */
- (NSString *)urlCodingToUTF8;


#pragma mark - URL解码
/**
 *  URL解码，URL格式是 %3A%2F%2F 这样的，则需要进行UTF-8解码
 *
 *  @return 解码的字符串
 */
- (NSString *)urlDecodingToUrlString;


#pragma mark - 文本国际化
/**
 *  文本国际化
 *
 *  @param dict 文本字典
 *
 *  @return 国际化之后的文本
 */
+ (NSString *)stringByI18nDict:(NSDictionary *)dict;

/** 将时间戳转换成传入的时间格式字符串
 like that :@"yyyy-MM-dd HH:mm"
 */
- (NSString *) stringformatterDate:(NSString *)formatter;

NSString * NSStringWithData(id data);

NSString * NSStringWithNunull(id data);

+ (NSString *) string:(id)data;
@end
