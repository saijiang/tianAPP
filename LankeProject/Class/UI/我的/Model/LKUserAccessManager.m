//
//  LKUserAccessManager.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/29.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKUserAccessManager.h"
#import "LoginViewController.h"

@implementation LKUserAccessManager

+ (void) userNextStepJudgeAccessLoginHandle:(void(^)())loginHandle
                               normalHandle:(void(^)())normalHandle{

    if ([KeychainManager islogin]) {
        //同步资料
        [UserServices getUserInfoWithuserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
            
        }];
        if (normalHandle) {
            normalHandle();
        }
    }else{
    
        if (loginHandle) {
            loginHandle();
        }else{
        
            LoginViewController * login = [[LoginViewController alloc] init];
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:login];
            [KAPPDELEGATE.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
}

@end
