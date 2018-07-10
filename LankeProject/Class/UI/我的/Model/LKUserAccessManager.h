//
//  LKUserAccessManager.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/29.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于管理登录与非登录用户的操作权限
 
*/
@interface LKUserAccessManager : NSObject

+ (void) userNextStepJudgeAccessLoginHandle:(void(^)())loginHandle
                               normalHandle:(void(^)())normalHandle;

@end
