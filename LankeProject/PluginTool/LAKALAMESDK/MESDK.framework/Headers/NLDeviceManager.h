//
//  NLDeviceManager.h
//  MTypeSDK
//
//  Created by su on 15/12/16.
//  Copyright © 2015年 newland. All rights reserved.
//

#import "NLModule.h"
#import "NLFileOperateResult.h"

@protocol NLDeviceManager <NLModule>
/*!
 @method
 @abstract 配置文件写入
 */
- (BOOL)writeFileWithFileName:(NSString*)fileName fileType:(NLFileType)fileType  contentLength:(int)len contentOffset:(int)offset data:(NSData*)data;
/*!
 @method
 @abstract 配置文件操作
 */
- (NLFileOperateResult*)operateFileWithOperateType:(NLFileOperateType)opType fileType:(NLFileType)fileType data:(NSData*)data;
@end
