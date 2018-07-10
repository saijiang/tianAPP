//
//  NLFileOperateResult.h
//  MTypeSDK
//
//  Created by su on 15/12/16.
//  Copyright © 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @enum
 @abstract 文件类型
 @discussion
 */
typedef enum {
    /**
     * 删除
     */
    NLFileOperateTypeDelete,
    /**
     * 读回
     */
    NLFileOperateTypeRead,
} NLFileOperateType;


/*!
 @enum
 @abstract 文件操作类型
 @discussion
 */
typedef enum {
    /**
     * 开机文件
     */
    NLFileTypePowerOn,
    /**
     * 卡操作脚本
     */
    NLFileTypeCardScript,
    /**
     * 文件名
     */
    NLFileTypeFileName
} NLFileType;

@interface NLFileOperateResult : NSObject
@property (nonatomic, assign, readonly) NLFileOperateType fileOperateType; // 文件操作
@property (nonatomic, assign, readonly) NLFileType fileType; // 文件类型
@property (nonatomic, copy, readonly) NSData *data;
- (id)initWithFileOperateType:(NLFileOperateType)fileOperateType fileType:(NLFileType)fileType data:(NSData*)data;
@end
