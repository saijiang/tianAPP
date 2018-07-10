//
//  DQTouchID.m
//  MHProject
//
//  Created by 董駸 on 16/1/21.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "DQTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface DQTouchID ()

@property (strong,nonatomic) NSString *message;

@property (strong,nonatomic) NSString *backTitle;

@end

@implementation DQTouchID

- (id)checkTouchIDWithMessage:(NSString *)message backTitle:(NSString *)backTitle
{
    if (self)
    {
        self.message = message;
        self.backTitle = backTitle;
    }
    return self;
}

- (void)startCheckWithResultBlock:(ResultBlock)resultBlock
{
    self.resultBlock = resultBlock;
    
    LAContext *context = [[LAContext alloc]init];
    
    context.localizedFallbackTitle = self.backTitle;
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:self.message reply:^(BOOL success, NSError * _Nullable error)
         {
            if (success) {
                if (self.resultBlock) {
                    self.resultBlock (1);
                }
            } else if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed: {
                        if (self.resultBlock) {
                            self.resultBlock (2);
                        }
                    }
                        break;
                    case LAErrorUserCancel: {
                        if (self.resultBlock) {
                            self.resultBlock (3);
                        }
                    }
                        break;
                    case LAErrorUserFallback: {
                        if (self.resultBlock) {
                            self.resultBlock (4);
                        }
                    }
                        break;
                    case LAErrorSystemCancel:{
                        if (self.resultBlock) {
                            self.resultBlock (5);
                        }
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled: {
                        if (self.resultBlock) {
                            self.resultBlock (6);
                        }
                    }
                        break;
                    case LAErrorPasscodeNotSet: {
                        if (self.resultBlock) {
                            self.resultBlock (7);
                        }
                    }
                        break;
                    case LAErrorTouchIDNotAvailable: {
                        if (self.resultBlock) {
                            self.resultBlock (8);
                        }
                    }
                        break;
                    case LAErrorTouchIDLockout: {
                        if (self.resultBlock) {
                            self.resultBlock (9);
                        }
                    }
                        break;
                    case LAErrorAppCancel:  {
                        if (self.resultBlock) {
                            self.resultBlock (10);
                        }
                    }
                        break;
                    case LAErrorInvalidContext: {
                        if (self.resultBlock) {
                            self.resultBlock (11);
                        }
                    }
                        break;
                }
            }
        }];
    } else {
        if (self.resultBlock) {
            self.resultBlock (0);
        }
    }
}

@end