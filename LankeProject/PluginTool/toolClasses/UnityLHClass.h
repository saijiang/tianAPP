//
//  UnityLH.h
//  UnityLH
//  工具类
//  Created by apple on 13-5-30.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import"MBProgressHUD.h"

@interface UnityLHClass : NSObject


+ (UnityLHClass*)shareUnityClassObject;

//初始化系统控件

+(UIImageView*)initUIImageView:(NSString*) imageName rect:(CGRect)rectImage;

/**
 *  系统控件 UIButton的初始化
 *
 *  @param rectButton rectButton description
 *  @param strName    strName description
 *
 *  @return return value description
 */
+(UIButton*)initButton:(CGRect)rectButton str:(NSString*)strName;
//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  获取字符串的高度
 *
 *  @param str  str description
 *  @param th   th description
 *  @param size size description
 *
 *  @return return value description
 */
+ (float)getHeight:(NSString *)str wid:(CGFloat)th font:(CGFloat)size;

//获得字符串宽度
+ (float)getWidth:(NSString *)str wid:(CGFloat)th font:(CGFloat)size;

//根据字符串的宽度获取size
+ (float)getboldWidth:(NSString *)str wid:(CGFloat)th font:(CGFloat)size;
/**
 *  初始化系统弹出框
 *
 *  @param str str description
 */
+(void)showAlertView:(NSString*)str;

/**
 *  判断字符是否为  整形
 *
 *  @param string string description
 *
 *  @return return value description
 */
+ (BOOL)isPureInt:(NSString *)string;

/**
 *  判断字符串是否为 浮点型
 *
 *  @param string string description
 *
 *  @return return value description
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  判断手机号
 *
 *  @param str str description
 *
 *  @return return value description
 */
+ (BOOL)checkTel:(NSString *)str;

/**
 *  判断邮箱地址是否合法
 *
 *  @param candidate 邮箱
 *
 *  @return 返回BOOL
 */
+ (BOOL) validateEmail: (NSString *) candidate;

/**
 *  判断身份证号是否合法
 *
 *  @param cardId cardId description
 *
 *  @return return value description
 */
+ (BOOL)UserCard:(NSString *)cardId;


/**
 *  系统textField的初始化
 *
 *  @param rectText rectText description
 *
 *  @return return value description
 */
+ (UITextField*)initTextFilerect:(CGRect) rectText;

/**
 *  获取系统时间
 *
 *  @return 字符串格式的系统时间
 */
+(NSString*)getCurrentTime;

/**
 *  Description
 *
 *  @param strPass strPass description
 *
 *  @return return value description
 */
+(NSString*)strState:(NSString*) strPass;

/**
 *  时间截取
 *
 *  @param strTime strTime description
 *
 *  @return return value description
 */
+(NSString*)strSepTime:(NSString*)strTime;
/**
 *  金额大小写转换
 *
 *  @param numStr numStr description
 *
 *  @return return value description
 */
+(NSString *)converter:(NSString *)numStr;

/**
 *  系统控件UILabel的初始化
 *
 *  @param strTitle  内容
 *  @param font      字体大小
 *  @param textColor 文字颜色
 *  @param rectText  frame
 *
 *  @return UILabel
 */
+(UILabel*)initUILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor  rect:(CGRect) rectText;

/**
 *  自动布局样式的label
 *
 *  @param strTitle  strTitle description
 *  @param font      font description
 *  @param textColor textColor description
 *
 *  @return return value description
 */
+ (UILabel *)masonryLabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor;

/**
 *  自动布局样式的field
 *
 *  @param strTitle  strTitle description
 *  @param font      font description
 *  @param textColor textColor description
 *
 *  @return return value description
 */
+ (UITextField *)masonryField:(NSString*)strTitle font:(float)font color:(UIColor*)textColor;

/**
 *  自动布局样式的Button
 *
 *  @param strTitle  strTitle description
 *  @param font      font description
 *  @param textColor textColor description
 *
 *  @return return value description
 */
+ (UIButton *)masonryButton:(NSString*)strTitle font:(float)font color:(UIColor*)textColor;


/**
 *  自动布局样式的Button
 *
 *  @param strTitle  strTitle description
 *  @param font      font description
 *  @param textColor textColor description
 *
 *  @return return value description
 */
+ (UIButton *)masonryButton:(NSString*)strTitle imageStr:(NSString *)imageStr font:(float)font color:(UIColor*)textColor;
/**
 *  手机号码中间位数的隐藏
 *
 *  @param phone 手机号码
 *
 *  @return 隐藏操作
 */
+ (NSString *)phoneNumberFromat:(NSString *)phone;

