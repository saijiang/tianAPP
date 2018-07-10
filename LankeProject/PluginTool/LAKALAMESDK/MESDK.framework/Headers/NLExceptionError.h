//
//  NLExceptionError.h
//  MTypeSDK
//
//  Created by su on 14-2-20.
//  Copyright (c) 2014年 suzw. All rights reserved.
//
#ifndef MTypeSDK_NLExceptionError_h
#define MTypeSDK_NLExceptionError_h

#import <Foundation/Foundation.h>
#import "NLExCode.h"
#import "NLException.h"

extern NSString *const NLErrorExceptionInfo;
extern NSString *const NLErrorCallStackSymbolsInfo;

@protocol NLExceptionError <NSObject>
@optional
+ (Class)exceptionClass;

@end

@interface NLExceptionError : NSError<NLExceptionError>
+ (id)errorWithCode:(NSInteger)code reason:(NSString*)reason;
+ (id)errorWithReason:(NSString*)reason;
- (NSException*)exception;
@end


@interface NLExceptionErrorStack : NSObject
+ (id)sharedInstance;
- (void)clearAll;
- (void)push:(NSError*)err;
- (NSError*)lastError;
@end

#endif
