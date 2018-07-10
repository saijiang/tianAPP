//
//  NLDefines.h
//  MTypeSDK
//
//  Created by su on 15/6/30.
//  Copyright © 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CString(s, ... ) [NSString stringWithFormat:s, ##__VA_ARGS__]
#define NLStringSelector(method) NSStringFromSelector(@selector(method))
#define NSLogObj(obj) NSLog(@"%@", obj);


#define MAIN_ASYNC(block) \
dispatch_async(dispatch_get_main_queue(), block);

#define MAIN_SYNC(block) \
dispatch_sync(dispatch_get_main_queue(), block);

#define MainPerform(target,action,object) [target performSelectorOnMainThread:action withObject:object waitUntilDone:NO]
#define MainIfPerform(target,action,object) if (target && [target respondsToSelector:action]) {MainPerform(target,action,object);}
#define MainPerformTimeOut(target,action,object,timeOut) [target performSelector:action withObject:object afterDelay:timeOut]


/**
 * 主密钥索引
 */
#define NL_DEFAULT_MK_INDEX 1
/**
 * 默认PIN加密工作密钥索引
 */
#define NL_DEFAULT_PIN_WK_INDEX 2
/**
 * 默认MAC加密工作密钥索引
 */
#define NL_DEFAULT_MAC_WK_INDEX 3
/**
 * 默认磁道加密工作密钥索引
 */
#define NL_DEFAULT_TRACK_WK_INDEX 4

/*!
 @enum NLDeviceParamsTag
 @abstract 设备参数tag
 @constant NLDeviceParamsTagMerchNo 商户号存放
 @constant NLDeviceParamsTagTerminalNo 终端号存放
 @constant NLDeviceParamsTagWkUpdateDate 工作密钥存放
 @constant NLDeviceParamsTagDeviceType pos标识存放
 @constant NLDeviceParamsTagMerchName 终端号存放
 */
typedef enum {
    NLDeviceParamsTagMerchNo = 0xFF9F11,
    NLDeviceParamsTagTerminalNo = 0xFF9F12,
    NLDeviceParamsTagWkUpdateDate = 0xFF9F13,
    NLDeviceParamsTagDeviceType = 0xFF9F14,
    NLDeviceParamsTagMerchName = 0xFF9F15
} NLDeviceParamsTag;


#define ExCode_GET_TRACKTEXT_FAILED 1003
#define ExCode_GET_PININPUT_FAILED 1004

#define localKey(key) NSLocalizedString(key, nil)