/**
 *  获取textView的高度
 *
 *  @param textView  textView对象
 *  @param strText   文字内容
 *  @param font      文字大小
 *  @param Textwidth textView的宽度
 *
 *  @return 返回高度值
 */
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText textFont:(UIFont *)font textWidth:(int)Textwidth;

/**
 *  获取字符串的size
 *
 *  @param str  字符串
 *  @param th   th description
 *  @param size size description
 *
 *  @return return value description
 */
+ (CGSize)getWithsize:(NSString *)str wid:(CGFloat)th font:(CGFloat)size;


/**
 *  比较2个时间的大小
 *
 *  @param firstDate firstDate description
 *  @param secDate   secDate description
 *
 *  @return return value description
 */
+ (int)compareDate:(NSString *)firstDate seconedDate:(NSString *)secDate;


/**
 *  图+文字的组合控件
 *
 *  @param frame      整个控件frame
 *  @param imageFrame 图的frame
 *  @param imageStr   图的image
 *  @param font       文字字体大小
 *  @param labelStr   文字内容
 *  @param color      文字颜色
 *
 *  @return 返回当前控件
 */
+ (UIView *)imageAndLabelWithFrame:(CGRect)frame imageFrame:(CGRect)imageFrame image:(UIImage *)imageStr labelFont:(int)font label:(NSString *)labelStr labelColor:(UIColor *)color;


/**
 *  2个价格的控件 一个当前优惠  一个老价格  做电商怎么能没有这么牛B的控件
 *
 *  @param frame      整个控件的宽度
 *  @param firstStr   第一个价格
 *  @param firstColor 颜色
 *  @param firstFont  字体
 *  @param twoStr     第二个价格
 *  @param twoColor   颜色
 *  @param twoFont    字体
 *  @param heightAltitude   高度差
 *
 *  @return 返回控件
 */
+ (UIView *)twoPriceControllerWithWidth:(CGRect)frame firstPrice:(NSString *)firstStr firstPriceColor:(UIColor *)firstColor firstPriceFont:(int)firstFont twoPrice:(NSString *)twoStr twoPriceColor:(UIColor *)twoColor twoPriceFont:(int)twoFont heightAltitude:(int)height lineColor:(UIColor *)lineColor;



#pragma mark -去除所有多余的线条
/**
 *  针对TableView的功能
 *
 *  @param tableView tableview
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView;


/**
 *  日期转换为礼拜
 *
 *  @param inputDate data类型数据
 *
 *  @return return value description
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;


/**
 *  系统时间月份转换为中文
 *
 *  @param valueStr 传入值
 *
 *  @return return value description
 */
+ (NSString *)monthWithChinaStr:(NSString *)valueStr;


/**
 *  系统时间 日 转换为中文
 *
 *  @param valueStr 传入值
 *
 *  @return return value description
 */
+ (NSString *)dayWithChinaStr:(NSString *)valueStr;

/**
 *  获取农历日期
 *
 *  @param date date description
 *
 *  @return return value description
 */
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;
/**
 *  获取时间差
 *
 *  @param date date description
 *
 *  @return return value description
 */
+(NSString *) returnUploadTimeWithFirstTime:(NSString*)first secTime:(NSString*)sec;


/**
 *  获取时间差只有月日
 *
 *  @param date date description
 *
 *  @return return value description
 */
+(NSString *) returnUploadDateWithFirstTime:(NSString*)first secTime:(NSString*)sec;

/**
 *  带格式的现在时间格式
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getCurrentTimeWith:(NSString *)type;



/**
 *  判断手机号格式是否规范
 *
 *  @param password password description
 *
 *  @return return value description
 */
+ (BOOL)getPasswordGood:(NSString *)password;

/**
 *  消息提示
 *
 *  @param title <#title description#>
 */
+(void) showHUDWithStringAndTime:(NSString *)title;
#pragma mark - 比较2个时间的大小 只包含年月日
+ (int)compareNewDate:(NSString *)firstDate seconedDate:(NSString *)secDate;
/**
 *  时间戳转换为当前时间
 *
 *  @param time <#time description#>
 *
 *  @return return value description
 */
+(NSString *)getCurrentTimeWithSince1970:(NSString *)time;

//时间格式转换
+(NSString*)getCurrentTimeWithType:(NSString *)type andTimeString:(NSString *)time;

//去掉字符串中的html标签的方法
+(NSString *)filterHTML:(NSString *)html;

/**
 *  获取view的高度
 *
 *  @param view view description
 *
 *  @return return float description
 */
+(float)getHightWithView:(UIView *)view;

/*
 拨打电话
 @param tel tel description
 
 */
+ (BOOL)callTel:(NSString *)tel;

@end


