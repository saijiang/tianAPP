//
//  NSNull+InternalNull.m
//  MHProject
//
//  Created by 董駸 on 15/9/9.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "NSNull+InternalNull.h"

#define NullObjects @[@"",@0,@{},@[]]

@implementation NSNull (InternalNull)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (signature != nil) return signature;
    
    for (NSObject *object in NullObjects)
    {
        signature = [object methodSignatureForSelector:selector];
        
        if (signature)
        {
            if (strcmp(signature.methodReturnType, "@") == 0)
            {
                signature = [[NSNull null] methodSignatureForSelector:@selector(returnNil)];
            }
            break;
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0)
    {
        anInvocation.selector = @selector(returnNil);
        [anInvocation invokeWithTarget:self];
        return;
    }
    
    for (NSObject *object in NullObjects)
    {
        if ([object respondsToSelector:anInvocation.selector])
        {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:anInvocation.selector];
}

- (id)returnNil
{
    return nil;
}

@end
