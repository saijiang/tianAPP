//
//  AlertMessage.h
//  MHProject
//
//  Created by 董駸 on 16/1/7.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

//提示框文字此m文件输入 使用时直接调用 方便后期修改管理

#import <Foundation/Foundation.h>

@interface AlertMessage : NSObject

// alert标题
UIKIT_EXTERN NSString *const alertTitle;

// 网络连接失败提示
UIKIT_EXTERN NSString *const networkWarning;

@end
